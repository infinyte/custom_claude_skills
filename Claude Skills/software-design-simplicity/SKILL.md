---
name: software-design-simplicity
description: >
  Applies John Ousterhout's A Philosophy of Software Design discipline when designing or
  reshaping modules and interfaces: treat cognitive load as the primary metric, prefer deep
  modules with narrow interfaces that hide real complexity, and eliminate special cases
  instead of scattering conditionals across callers. Use whenever the user is designing a new
  module or API, an interface feels awkward or leaky, one change keeps spreading across
  unrelated files, or a wrapper/helper/layer is being added and its value is unclear. Trigger
  on phrases like "how should I structure this", "this API feels clunky", "design this
  module", or "is this over-abstracted". Distilled from Ousterhout's book via the
  agent-rules-books project (MIT licensed); references/full-reference.md carries the complete
  rule set for deep audits.
metadata:
  version: 1.0.0
---

# Software Design Simplicity

## Purpose

This skill applies the discipline of John Ousterhout's *A Philosophy of Software Design*:
fight complexity directly by designing modules with deep value, clean interfaces, strong
information hiding, and low cognitive load. It governs the moment of *designing* or
*reshaping* a module or interface — a genuinely different moment from `refactoring-pass`
(behavior-preserving cleanup of existing structure) or `legacy-code-safety` (working safely
around untested structure). This skill is about getting the shape right, whether that's a
brand-new module or an existing one whose interface has started leaking.

The rule set below is a compressed, decision-oriented distillation of the book — not the book
itself, not a substitute for it, and not officially affiliated with Ousterhout or his
publisher. It was adapted from the `a-philosophy-of-software-design.mini.md` rule set in
[agent-rules-books](https://github.com/ciembor/agent-rules-books) (MIT licensed, © Maciej
Ciemborowicz), itself a distillation of the book's content, reshaped here into skill form.
See `references/full-reference.md` for the fuller rule set this was compressed from, and
`references/nano-quick-reference.md` for an even tighter fallback when context budget is very
tight.

**When this doesn't fit:** a throwaway spike or a change that's purely behavior-preserving
cleanup with no interface or module-boundary decisions involved doesn't need this discipline —
use `refactoring-pass` for the latter. This skill is specifically about shaping interfaces and
module boundaries, not every code change.

---

## Primary bias to correct

Working code, small pieces, and familiar wrappers are not automatically simple. The failure
mode this skill guards against is optimizing for shorter files, fewer lines, or clever
compactness while complexity — measured as what a reader must hold in their head at once —
quietly rises. Complexity is anything that makes software hard to understand or hard to
change; that's the metric, not line count or file count.

---

## Proportionality

Apply this discipline in proportion to how much a design decision is actually going to cost to
walk back later.

- **Throwaway / spike code:** skip most of this. Get it working; deep-module discipline isn't
  worth the design overhead for code with no future.
- **Greenfield / pre-production module or interface:** apply the full discipline — this is the
  cheapest possible moment to get module boundaries and interface shape right, before any
  caller depends on the current shape.
- **Production / actively-evolving code with real consumers:** apply the full discipline to
  any *new* module or interface being added, or any interface actively being changed. Don't
  retroactively redesign an already-working module just because it was touched for an
  unrelated reason.
- **Mature / long-lived code that many things depend on:** apply real scrutiny here — a
  shallow module or leaky interface discovered in mature code is expensive to fix, which is
  exactly why it deserves weight rather than being waved off as "that's just how it is."

When in doubt about which band applies, ask rather than guessing — the cost of asking is one
sentence; the cost of guessing wrong is either a redesign nobody needed or a leaky interface
that outlives the person who shipped it.

---

## Decision rules

- Use reduced complexity as the primary success metric. Prefer the design that lowers
  cognitive load, change amplification, hidden dependencies, temporal coupling, and the number
  of facts a reader must hold at once.
- Treat design as continuous work. A first working patch is not done if it worsens future
  changeability; compare plausible alternatives for non-trivial interface, decomposition, or
  abstraction choices.
- Prefer deep modules: small, semantic interfaces that hide meaningful internal complexity.
  Reject pass-through services, thin library wrappers, helper modules, and tiny split-outs
  that add names without reducing reader burden.
- Design interfaces around what callers need to know, not how the implementation works. Avoid
  fragile staging, setup sequences, mode flags, configuration knobs, and arguments that expose
  internal choices.
- Hide volatile decisions, internal representations, storage shape, protocols, file formats,
  performance hacks, bookkeeping, normalization, and messy edge handling inside the module that
  owns the knowledge.
- Pull complexity downward when the lower module owns the detail. Prefer a slightly more
  complex implementation if it gives callers a simpler public contract and removes repeated
  reasoning from call sites.
- Choose generality at the right level. Avoid one-caller overfitting, vague speculative
  abstractions, and core paths polluted by rare edge cases; isolate special behavior with
  special-general decomposition.
- Combine or split by total complexity, not by size, runtime order, habit, or aesthetics. Keep
  related state, behavior, invariants, and design decisions together unless the new boundary
  is deeper and independently understandable.
- Reduce exception surface by changing interfaces or invariants where possible. Define away
  invalid states and awkward cases instead of making every caller repeat defensive ceremony.
- Use comments to reduce complexity: document interface contracts, invariants, hidden design
  decisions, rationale, and tricky implementation facts callers should not need to know. Don't
  narrate code or compensate for bad names, poor decomposition, or confusing flow.
- Treat names, consistency, and obviousness as design information. Names should reveal
  abstractions rather than mechanisms; related operations should share conventions; surprising
  code is complexity even when short.
- Use tests to protect behavior through public contracts and stable APIs, especially around
  hidden complexity and isolated special cases. Don't let test convenience force shallow or
  leaky interfaces.
- Add performance optimizations, trends, paradigms, patterns, or frameworks only when they
  reduce complexity in this codebase or evidence shows the tradeoff matters; hide optimization
  details behind stable interfaces.

## Trigger rules

- When a feature feels awkward, one change spreads across files, or reviewers must reconstruct
  hidden dependencies, look for missing information hiding, shallow modules, temporal coupling,
  or complexity pushed to callers.
- When adding a module, layer, service, helper, wrapper, facade, pattern, option, callback, or
  argument, prove that it hides more complexity than it adds.
- When touching an API, check whether ordinary callers must know sequencing, representation,
  storage, transport, caching, protocol, file format, internal workflow, or too many setup
  steps.
- When adding a special case, flag, exception path, conditional, or exposed container, first
  ask whether the owning module can eliminate the invalid state, isolate the unusual behavior,
  or provide a stronger operation.
- When splitting, extracting, or introducing variables, check whether the new boundary or name
  captures meaning or only adds jumps, pass-through state, and visible intermediate steps.
- When code is organized as `prepare/process/finalize`, staged objects, or other
  execution-order phases, verify that temporal structure is the real concept; otherwise
  reorganize around stable responsibilities.
- When naming is vague, mechanism-focused, inconsistent, or surprising, reconsider the
  abstraction boundary instead of accepting a near miss.
- When comments get long, duplicate code, justify a confusing interface, or explain usage by
  exposing internals, redesign the abstraction or move the missing contract to the interface.
- When optimizing performance, measure first and hide the optimization; don't sacrifice module
  depth or information hiding without evidence that the tradeoff matters.
- When testing or reviewing, focus on public behavior, interface contracts, hidden complexity
  through stable APIs, and special cases isolated behind the abstraction.

## Final checklist

Before calling a design done, verify:

- Did the change reduce the effort required to understand, modify, verify, and extend the
  system?
- Does every interface element, wrapper, layer, helper, option, and name hide enough
  complexity to justify its existence?
- Are important decisions localized, dependencies visible, caller-needed constraints
  documented, and mutable internals protected?
- Did common cases become automatic while rare controls, special cases, performance tricks,
  and exception details stayed out of the common path?
- Are names precise and consistent, comments current and non-duplicative, and conventions
  followed unless new information justified changing them?
- Was the rigor applied proportionate to how expensive this decision would be to walk back
  later (see Proportionality)?

---

## Output Expectations

When finishing a design or redesign, state plainly:

- What module or interface boundary was chosen, and what complexity it hides from callers.
- Any special cases isolated, and where — not scattered across call sites.
- Alternatives considered for any non-trivial decision, and why this one won.
- Any unresolved risk, assumption, or place where a shallower design was accepted deliberately
  (e.g., under Proportionality's throwaway-code exception) rather than by oversight.
- If a requested approach conflicts with this discipline, follow the user's request but say so
  explicitly rather than silently absorbing the added complexity.

---

## Changelog

Maintained by Kurt Mitchell. Versioning is MAJOR.MINOR.PATCH — MINOR for new capabilities that
don't change existing behavior, PATCH for clarifications and fixes. The top entry here must
match the `version` field in the frontmatter.

### 1.0.0 — 2026-07-23
- Initial release. Adapted from the `a-philosophy-of-software-design.mini.md` rule set in the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed),
  itself distilled from John Ousterhout's *A Philosophy of Software Design*. Built directly to
  the collection's normalized skeleton (Purpose → Primary bias to correct → Proportionality →
  Decision/Trigger rules → Final checklist → Output Expectations → Changelog), matching
  `refactoring-pass`, `legacy-code-safety`, and `pragmatic-engineering`. Added a note in
  Purpose distinguishing this skill's design-time focus from `refactoring-pass`'s
  behavior-preserving-cleanup focus, and a Proportionality section calibrated to how expensive
  a design decision is to reverse later.
  `references/full-reference.md` and `references/nano-quick-reference.md` carry the source
  project's `full` and `nano` tiers respectively, for sessions that need more depth or a
  tighter always-on budget than this skill body provides.
