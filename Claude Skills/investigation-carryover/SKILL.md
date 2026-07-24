---
name: investigation-carryover
description: >
  Manages session continuity for a long-running investigation, audit, or research project
  that spans multiple Claude sessions. Because Claude has no memory between sessions, this
  skill defines a structured session-package format carrying findings, open questions,
  access gaps, and next steps from one session into the next. Use whenever the user starts a
  new session for an ongoing investigation (to orient from a prior carry-over package), asks
  to continue or pick up where they left off, or a session is ending and a handoff package is
  needed. Trigger on phrases like "open the investigation", "load context", "generate handoff",
  "end of session", "wrap up", "carry this over", or "what did we establish". Applies to any
  multi-session investigative work — security reviews, audits, vendor/compliance reviews,
  competitive research, incident postmortems, or any project where findings must survive
  across sessions.
metadata:
  version: 1.1.0
---

# Investigation Session Carry-Over

## Purpose

This skill governs how an investigation session starts and ends when continuity is required
across Claude sessions. Because Claude has no memory between sessions, all investigation
state — confirmed findings, open questions, access or resource gaps, and context — must be
serialized into a structured package and pasted into each new session.

It's deliberately domain-agnostic. The same shape carries a security audit, a codebase
archaeology project, a vendor compliance review, a piece of competitive research, or an
incident postmortem — anything where the work runs across more sessions than one
conversation can hold, and where losing thread state between sessions would mean re-deriving
work that was already done. See `references/example-package.md` for two worked examples
across different domains.

**When this doesn't fit:** short, single-session tasks don't need this — the overhead of
maintaining a package isn't worth it unless the investigation is genuinely going to outlive
the conversation.

---

## Session Open Protocol

When the user pastes a session package (XML block, as defined below), do the following in
order:

1. **Parse the package silently.** Do not narrate what you are reading.
2. **Acknowledge orientation in one sentence.** Example: "Loaded — 3 questions confirmed,
   Q1 and Q3 still open, picking up where we left off."
3. **Identify the highest-priority open question** from the `<open_questions>` block and
   offer the next step immediately.
4. **Do not re-explain** what the user already established. Treat the package as shared
   memory and proceed as if the prior session was unbroken.

If the package is absent or incomplete, ask for it before proceeding. Do not attempt to
reconstruct investigation state from fragments — a guessed history is worse than no history,
because it's wrong with confidence.

---

## Session Close Protocol

When the user signals the session is ending (phrases like "wrap up", "end of session",
"generate handoff", "carry this over"), produce the following in order:

### Step 1 — Session Summary (spoken register, 3–5 sentences)
What was investigated today, what was confirmed, and what changed since the last session.
No bullet points. One paragraph the user could read aloud to someone else.

### Step 2 — Updated Session Package (XML block)
The complete, updated carry-over package for the next session. See format below. All fields
must be updated to reflect findings from this session, not just appended to.

### Step 3 — Companion Document Prompt (only if applicable)
Some investigations pair this skill with a separate skill or process that maintains
human-readable "living documents" (a running reference doc, an issues register, a status
report) built from the same findings. If this investigation has one, close with an offer to
update it — name the actual skill or process in use, for example:

> "Ready to update the [living-doc reference/skill name]. Say which sections to refresh, or
> 'update all'."

If no such companion exists for this investigation, skip this step entirely — don't invent
one.

---

## Session Package Format

The session package is an XML block pasted at the start of each session. It contains
everything needed to resume without prior context. Fill in every field for the specific
investigation — the block below is a template, not a finished example. A fully worked
version (two, actually, from different domains) lives in `references/example-package.md`.

```xml
<session_package>

  <engagement>
    <investigator><!-- Name — role, organization --></investigator>
    <reports_to><!-- Name — role (omit this line entirely if there's no one to report to) --></reports_to>
    <session_number><!-- e.g., Session 3 --></session_number>
    <date><!-- ISO date of this package --></date>
    <last_session_summary>
      <!-- 2-4 sentences: what was investigated, what changed, what was confirmed -->
    </last_session_summary>
  </engagement>

  <access_status>
    <!--
      One line per system, tool, or resource the investigation depends on. Update as access
      is granted or confirmed blocked. Not every investigation needs this block — drop it
      if there's nothing gating progress on access.
    -->
    <system name="<!-- e.g. a repo, a database, a shared drive, a subject-matter expert -->" status="BLOCKED|GRANTED|UNKNOWN" note="<!-- why -->"/>
    <!-- Add new systems as encountered -->
  </access_status>

  <findings_record>
    <!--
      Classification:
        CONFIRMED  — directly observed in source material (code, config, documents, records)
        INFERRED   — logically derived from observable evidence, not directly confirmed
        UNKNOWN    — not determinable from available sources

      One <question> per open thread. Update status, evidence, and answered_date when a
      question is closed. Keep every question the investigation has raised, not just the
      open ones — a CONFIRMED question is still a record of what was established and why.
    -->
    <question id="Q1" label="<!-- 6 words or fewer -->" status="UNKNOWN">
      <evidence></evidence>
      <next_step><!-- first concrete action to make progress on this question --></next_step>
    </question>
    <!-- Add new questions as they emerge, next available Q-number -->
  </findings_record>

  <priority_next_steps>
    <!--
      Three to five specific actions, in priority order. Each should be completable in a
      single investigation step. Update this block at session close to reflect what was NOT
      completed this session.
    -->
    <step priority="1"><!-- specific, actionable, names who/what it depends on --></step>
  </priority_next_steps>

  <open_issues_count>
    <!--
      Optional quick-reference tally — useful when the investigation is tracking discrete
      issues/findings by severity or category. Adapt the categories to whatever taxonomy
      this investigation actually uses (severity, risk tier, confidence level, whatever's
      meaningful); drop the block entirely if nothing like this applies.
    -->
    <count category="<!-- e.g. Critical -->" open="<!-- n --> "/>
  </open_issues_count>

</session_package>
```

---

## Evidence Classification Rules

Always apply exactly these labels when recording findings:

| Label | Meaning |
|---|---|
| `CONFIRMED` | Directly observed in source material — code, config, records, or dated documentation |
| `INFERRED` | Logically derived from observable evidence, not directly confirmed |
| `UNKNOWN` | Not determinable from available sources |

**Never speculate beyond evidence.** If a question cannot be answered from available
sources, say so explicitly and state what additional access or information would resolve
it.

**Never evaluate people.** Findings describe systems, processes, code, and documentation —
not individuals' judgment, competence, or intent. This holds even when a finding traces
back to a decision someone made; describe the decision and its effect, not the person.

---

## Operating Protocol (Within a Session)

For every investigative exchange, structure the response as follows:

```
INVESTIGATING: [Q-number and label]

NAVIGATE TO:
[One specific action: a repo path, a search term, a system, or a document. Specific enough
to act on in under 30 seconds.]

FINDINGS RECORD:
  [List every open (non-CONFIRMED) question from the session package's findings_record, in
  Q-number order, one line each: "Qn <label>: STATUS — one-line note." This list changes as
  the findings_record changes — it is never a fixed set of questions baked into this
  template; it reflects whatever the current investigation actually has open.]

READY TO REPORT: [only when a question is fully answered]
[One paragraph. Verbal delivery register. Facts only, no hedging. Something the user could
say out loud to whoever they report to, without looking at notes.]
```

When a finding updates an existing question's status, note the change explicitly. When a
question is fully answered, mark it CONFIRMED and provide the verbal summary.

---

## Adding New Questions

As the investigation expands, new questions will emerge. Add them to the
`<findings_record>` block with the next available Q-number. Include:
- A short label (6 words or fewer)
- Initial status (`UNKNOWN`)
- Evidence (empty initially)
- Next step (first concrete navigation action)

---

## Notes on Dual-Format Output

The session package (XML) is for LLM consumption — pasted into a new session to restore
context. If this investigation also maintains human-readable living documents (a reference
doc, a status report, an issues register) via a separate skill or manual process, keep the
two formats distinct: the XML package is not a substitute for the living documents, and
vice versa. The package optimizes for fast, lossless context restoration; living documents
optimize for a human reading them without an LLM in the loop.

---

## Proportionality

Match how much of the session package format gets used to how formal and high-stakes the
investigation actually is — not every multi-session thread needs every optional block filled in.

- **Casual / exploratory research spanning a couple of sessions:** skip most of the ceremony. A
  short `findings_record` and a one-line `priority_next_steps` list is enough; drop
  `access_status` and `open_issues_count` entirely unless something is actually blocking
  progress.
- **Ongoing project work with a defined deliverable** (a multi-session build, a recurring
  analysis): use the full `findings_record` and `priority_next_steps` blocks; add
  `access_status` once access actually becomes a blocker.
- **Formal audit, compliance review, or investigation with a reporting obligation:** use the
  full package as specified — every field earns its keep here, because the
  CONFIRMED/INFERRED/UNKNOWN discipline and the `access_status` trail are often the record
  itself, not just a convenience.
- **High-stakes investigation** (legal exposure, regulatory reporting, something that could be
  audited or reviewed after the fact): use the full package, and treat the Evidence
  Classification Rules as strict — never round `INFERRED` up to `CONFIRMED` for convenience,
  and keep every question in the record even after it's answered, since the history of what
  was established and when may matter as much as the current answer.

When in doubt about which band applies, use more structure rather than less — the package is
cheap to maintain lightly and expensive to reconstruct after the fact if a casual research
thread turns out to matter more than expected.

---

## Customizing This Skill for a Specific Investigation

This skill ships domain-agnostic on purpose, but a specific investigation usually benefits
from a little tailoring. When setting it up for a new investigation, consider:

- **`engagement` roles.** `investigator` and `reports_to` assume a reporting relationship —
  common in audits and workplace investigations, less relevant for solo research. Drop
  `reports_to` if there's no one to report to.
- **`access_status` categories.** Replace the placeholder system names with whatever this
  investigation actually depends on — repos, databases, subject-matter experts, physical
  records, whatever gates progress.
- **`open_issues_count` taxonomy.** Severity (Critical/High/Medium/Low) fits a technical
  audit; a different investigation might track by risk tier, confidence, or a category
  scheme with no severity concept at all. Adapt or drop the block.
- **The companion-document hook** in Session Close Protocol Step 3. Name a specific
  skill or process if this investigation has one; leave the step out if it doesn't. Don't
  invent a companion process that doesn't exist just because the template mentions one.

None of this needs to happen up front — it's fine to start with the generic template and
tighten it after the first session or two, once the investigation's actual shape is clear.

---

## Changelog

Maintained by Kurt Mitchell. Versioning is MAJOR.MINOR.PATCH — MINOR for new capabilities that
don't change existing behavior, PATCH for clarifications and fixes. The top entry here must
match the `version` field in the frontmatter.

### 1.1.0 — 2026-07-23
- Structural normalization pass across the whole Claude Skills / GitHub Copilot Pro Skills
  collection, to bring every skill onto one shared SKILL.md skeleton (frontmatter →
  `## Purpose` → skill-specific sections, each separated by `---` → `## Proportionality` →
  `## Changelog`). For this skill specifically: added a `## Proportionality` section (this
  skill previously only had the brief "When this doesn't fit" note in Purpose — the new
  section gives it the same four-band treatment `feynman-peer-review`, `refactoring-pass`,
  and `legacy-code-safety` use, adapted to investigation formality/stakes instead of code
  maturity). Also added the "Maintained by Kurt Mitchell" / "top entry must match frontmatter
  version" lines to this Changelog's intro, matching the other skills. No other content
  changed.

### 1.0.0 — 2026-07-23
- Generalized from a project-specific skill (an internal technical-investigation carryover
  format) into a domain-agnostic version. Changes made in the generalization:
  - Removed all references to the originating organization, its personnel, and its specific
    systems (repos, cloud subscriptions, ticket trackers) from the template — the session
    package format is now pure placeholders, with worked examples moved to
    `references/example-package.md`.
  - The Operating Protocol's `FINDINGS RECORD` block used to hardcode a fixed list of nine
    questions specific to the originating investigation. That was a latent bug even in the
    original context: it meant the template had to be hand-edited every time the question
    count or labels changed. Replaced with an instruction to list whatever the current
    session package's `findings_record` actually contains.
  - Session Close Protocol's Step 3 used to name a specific companion skill by hardcoded
    name. Generalized into an optional hook — name a real companion skill if one exists for
    this investigation, otherwise skip the step.
  - Added the "When this doesn't fit" note and the "Customizing This Skill" section, neither
    of which existed in the original — both are new guidance for adapting the template to a
    new domain, since "domain-agnostic" only works if the skill also explains what to change.
