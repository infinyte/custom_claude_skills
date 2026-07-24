---
name: pragmatic-engineering
description: >
  Applies Andrew Hunt and David Thomas's Pragmatic Programmer discipline as a general
  engineering operating style: own the result beyond the local edit, keep one authoritative
  source for each piece of system knowledge (DRY), preserve orthogonality between components,
  keep decisions reversible until evidence justifies commitment, and automate repeatable
  work. Use as a baseline for any engineering task, not tied to a specific moment like
  refactoring or production deployment. Trigger on phrases like "how should I approach this",
  "is this the right way to build this", "this keeps breaking in unrelated places", or "we
  keep doing this by hand". Distilled from Hunt and Thomas's book via the agent-rules-books
  project (MIT licensed); references/full-reference.md carries the complete rule set for deep
  audits.
metadata:
  version: 1.0.0
---

# Pragmatic Engineering

## Purpose

This skill applies the discipline of Andrew Hunt and David Thomas's *The Pragmatic
Programmer*: work pragmatically rather than dogmatically, take responsibility for the
outcome beyond the edit in front of you, and keep the system easy to change through DRY
knowledge ownership, orthogonal design, reversible decisions, and habitual automation. Unlike
`refactoring-pass` (fixing existing structure) or `legacy-code-safety` (working safely around
untested structure), this skill isn't tied to a specific moment — it's the general operating
style this skill collection assumes by default, and the other rule-based skills here layer
more specific discipline on top of it for their particular moment.

The rule set below is a compressed, decision-oriented distillation of the book — not the book
itself, not a substitute for it, and not officially affiliated with Hunt, Thomas, or their
publisher. It was adapted from the `the-pragmatic-programmer.mini.md` rule set in
[agent-rules-books](https://github.com/ciembor/agent-rules-books) (MIT licensed, © Maciej
Ciemborowicz), itself a distillation of the book's content, reshaped here into skill form.
See `references/full-reference.md` for the fuller rule set this was compressed from, and
`references/nano-quick-reference.md` for an even tighter fallback when context budget is very
tight.

**When this doesn't fit:** a throwaway spike or prototype whose whole point is to learn
something fast doesn't need full ownership-and-automation discipline applied to it — see
Proportionality below. It also doesn't replace the more specific skills in this collection:
reach for `refactoring-pass` when the moment is specifically about restructuring existing
code, `legacy-code-safety` when the code lacks trustworthy tests, `software-design-simplicity`
when the moment is about designing a module or interface, or `production-reliability` when the
moment is about surviving production failure. This skill is the baseline underneath all of
them.

---

## Primary bias to correct

Local code changes still have system-level consequences. The failure mode this skill guards
against is optimizing only for the edit directly in front of you — the requested feature, the
familiar ritual, the quick fix — while ignoring what it costs everywhere else: duplicated
knowledge, tangled coupling, an irreversible commitment made too early, or one more manual step
nobody automated. Own the result, not just the diff.

---

## Proportionality

Apply this discipline in proportion to how much the work is actually going to be lived with —
not identically on every task.

- **Throwaway / spike / pure learning exercise:** skip most of this. The point is to learn
  something fast; don't spend effort on DRY ownership, reversibility, or automation for code
  that's about to be discarded. Do keep prototype code honestly labeled as a prototype so it
  doesn't silently become production.
- **Greenfield / pre-production:** apply reversibility and orthogonality early — this is the
  cheapest moment to avoid hard-coding a vendor, database, or deployment assumption that will
  be expensive to walk back later.
- **Production / actively-evolving code with real consumers:** apply the full discipline —
  DRY ownership, orthogonal boundaries, explicit contracts, automated repeatable work, fast
  feedback loops.
- **Mature / long-lived code that many things depend on:** apply the full discipline, and
  weight the Broken Windows rule more heavily than usual — small decay compounds longest here,
  and "someone will clean it up later" rarely happens on code this old.

When in doubt about which band applies, ask rather than guessing — the cost of asking is one
sentence; the cost of guessing wrong is either wasted rigor on disposable code or a shortcut
that quietly becomes permanent.

---

## Decision rules

- Be pragmatic, not dogmatic: choose the practice, formality, quality level, and stopping
  point that improves real outcomes for the users, risks, and codebase — not ceremony for its
  own sake.
- Own the result. Surface tradeoffs, risks, uncertainty, and avoidable design costs instead of
  blaming tools, framework defaults, schedule pressure, or existing style.
- Think beyond the local edit: quick fixes that multiply future maintenance cost are usually a
  bad bargain; leave touched areas better where the cost is low.
- Keep one authoritative representation for each piece of system knowledge. Business rules,
  validation, status semantics, mappings, calculations, schemas, configuration meaning,
  generated output, and manual process steps should derive from or trace to one owner.
- Preserve orthogonality: keep components independent, responsibilities non-overlapping,
  interfaces narrow, collaborator knowledge small, and policy, mechanism, data, presentation,
  orchestration, and computation separated.
- Keep volatile decisions reversible where practical. Don't hard-code vendors, platforms,
  databases, deployment environments, policies, or requirements before evidence justifies the
  commitment.
- Use domain vocabulary and small domain languages only when they make rules clearer to the
  people who must validate or change them.
- Prefer thin end-to-end tracer bullets over piles of isolated pieces. Keep the first slice
  simple but real enough to validate architecture, integration, and assumptions.
- Use prototypes to learn, not to pretend the work is done. State what the prototype proves,
  what it doesn't prove, and which shortcuts must be discarded or hardened.
- Dig for real requirements. Separate durable needs and constraints from current implementation
  details, proposed solutions, growing prose specs, and unresolved team hesitation.
- Automate repetitive, error-prone, easy-to-forget, or ritualized work. Builds, tests, linting,
  formatting, packaging, deployment, setup, validation, and release should be reproducible and
  aligned with shared automation.
- Shorten feedback loops with relevant tests, automated checks, visible failures, and cheap
  early signals before late expensive surprises.
- Make contracts, assumptions, invariants, responsibilities, and caller/callee obligations
  explicit and close to the abstraction they protect.
- Distinguish programmer errors, contract violations, impossible states, expected domain
  failures, retryable failures, recoverable failures, and permanent failures; preserve
  diagnostic context and fail inside boundaries that prevent wider collapse.
- Treat resource ownership as a contract. Release every acquired allocation, handle, lock, or
  resource on success and failure paths, preferably in the opposite order from acquisition.
- Prefer inspectable plain text, open formats, scripts, explicit serialization, and
  version-aware configuration when longevity, diffability, automation, migration, or
  interoperability matter.
- Treat shared mutable state, ambient context, globals, temporal coupling, and asynchronous
  complexity as costs that must earn themselves and be made visible.
- Use tooling as leverage for correctness and speed, but understand generated code, formal
  methods, specifications, and tool output before relying on them.
- Debug from reproduced facts: observe, isolate, explain, fix, and verify before guessing or
  blaming compilers, operating systems, libraries, or vendors.
- Apply the broken windows rule: fix or visibly contain small quality decay before bad code,
  unclear ownership, weak design, or broken process becomes normal.

## Trigger rules

- When the same fact appears in multiple artifacts, choose one owner and derive, generate,
  validate, or trace the rest.
- When one change requires edits in many unrelated places, repair the missing boundary or
  hidden coupling before it spreads.
- When volatile details are hard-coded, move them into validated, controlled, versioned
  configuration, metadata, or an explicit abstraction.
- When uncertainty is high or a decision is hard to reverse, reduce risk with tracer feedback,
  a prototype, a smaller reversible step, or a delayed commitment.
- When prototype code, generated scaffolds, diagrams, specs, formal models, or tool output
  start becoming production truth, inspect, understand, harden, replace, or reject them
  deliberately.
- When hidden assumptions live only in comments, caller folklore, or tribal setup steps, move
  them into code, contracts, tests, scripts, or checked configuration.
- When an error or resource crosses a boundary, decide who can recover, what context survives,
  and who owns cleanup.
- When repeated manual steps, human checks, environment rituals, or release procedures appear,
  automate and version them.
- When a human finds a bug, add or improve an automatic regression test around the protected
  contract.
- When code works for reasons nobody can explain, stop and prove the behavior with data before
  depending on it.
- When local decay appears in touched code, fix it if cheap or leave an explicit containment
  or cleanup path.

## Final checklist

Before calling the work done, verify:

- One authoritative owner for each system fact?
- Unrelated concerns independent, and volatile choices reversible?
- Working feedback exists for risky assumptions?
- Prototype, generated, and tool-derived behavior deliberately accepted, not blindly trusted?
- Contracts, failures, diagnostics, resources, and cleanup explicit?
- Repeatable work automated, versioned, and aligned with shared checks?
- Tests automatic, relevant, and run before calling the change done?
- Touched area better, or explicitly contained, not left to decay further?
- Was the rigor applied proportionate to how long this work is actually going to be lived
  with (see Proportionality)?

---

## Output Expectations

When finishing a piece of work, state plainly:

- What tradeoffs, risks, or uncertainty were surfaced rather than quietly absorbed.
- Where knowledge duplication was avoided or, if it couldn't be, why and where the single
  owner lives.
- What was automated versus what remains a manual step, and why.
- Any unresolved risk, reversibility concern, or place where a shortcut was taken
  deliberately rather than by accident.
- If a requested approach conflicts with this discipline, follow the user's request but say
  so explicitly rather than silently absorbing the tradeoff.

---

## Changelog

Maintained by Kurt Mitchell. Versioning is MAJOR.MINOR.PATCH — MINOR for new capabilities that
don't change existing behavior, PATCH for clarifications and fixes. The top entry here must
match the `version` field in the frontmatter.

### 1.0.0 — 2026-07-23
- Initial release. Adapted from the `the-pragmatic-programmer.mini.md` rule set in the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed),
  itself distilled from Andrew Hunt and David Thomas's *The Pragmatic Programmer*. Built
  directly to the collection's normalized skeleton (Purpose → Primary bias to correct →
  Proportionality → Decision/Trigger rules → Final checklist → Output Expectations →
  Changelog), matching `refactoring-pass` and `legacy-code-safety`. Added a note in Purpose
  positioning this skill as the general baseline the collection's more specific skills layer
  on top of, and a Proportionality section calibrated to how long a given piece of work will
  actually be lived with rather than to code maturity alone.
  `references/full-reference.md` and `references/nano-quick-reference.md` carry the source
  project's `full` and `nano` tiers respectively, for sessions that need more depth or a
  tighter always-on budget than this skill body provides.
