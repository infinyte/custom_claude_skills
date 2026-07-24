---
name: legacy-code-safety
description: >
  Applies Michael Feathers' Working Effectively with Legacy Code discipline when changing
  code that lacks trustworthy tests or has unclear, hard-to-observe behavior: characterize
  current behavior before redesigning it, find or create a seam, break the one dependency
  actually blocking a test, make the change, then leave the area more testable than found.
  Use whenever the user modifies code with weak or missing test coverage, works in an
  unfamiliar or "legacy" codebase, needs to test code that resists testing (hard-to-construct
  objects, hidden statics, framework entanglement), or is tempted to rewrite something risky
  instead of changing it safely. Trigger on phrases like "this code has no tests", "I need to
  change this safely", "how do I test this", or "this is legacy code". Distilled from
  Feathers' book via the agent-rules-books project (MIT licensed);
  references/full-reference.md carries the complete seam catalog and dependency-breaking
  technique index for deeper sessions.
metadata:
  version: 1.0.1
---

# Legacy Code Safety

## Purpose

This skill applies the discipline of Michael Feathers' *Working Effectively with Legacy
Code*: making risky, poorly-understood, weakly-tested code changeable by gaining
understanding, creating seams, and establishing tests — before redesigning it. It governs how
to approach any change to code that is, in Feathers' definition, *legacy*: code that's
expensive to change safely because you can't be confident what it currently does or how a
change would ripple.

The rule set below is a compressed, decision-oriented distillation of the book — not the book
itself, not a substitute for it, and not officially affiliated with Feathers or his
publisher. It was adapted from the `working-effectively-with-legacy-code.mini.md` rule set in
[agent-rules-books](https://github.com/ciembor/agent-rules-books) (MIT licensed, © Maciej
Ciemborowicz), itself a distillation of the book's content, reshaped here into skill form.
See `references/full-reference.md` for the fuller rule set this was compressed from —
including the full seam catalog and dependency-breaking technique index — and
`references/nano-quick-reference.md` for an even tighter fallback when context budget is very
tight.

**When this doesn't fit:** code with real, trustworthy test coverage already in place isn't
"legacy" in this sense, even if it's old — apply ordinary engineering judgment (see the
`refactoring-pass` skill) instead of the seam-and-characterize discipline below. Likewise, a
genuinely planned rewrite or migration (deliberately chosen, not reached for out of fear) is
a different kind of work than what this skill governs.

---

## Primary bias to correct

**If a part of the code lacks trustworthy tests, treat it as legacy code** — regardless of
how old it is or how it reads. The instinct this skill corrects is reaching for a rewrite, or
for broad "cleanup," when the actual problem is that nobody (including the agent) currently
knows what the code does. Gain control before improving design: understand current behavior,
protect what must stay, create the smallest useful seam, break the dependency that blocks
feedback, make the requested change, then leave the area more testable than it was found.

---

## Proportionality

Apply this discipline in proportion to how much trust the surrounding code actually deserves
— not identically everywhere.

- **Code with real, passing, trustworthy tests already covering the area:** this isn't legacy
  code by Feathers' definition. Use ordinary refactoring discipline instead of the full
  seam-and-characterize workflow below.
- **Code with partial or stale test coverage:** treat the untested slice as legacy even if
  neighboring code is well-tested. Apply the discipline locally, scoped to what's actually
  uncertain.
- **Code with no tests and unclear behavior, actively being modified:** apply the full
  discipline below — characterize first, find a seam, break the blocking dependency,
  change, refactor.
- **Code with no tests that nobody is touching right now:** no action needed. This discipline
  activates on change, not on the mere existence of untested code.

When in doubt about whether an area counts as "legacy" in this sense, treat it as legacy —
the cost of over-applying characterization is some extra test-writing; the cost of
under-applying it is a confident-looking change that silently breaks real behavior.

---

## Decision rules

- Treat any area without trustworthy tests as legacy code; do not start with a rewrite or
  module-wide cleanup unless that's explicitly required or clearly safer.
- Before editing, state the requested behavior change and the current behavior that must
  remain; characterize uncertain or suspicious behavior instead of silently "fixing" it.
- Follow the legacy loop: identify the change point, check existing protection, add
  characterization where possible, find or create a seam, break the blocking dependency,
  change behavior, then refactor locally.
- Prefer fast, focused tests around the slice being changed; use broader interception or
  integration tests only when they're the safest first observation point available.
- Choose test points by tracing effects outward from the change point through values, calls,
  fields, outputs, collaborators, interception points, and pinch points.
- Use the smallest seam that allows substitution, observation, or interception; be explicit
  about whether the seam is for sensing, separation, or both.
- Break dependencies deliberately: expose hidden inputs, hard outputs, hard construction,
  globals, statics, ambient context, and framework callbacks only where they actually block
  testing or safe change.
- Keep behavior changes, structural refactorings, and cleanup separate; verify small steps and
  avoid checking in exploratory restructuring that was only used for understanding.
- When direct edits are risky, add behavior with sprout method, sprout class, wrap method,
  wrap class, or extract-and-override style moves, then fold the temporary structure into
  better design once tests support it.
- For hard-to-test methods, split construction from use, extract side effects behind
  collaborators, carve out pure computation first, and isolate policy from runtime,
  persistence, UI, or framework mechanisms.
- Use dependency-breaking techniques according to the actual barrier: adapt narrow
  parameters, extract interfaces or implementers, parameterize constructors or methods,
  encapsulate globals, introduce instance delegators, override factories/calls, or use
  link/preprocessing seams only when ordinary object seams are impractical.
- In large code, sketch effects and group responsibilities before moving behavior; let
  excessive setup, impossible observation, and repeated changes point to smaller extracted
  responsibilities.
- During review, treat no tests around modified logic, mixed structural and behavioral edits,
  broad edits in poorly understood modules, hard-coded collaborators, global/static
  reach-through, constructor side effects, and business logic trapped in framework entry
  points as legacy-change risks.
- Reject changes that expand hidden dependencies, mock around untestable structure without
  improving it, rename or format while leaving the real dependency knots intact, or introduce
  large architecture before basic seams exist.
- Leave the touched area easier to understand, test, or change; don't mistake test-only
  seams, wrappers, subclass tricks, or build tricks for design improvement by themselves.

## Trigger rules

- When behavior is uncertain, consumers may rely on ugly behavior, or a branch/path is hard
  to prove, add characterization or another explicit observation path before changing
  semantics.
- When tests require too much setup or a class can't be instantiated cheaply, break the first
  real barrier: constructor work, hidden allocation, factory call, global state, static
  construction, framework object, or hard parameter.
- When time, randomness, environment, thread-local state, current user/request, files,
  network, process exits, database writes, messages, or control-flow logging block repeatable
  tests, wrap or inject that boundary.
- When a large method or class defeats local reasoning, sketch effects, find interception or
  pinch points, extract pure computation first, and avoid editing many branches at once.
- When changing database-heavy, UI, framework, or API-boundary code, separate policy from
  query/mapping/persistence, handlers/callbacks, adapters, and runtime setup; keep real-
  boundary integration tests where they matter.
- When a seam is magical, temporary, public-for-test, subclass-only, link/preprocessor-based,
  or probe/sensing-variable-based, add a cleanup obligation and remove it once safer structure
  exists.
- When repeated edits cluster across several places, remove duplication incrementally under
  tests instead of launching a broad redesign.
- When rewrite or heroic cleanup feels tempting, choose the smallest sprout, wrap, seam,
  characterization, or refactoring step that makes today's requested change safer instead.

## Final checklist

Before calling a legacy-code change done, verify:

- Untested or weakly tested area treated as legacy risk?
- Behavior delta and behavior-to-preserve stated?
- Uncertain current behavior characterized or explicitly observed?
- Tests close enough and fast enough to diagnose the change?
- Smallest useful seam chosen, with sensing vs. separation clear?
- Blocking dependency reduced without expanding hidden dependencies?
- Behavior change, refactoring, and cleanup kept separate?
- Temporary seam or dependency-breaking trick has a cleanup path?
- Touched area is more understandable, testable, or changeable than before?
- Was the discipline applied proportionate to how much the surrounding code actually
  deserved (see Proportionality)?

---

## Output Expectations

When finishing a legacy-code change, state plainly:

- What was characterized or confirmed about existing behavior before the change, and how
  (test added, manual trace, existing documentation).
- What seam was created or used, and whether it's meant to be permanent or has a cleanup
  obligation attached.
- Which dependency was broken and why it was the one actually blocking the change.
- Any unresolved risk — behavior that's still uncertain, a seam left temporary, or a
  dependency that couldn't be broken within scope.
- If a requested change conflicts with this discipline (e.g., the user wants a rewrite of
  code that hasn't been characterized yet), follow the user's request but say so explicitly
  rather than silently skipping the safety work.

---

## Changelog

Maintained by Kurt Mitchell. Versioning is MAJOR.MINOR.PATCH — MINOR for new capabilities that
don't change existing behavior, PATCH for clarifications and fixes. The top entry here must
match the `version` field in the frontmatter.

### 1.0.1 — 2026-07-23
- Structural normalization pass across the whole Claude Skills / GitHub Copilot Pro Skills
  collection, to bring every skill onto one shared SKILL.md skeleton (frontmatter →
  `## Purpose` → skill-specific sections, each separated by `---` → `## Proportionality` →
  `## Changelog`). For this skill specifically: added the "Maintained by Kurt Mitchell" / "top
  entry must match frontmatter version" lines to this Changelog's intro, matching
  `feynman-peer-review`. No other content changed — this skill already had the
  `## Purpose` and `## Proportionality` sections the normalization pass introduced elsewhere.

### 1.0.0 — 2026-07-23
- Initial release. Adapted from the `working-effectively-with-legacy-code.mini.md` rule set
  in the [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT
  licensed), itself distilled from Michael Feathers' *Working Effectively with Legacy Code*.
  Reshaped from a standalone always-on rule file into skill form: added this
  Purpose/attribution section, a Proportionality section (not present in the source rule
  set — added because this discipline should activate on genuinely untested/uncertain code,
  not on every touch of every old-looking file), and Output Expectations.
  `references/full-reference.md` and `references/nano-quick-reference.md` carry the source
  project's `full` and `nano` tiers respectively, for sessions that need more depth (the full
  seam catalog and dependency-breaking technique index) or a tighter always-on budget than
  this skill body provides.
