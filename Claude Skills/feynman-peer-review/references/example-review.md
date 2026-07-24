# Worked Example: One Finding, Start to Finish

This is a compact, end-to-end trace of a single review — small enough to read in one sitting,
real enough to show the mechanics. It exists to calibrate two things: the **voice** of each lens
(they should sound like different people), and the **mechanics** of the Severity Bridge (how a
raw finding turns into a ranked, actionable item). Consult it before the first review of a
session, or whenever a lens's voice starts drifting toward the others.

The artifact under review is deliberately small — a single endpoint — so the full pipeline fits
on one page. A real review runs the same steps across many more findings.

---

## The artifact under review

```js
// routes/orders.js
router.delete('/orders/:id', async (req, res) => {
  const order = await Order.findById(req.params.id);
  await order.remove();
  res.sendStatus(204);
});
```

Context supplied by the author: "Quick endpoint to let support staff cancel bad orders. Ships
this sprint. Auth middleware is applied globally on the router, so I didn't add anything extra
here."

---

## Pass 1 — Feynman Check (abbreviated)

**Plain-language restatement:** This endpoint deletes an order by ID when called. It exists so
support staff can remove erroneous orders.

**Where the explanation breaks down:** "Auth middleware is applied globally on the router" is
asserted, not shown — the snippet doesn't include the router setup, so it can't be verified from
what's in front of us. That's a `comprehension gap (need info)`: routed to the author, not ranked.

Separately: nothing here checks *which* orders support staff are allowed to cancel, or logs who
cancelled what. If that's absent from the design entirely (not just this snippet), that's
`design murk (artifact's fault)` — Feynman can't explain how accountability works here, and
that gap becomes Engineer/Architect findings below.

---

## Pass 2 — Architect Lens (abbreviated, in voice)

> A hard delete on an order record is a one-way door dressed up as a two-line handler. Once
> `order.remove()` runs, the order, its line items, and whatever audit trail depended on its
> existence are gone — no soft-delete flag, no tombstone, no event emitted for downstream
> systems (billing, inventory, analytics) that may have already reacted to this order's
> existence. If any other service holds a foreign key or a cached copy, this creates silent
> orphans with no way to reconcile after the fact. That's the finding that matters here; the
> auth question is real but secondary to a decision that can't be undone.

---

## Pass 3 — Engineer Lens (abbreviated, in voice)

> `routes/orders.js:2-5` — `will break`. Two things, same handler:
>
> 1. No authorization check scoped to this action. "Global auth middleware" (per the author)
>    likely confirms the caller is *authenticated*, not that they're *allowed to delete orders*.
>    Those are different guarantees and the code conflates them.
> 2. `Order.findById` result isn't checked for `null` before `.remove()` is called. An
>    already-deleted or bad ID throws inside the handler with no try/catch — that's an unhandled
>    500 on a route that will get hit by scripts and typos alike.
>
> What "done right" looks like: a role check specific to `orders:delete`, a 404 on missing
> record, and — given the Architect's point — a soft delete (`status: 'cancelled'`) instead of
> `.remove()`, with the hard-delete path (if it's ever needed) gated far more tightly.

---

## Pass 4 — Devil's Advocate (abbreviated, in voice)

> "Auth middleware is applied globally" — based on what, a comment in a Slack thread? I don't
> see it in this file and I'm not taking it on faith. Best case, this is any authenticated user
> in the system permanently destroying order records with a single unauthenticated-looking curl
> command copy-pasted wrong. Worst case, it's already been hit by a support tool retry loop and
> nobody's noticed because there's no log line, no audit row, nothing — the data just isn't
> there anymore and everyone assumes it never existed. Show me the test that proves only
> authorized support staff can hit this route. Show me the rollback path when someone deletes
> the wrong order by transposing two digits in the ID. There isn't one. This is a landmine with
> a REST verb on it.

*(Note the deliberate escalation — "landmine," "nobody's noticed" — stated as the worst case on
purpose. The Synthesis pass below is what turns this into something calibrated.)*

---

## The Severity Bridge, applied to one finding

Take the authorization gap specifically and run it through the bridge.

**Who raised it, and how:**

| Lens | What it said | Native label |
|---|---|---|
| Engineer | No action-scoped authorization check | `will break` |
| Architect | (Raised the delete-semantics issue, not this one directly — see Job 2 below) | — |
| Devil's Advocate | "Any authenticated user... permanently destroying order records" | uncalibrated candidate |
| Feynman | The auth claim was an unverified assertion | `comprehension gap` (routed to author, not ranked) |

**Translate to Impact:** `will break` maps to the Engineer row of the Impact table. Is there a
reversibility multiplier? The *deletion* is a one-way door (Architect's point), and this finding
is what lets an unauthorized actor trigger that one-way door — so the multiplier applies here
too. Impact → **High**.

**Translate to Effort:** A scoped authorization check on one route, no schema change, no
migration. **Low** effort.

**Confidence:** Two fair lenses independently support this — Engineer raised it directly, and
Feynman's comprehension gap is exactly the same claim viewed from a different angle (the author
never substantiated it). That's real signal even without a third. **Two fair lenses → high
confidence**, not "all three, top of band" — be precise about what was actually independently
corroborated.

**The Devil's Advocate cross-check:** Its "any authenticated user... permanently destroying
records" claim is the *same* finding the Engineer raised, just with the volume turned up. Because
a fair lens independently hit it, this is Job 1's "real fire" case: the DA's finding is confirmed,
not discounted — it just doesn't get to keep its inflated framing. The final entry uses the
bridge's translated Impact/Effort, not the Devil's Advocate's "landmine" framing.

---

## Where it lands in the Synthesis

```
#1 — Impact: High · Effort: Low · Confidence: High (2 fair lenses)
Missing action-scoped authorization on DELETE /orders/:id — any authenticated caller can
permanently remove an order record. Confirmed independently by the Engineer lens (unscoped
handler) and the Feynman check (the "global auth" claim was never substantiated in what's
shown). The Devil's Advocate raised the same gap; its worst-case framing is dropped in favor
of the concrete fix below.
→ Fix: add an `orders:delete`-scoped authorization check before the lookup; return 403 on
  failure. Low effort, ships same sprint as the endpoint itself.
```

This sits in the **High-Impact / Low-Effort quadrant** — the "do this now" list — precisely
*because* the fix is cheap relative to the exposure. Compare that to the Architect's hard-delete
finding: also High Impact (it's the one-way door itself), but **Medium-to-High Effort** (soft
delete requires a schema field, a status-aware read path everywhere the order is queried, and
coordination with anything downstream that currently assumes deletion means gone). That one
ranks below the auth fix despite being arguably the "bigger" architectural issue — Effort is
part of the ranking, not an afterthought.

---

## Takeaways for calibrating a new review

- **The voices stay separable even when they're talking about the same code.** The Architect
  never mentions auth; the Engineer treats the delete-semantics issue as background, not its
  headline; the Devil's Advocate compresses both into one worst-case narrative. If a draft review
  reads like one author wrote all four sections, the voices have collapsed — rewrite before
  moving on.
- **A Devil's Advocate finding earns its place by corroboration, not by volume.** The "landmine"
  language never appears in the final ranked list. What earns a slot is the plain-language fix,
  at a calibrated severity, credited to whichever fair lens(es) actually support it.
- **Effort is not a tiebreaker — it's load-bearing.** The higher-Impact architectural finding
  ranks *below* the cheaper auth fix. Impact sets the band; Effort decides where you land inside
  it.
- **A `comprehension gap` can still matter even though it's never ranked.** Here it corroborated
  a ranked finding instead of sitting outside the review as a dangling question. Watch for that
  pattern — Feynman gaps often turn out to be the same hole another lens found from a different
  angle.
