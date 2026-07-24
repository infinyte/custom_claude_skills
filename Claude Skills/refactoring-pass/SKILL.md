---
name: refactoring-pass
description: >
  Applies Martin Fowler's Refactoring discipline when changing existing code: preserve
  observable behavior, work in small reversible steps, establish a safety net before risky
  changes, and remove real structural friction without turning cleanup into a rewrite. Use
  whenever the user asks to refactor, clean up, restructure, extract a method, split a class,
  reduce duplication, or prepare code for an upcoming feature — or before/after implementing
  a feature, when the existing structure makes the change awkward. Trigger on phrases like
  "refactor this", "clean this up", "this is hard to change", "break this apart", "reduce
  duplication", or "make this more maintainable". Distilled from Fowler's book via the
  agent-rules-books project (MIT licensed); references/full-reference.md carries the complete
  rule set, including the refactoring-move and code-smell catalog, for deep audits.
metadata:
  version: 1.0.1
---

# Refactoring Pass

## Purpose

This skill applies the discipline of Martin Fowler's *Refactoring*: improving the internal
structure of code **without changing its observable behavior**, in small, safe, reversible
steps. It governs how to approach any task that touches existing code — a cleanup request, a
"this is hard to change" complaint, or the structural work that naturally surrounds a feature
or bug fix.

The rule set below is a compressed, decision-oriented distillation of the book — not the book
itself, not a substitute for it, and not officially affiliated with Fowler or his publisher.
It was adapted from the `refactoring.mini.md` rule set in
[agent-rules-books](https://github.com/ciembor/agent-rules-books) (MIT licensed, © Maciej
Ciemborowicz), itself a distillation of the book's content, reshaped here into skill form.
See `references/full-reference.md` for the fuller rule set this was compressed from, and
`references/nano-quick-reference.md` for an even tighter fallback when context budget is very
tight.

**When this doesn't fit:** a throwaway spike, a prototype that's about to be thrown away, or
a change where a genuine rewrite has already been deliberately chosen (a planned migration,
not a shortcut) doesn't need this discipline applied at full strength. Scale the rigor to the
stakes — see "Proportionality" below.

---

## Primary bias to correct

Working code is not automatically well-structured code, and "I'm going to clean this up" is
not automatically a small, safe step. The default failure mode this skill guards against is
cleanup that quietly turns into a rewrite, a hidden behavior change, or speculative
architecture nobody asked for.

---

## Proportionality

Apply this discipline in proportion to what's actually at stake — not identically on every
touch of every file.

- **Throwaway / spike code:** skip most of this. Get it working; formal safety nets and
  patch discipline aren't worth the overhead.
- **Greenfield / pre-production code with no external consumers yet:** lighter touch —
  preserving behavior still matters, but the safety-net and patch-separation rules can be
  relaxed since nothing downstream depends on today's behavior yet.
- **Production / actively-evolving code with real consumers:** apply the full discipline
  below — safety net first, small steps, preserved behavior, separated patches.
- **Mature / long-lived code that many things depend on:** apply the full discipline, and
  lean toward the smallest possible move even when a larger one seems tempting; the blast
  radius of getting it wrong is larger here than anywhere else.

When in doubt about which band applies, ask rather than guessing — the cost of asking is one
sentence; the cost of guessing wrong is a change that either overshoots into unwanted rewrite
territory or undershoots into unsafe cleanup.

---

## Decision rules

- Preserve observable behavior during refactoring. Isolate behavior changes from structural
  changes and never disguise a feature, migration, or redesign as cleanup.
- Work in small, reversible, buildable, testable, reviewable steps. Split a patch when it's
  too large to reason about locally.
- Establish or identify a safety net before risky refactoring. Use characterization tests for
  unclear behavior, keep test updates aligned with intended behavior, and never delete a
  failing test to finish cleanup.
- Use preparatory and follow-up refactoring around feature work: identify what makes the
  requested change awkward, reshape that local structure first when useful, make the behavior
  change, then clean up debt introduced by the change.
- Refactor the current blocking smell, not every smell in sight: duplication, long functions,
  long parameter lists, globals, divergent change, shotgun surgery, feature envy, primitive
  obsession, repeated conditionals, temporary fields, middle men, or speculative generality.
- Prefer the simplest named move that helps: rename, extract, inline, move, split meanings,
  introduce a parameter or value object, encapsulate a field or collection, decompose
  conditionals, use guard clauses, or substitute a clearer algorithm.
- Make names and functions reveal intent. Rename before deeper work when bad names block
  understanding; keep functions coherent, at one abstraction level, with tight variable scope
  and separated phases.
- Put behavior and state with the concept that owns them. Split classes or modules with
  multiple reasons to change; separate business policy from formatting, transport,
  persistence, I/O, frameworks, and integration details.
- Keep data, mutation, and call contracts explicit. Avoid behavior-switching boolean flags,
  confusing argument order, parameter reassignment, exposed mutable collections, unnecessary
  setters, public fields, and duplicated state-transition logic.
- Simplify conditionals honestly. Use guard clauses, extracted predicates, lookup tables,
  consolidated duplicate fragments, state, strategy, polymorphism, or null objects only when
  they reduce repeated branching or clarify variation.
- Use abstraction and generalization only when current evidence justifies them. Remove
  pass-through layers, vague utilities, middle men, unused hierarchy, and just-in-case
  interfaces that don't improve changeability.
- Preserve error semantics unless intentionally changing behavior. Refactor error handling to
  reveal the main path and consolidate duplicate validation, cleanup, recovery, or error
  structures.
- Keep patch intent reviewable. Group related refactorings, separate structural edits from
  behavior changes where practical, and avoid giant patches that rename, move, redesign, and
  change logic all at once.
- Stop when the requested change is easy, the blocking smell is gone, readability and local
  changeability are clearly better, and the next cleanup would be speculative.

## Trigger rules

- When adding behavior, first ask what structural friction blocks the change; refactor before
  the feature only when it makes the feature safer or simpler.
- When fixing a bug in unclear code, characterize the current failure and refactor only enough
  to make the fix visible before changing behavior.
- When tests are absent or weak, make the smallest possible structural move and improve
  testability before attempting broader cleanup.
- When the same edit appears for a third time, remove duplication through clearer ownership
  instead of copying again.
- When a function mixes responsibilities, abstraction levels, phases, or hidden side effects,
  rename, extract, split phases, or isolate side effects before adding more logic.
- When one change forces edits across many files, centralize the knowledge or introduce a
  clearer boundary.
- When repeated conditionals or type codes grow, decompose intent first; introduce
  polymorphism, state, strategy, or a table only when the variation is real.
- When UI and domain behavior mix, move rules toward domain objects and verify any required
  presentation synchronization.
- When a patch mixes intents or code motion makes review hard, split the change unless context
  makes that impractical.
- When tempted to rewrite, choose the next small behavior-preserving transformation that
  recovers control instead.

## Final checklist

Before calling a refactoring pass done, verify:

- Observable behavior preserved?
- Structural change, behavior change, and test updates separated where practical?
- Safety net, characterization, or verification gap recorded?
- At least one real source of friction removed?
- Names, responsibilities, control flow, data ownership, and interfaces clearer?
- Patch still reviewable and runnable?
- Cleanup stopped before speculative abstraction or rewrite pressure took over?
- Was the rigor applied proportionate to what's actually at stake (see Proportionality)?

---

## Output Expectations

When finishing a refactoring pass, state plainly:

- What structural change was made, and what smell or friction it removed.
- Confirmation that behavior was preserved (and how — tests run, characterization added,
  manual verification, etc.).
- Any unresolved risk, assumption, or place where further cleanup was deliberately left for a
  future pass rather than done now.
- If a requested change conflicts with this discipline (e.g., the user explicitly wants
  behavior changed inside what was framed as a cleanup), follow the user's request but say so
  explicitly rather than silently blending the two.

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
- Initial release. Adapted from the `refactoring.mini.md` rule set in the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed),
  itself distilled from Martin Fowler's *Refactoring*. Reshaped from a standalone always-on
  rule file into skill form: added this Purpose/attribution section, a Proportionality
  section (not present in the source rule set — added because blanket full-strength
  discipline on every touch of every file is the wrong default), and Output Expectations.
  `references/full-reference.md` and `references/nano-quick-reference.md` carry the source
  project's `full` and `nano` tiers respectively, for sessions that need more depth or a
  tighter always-on budget than this skill body provides.
