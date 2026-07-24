---
name: vertical-slice-tdd
description: >-
  Enforce disciplined vertical-slice, test-driven design and development for any requested code
  implementation. Use whenever the user asks Claude to implement, build, modify, refactor, fix,
  add behavior, create a feature, address a bug, or perform any development work. The skill
  guides Claude to first judge the scale of the change (Trivial / Small / Feature / Large),
  clarify requirements, create testable acceptance criteria, write failing tests first, break
  work into vertical slices, maintain FEATURES.md/todo.md/implemented.md trackers, implement one
  slice at a time, and update docs, diagrams, markdown, and implementation logs after each
  completed slice. Trivial changes exit the workflow. Use even if the user does not name the
  skill by name.
metadata:
  version: 1.1.0
allowed-tools:
  - Bash(dotnet test:*)
  - Bash(dotnet build:*)
  - Bash(npm test:*)
  - Bash(npm run test:*)
  - Bash(pnpm test:*)
  - Bash(yarn test:*)
  - Bash(pytest:*)
  - Bash(python -m pytest:*)
  - Bash(go test:*)
  - Bash(cargo test:*)
  - Bash(mvn test:*)
  - Bash(gradle test:*)
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Vertical Slice TDD

## Purpose

This skill governs the overall shape of any development task. Given a request to implement,
build, modify, refactor, fix, or add behavior, it makes Claude judge the request's scale, clarify
what's ambiguous, translate the request into testable requirements and acceptance criteria, break
the implementation into vertical slices, write failing tests before each slice's implementation,
implement the minimum code needed to go green, refactor only while green, and update
documentation, diagrams, and slice-tracking files (`FEATURES.md`, `todo.md`, `implemented.md`)
after each completed slice. It enforces this workflow:

1. Judge the scale of the change (see **Proportionality** below).
2. Ask clarifying questions when needed for correctness.
3. Create testable requirements and acceptance criteria.
4. Write TDD-style tests that prove the requirements and acceptance criteria.
5. Run the tests and confirm they fail for the expected reason before implementation begins.
6. Break the implementation into vertical slices.
7. Create and maintain three markdown tracking files: `FEATURES.md`, `todo.md`, `implemented.md`.
8. Implement one vertical slice at a time.
9. After each slice, update docs, diagrams, markdown files, and tracking files.
10. Move completed slices from `todo.md` into `implemented.md`.
11. Update `FEATURES.md` after every completed slice.

Do not skip phases. Do not implement before requirements and failing tests exist. The exception is
the **Trivial** band under Proportionality below — that band exits the workflow entirely.

Unlike most of the discipline-specific skills in this collection — `refactoring-pass`
(behavior-preserving cleanup), `legacy-code-safety` (working safely around untested code),
`software-design-simplicity` (module/interface shape), `production-reliability` (surviving
production failure) — this skill isn't about one engineering technique. It governs the *shape* of
a development task itself: whether and how to clarify, spec, slice, and track the work before
touching code. Those other skills operate inside this one's phases — `refactoring-pass`
discipline applies during Phase 7 (Refactor While Green), and `legacy-code-safety` applies
whenever a slice touches code with weak test coverage. `pragmatic-engineering` remains the
general baseline underneath all of them, including this one.

This is original workflow content, not distilled from a published book via the agent-rules-books
project like the other skills in this collection. It was originally authored as a GitHub Copilot
Pro package and later adapted into this Claude edition — the one skill in this collection where
that direction is reversed; every other skill here is authored Claude-first with Copilot as the
port. See `references/` for the tracking-file templates, the red/green/refactor contract, the
documentation-update checklist, and two fully worked examples (.NET/C#/xUnit and
Python/FastAPI/pytest) of the same URL Shortener feature sliced end to end.

**When this doesn't fit:** read-only questions, investigation, or analysis with no code change
requested don't need this workflow — there's nothing to slice. For genuinely trivial changes
(typo fixes, comment changes, formatting, a dependency bump), the workflow itself judges that at
the Proportionality gate and exits immediately rather than forcing ceremony — see below.

---

## Proportionality

Not every request deserves a ten-phase mandate. Before doing anything else, judge the scale of the
change and pick the right band. Say which band you chose and why in one line, so the user can
correct you if the read is wrong.

### Bands

- **Trivial** — typo fix, comment change, formatting, dependency version bump, README wording,
  renaming a private local variable, updating a copyright year. No behavior change, no public
  contract change, and any existing tests still cover the area untouched.
  - **Do this instead of the workflow:** just make the change. Do not create tracking files. Do not
    write new tests. Do not open a slice. State in one line what you did and why the workflow was
    skipped ("Trivial — README typo, no behavior change, no tracking files created"). Stop.

- **Small** — single-file or tightly-scoped change inside existing behavior: a bug fix in one
  handler, a validation tweak on one endpoint, a small refactor that preserves behavior. The area
  already has tests, or one focused test is enough to pin the change.
  - **Do this:** light workflow. Add or adjust the one focused test, confirm red, implement, confirm
    green, update the one or two docs affected. Only create tracking files if the repo already uses
    them or the change grows past a single slice mid-flight. State the band.

- **Feature** — net-new behavior, a new endpoint, a new user-visible capability, a change that
  crosses more than one file or layer, or a bug fix that touches multiple components.
  - **Do this:** the full workflow. All phases. Requirements, acceptance criteria, slices, tracking
    files, test-first per slice, docs per slice. State the band.

- **Large / multi-phase** — a new subsystem, a migration, an architecture change, or a feature that
  will span multiple sessions.
  - **Do this:** the full workflow, plus explicit ADR(s) for the architectural choices, explicit
    diagram updates per slice, and cross-slice notes in `FEATURES.md`. Expect the tracking files to
    outlive the current session. State the band.

### If the band is unclear

Default up one level, not down. A misjudged **Feature** treated as **Small** loses tests and
tracking history. A misjudged **Small** treated as **Feature** just costs a few minutes of
bookkeeping. When genuinely unsure, ask the user.

### Do not skip the workflow for

- Anything that changes an API contract, wire format, database schema, or persisted data shape,
  regardless of LOC.
- Anything security- or authorization-related.
- Anything that changes observable behavior in production.
- Anything the user explicitly said is a real feature or bug, even if the diff looks small.

This section is positioned here, right after Purpose, rather than in the collection's usual
just-before-Changelog spot — see the Changelog for why that's a deliberate exception rather than
an oversight.

---

## Required Tracking Files

For **Feature** and **Large** bands (and any **Small**-band change that outgrows a single slice),
maintain these files:

```text
docs/vertical-slices/FEATURES.md
docs/vertical-slices/todo.md
docs/vertical-slices/implemented.md
```

If the repository already has a better feature-specific documentation location, use that location instead.

If the files do not exist, create them before implementation begins.

If the files already exist, update them without deleting prior history.

Detailed templates are in `references/tracking-file-templates.md`.

---

## Phase 1: Clarify the Request

Before writing requirements, tests, or code, inspect the user request and repository context.

Ask clarifying questions when missing information would materially affect:

- correct behavior,
- testability,
- data shape,
- public interfaces,
- user behavior,
- integration boundaries,
- error handling,
- authorization,
- backward compatibility,
- feature flags,
- rollout constraints,
- performance,
- reliability,
- documentation expectations.

Ask the smallest useful set of questions.

Do not ask questions just to delay work.

If a safe assumption is possible, state the assumption and continue.

If a missing decision blocks testable requirements, stop and ask before implementation.

---

## Phase 2: Create Testable Requirements and Acceptance Criteria

Translate the request into explicit, testable requirements.

Use this format:

```markdown
## Requirements

- REQ-001: The system shall <do observable behavior>.
- REQ-002: The system shall <handle condition>.
- REQ-003: The system shall <preserve existing behavior>.
```

Then create acceptance criteria.

Use this format:

```markdown
## Acceptance Criteria

- AC-001: Given <context>, when <action>, then <observable result>.
- AC-002: Given <context>, when <edge condition>, then <observable result>.
```

Acceptance criteria must cover, when relevant:

- happy path,
- validation path,
- error path,
- boundary conditions,
- existing behavior that must remain unchanged,
- cross-layer integration points,
- security or permission boundaries,
- user-visible behavior,
- API-visible behavior.

Do not write implementation until requirements and acceptance criteria exist.

---

## Phase 3: Define Vertical Slices

Break the implementation into vertical slices.

A vertical slice is the smallest independently testable increment that delivers observable behavior.

A slice may touch:

- UI,
- API,
- application service,
- handler,
- domain logic,
- validation,
- persistence,
- messaging,
- events,
- configuration,
- documentation,
- diagrams.

Prefer thin, complete vertical slices over broad horizontal layers.

Avoid slices like:

```text
Create all database tables
Build all API endpoints
Implement all UI
Write all tests
```

Prefer slices like:

```text
User can submit a valid request and receive a successful response
Invalid request is rejected with documented validation errors
Existing endpoint preserves backward-compatible response shape
User can view persisted result after refresh
```

Each slice must include:

```markdown
### VS-### - <Slice Name>

#### Goal

<One-sentence goal>

#### User / Business Value

<Why this slice matters>

#### Requirements Covered

- REQ-###

#### Acceptance Criteria Covered

- AC-###

#### Test Plan

- <test behavior>

#### Expected Layers Touched

- <UI/API/domain/data/etc.>

#### Documentation Updates Required

- <docs, diagrams, README, ADRs, API docs, examples>
```

After defining slices, create or update:

```text
FEATURES.md
todo.md
implemented.md
```

Do this before writing implementation code.

See `references/vertical-slice-examples.md` for two worked examples (.NET / C# / xUnit and
Python / FastAPI / pytest) using the same URL Shortener feature. Full end-to-end walkthroughs for
each stack live in `references/dotnet-url-shortener-vertical-slices.md` and
`references/python-url-shortener-vertical-slices.md`.

---

## Phase 4: Write Tests First

For each slice, write tests before implementation.

Work one slice at a time.

For the current slice:

1. Identify requirements and acceptance criteria covered by the slice.
2. Write tests that prove those requirements and ACs.
3. Prefer behavior through public interfaces.
4. Avoid testing private methods or implementation details.
5. Prefer integration-style tests when they better prove vertical behavior.
6. Use unit tests for domain logic, validation, and edge cases where appropriate.
7. Ensure test names read like specifications.

Good test names (any stack — adapt casing to the language idiom):

```text
CreateShortUrl_WithValidUrl_ReturnsCreatedResponse
CreateShortUrl_MissingUrl_Returns400
ResolveShortCode_WhenExists_IncrementsClickCount

test_create_short_url_with_valid_url_returns_201
test_resolve_short_code_when_unknown_returns_404_and_does_not_increment
```

Bad test names:

```text
RepositoryWorks
HandlerTest
TestCreate
ShouldCallMapper
```

Tests must map back to requirements and acceptance criteria.

When possible, add comments identifying the related requirement or AC:

```csharp
// Covers REQ-002, AC-003
```

```python
# Covers REQ-002, AC-003
```

See `references/tdd-red-green-refactor.md` for the red/green/refactor contract.

---

## Phase 5: Confirm Tests Fail

After writing tests for the current slice, run the relevant test command.

The tests must fail for the expected reason before implementation starts.

Required behavior:

1. Run the smallest relevant test set.
2. Capture or summarize the failing result.
3. Confirm the failure is meaningful.
4. If the test passes before implementation, inspect why.
5. If the test is invalid, fix the test and run it again.
6. Do not proceed to implementation until the test fails correctly.

A valid red phase means:

```text
The test fails because the requested behavior does not exist yet.
```

An invalid red phase includes:

```text
The test fails because of syntax errors unrelated to the behavior.
The test fails because the test setup is broken.
The test passes before implementation.
The test asserts implementation details instead of behavior.
```

If the red phase is invalid, fix the test before proceeding.

---

## Phase 6: Implement One Slice

Implement only the current vertical slice.

Do not implement future slices early.

Do not add speculative abstractions.

Do not perform unrelated rewrites.

Do not change unrelated behavior.

Implementation should be the minimum clean code required to satisfy the current slice tests.

During implementation:

1. Keep the slice vertically coherent.
2. Touch only files needed for the slice.
3. Preserve existing public behavior unless change is explicitly required.
4. Follow repository conventions.
5. Keep code readable and maintainable.
6. Prefer simple designs over clever abstractions.
7. Run relevant tests frequently.

When the slice tests pass, run appropriate nearby regression tests.

---

## Phase 7: Refactor While Green

After the current slice is passing, evaluate whether refactoring is needed.

Refactor only while tests are green.

Refactor when there is:

- duplication,
- unclear naming,
- overly complex conditionals,
- leaky abstractions,
- unnecessary coupling,
- violated repository conventions,
- test brittleness,
- poor separation of concerns,
- documentation drift.

Do not refactor just for novelty.

After refactoring, run the relevant tests again.

The slice is not complete until tests pass after refactoring.

`refactoring-pass` governs the discipline for this phase in more depth — preserve observable
behavior, work in small reversible steps, and establish a safety net before any risky change.

---

## Phase 8: Update Documentation, Diagrams, and Markdown

After a slice is implemented and verified, update all affected documentation.

This includes, when relevant:

- README files,
- API documentation,
- architecture docs,
- ADRs,
- Mermaid diagrams,
- Draw.io diagrams,
- sequence diagrams,
- data flow diagrams,
- configuration docs,
- developer setup docs,
- test documentation,
- markdown files in `docs/`,
- inline examples or usage snippets.

If diagrams exist and the slice changes behavior, architecture, dependencies, data flow, user flow, API flow, integration boundaries, or deployment topology, update the diagrams.

If no docs or diagrams require updates, explicitly record that in `implemented.md`:

```markdown
#### Documentation Updated

- None required - behavior is internal and existing docs remain accurate.

#### Diagrams Updated

- None required - no architecture, flow, dependency, or topology changes.
```

See `references/doc-update-checklist.md` for the documentation update contract.

---

## Phase 9: Move Slice from Todo to Implemented

When a slice is complete:

1. Remove the slice from `todo.md`.
2. Append the completed slice entry to `implemented.md`.
3. Update the slice status in `FEATURES.md` to `Implemented`.
4. Update `FEATURES.md` test and docs columns.
5. If another slice is next, mark it clearly as the next candidate.
6. If all slices are complete, set overall status to `Complete`.

This bookkeeping is mandatory for **Feature** and **Large** bands.

A slice is not complete until the tracking files are updated.

---

## Phase 10: Completion Summary

At the end of each completed slice, provide this summary:

```markdown
## Slice Complete: VS-### - <Slice Name>

### Implemented

- <summary>

### Tests

- Red phase confirmed: Yes
- Green phase confirmed: Yes
- Test command(s):
  - `<command>`

### Docs Updated

- `<path>`
- `<path>`

### Tracking Updated

- `FEATURES.md`
- `todo.md`
- `implemented.md`

### Next Slice

- VS-### - <name>
```

At the end of the full implementation, provide this summary:

```markdown
## Feature Complete

### Implemented Slices

- VS-001 - <name>
- VS-002 - <name>

### Requirements Satisfied

- REQ-001
- REQ-002

### Acceptance Criteria Satisfied

- AC-001
- AC-002

### Tests Added / Updated

- `<path>`

### Documentation Updated

- `<path>`

### Remaining Work

- None
```

---

## Required Discipline

For any change above the **Trivial** band, follow these rules strictly:

- Ask clarifying questions when required for correctness.
- Convert vague requests into testable requirements.
- Convert requirements into acceptance criteria.
- Break work into vertical slices before coding (Feature and Large bands).
- Create or update `FEATURES.md`, `todo.md`, and `implemented.md` before coding (Feature and Large bands).
- Work one slice at a time.
- Write tests before implementation.
- Confirm tests fail before implementation.
- Implement the minimum code needed for the current slice.
- Refactor only while green.
- Update docs and diagrams after each completed slice.
- Move completed slices from `todo.md` to `implemented.md`.
- Update `FEATURES.md` after every slice.
- Do not claim completion until tests and docs are updated.
- Do not perform git commits, pushes, or PR creation unless explicitly asked.

---

## Anti-Patterns to Avoid

Do not:

- Start coding immediately (except on the **Trivial** band).
- Skip clarifying questions when requirements are ambiguous.
- Write implementation before tests.
- Write all implementation before any tests.
- Write all tests for all slices and then implement everything afterward.
- Build horizontal layers instead of vertical slices.
- Add speculative future functionality.
- Leave docs stale.
- Leave diagrams stale.
- Forget to update the markdown tracking files.
- Mark a slice implemented while it still exists in `todo.md`.
- Claim tests pass without running or observing the relevant test command.
- Treat private methods as the primary test target.
- Mock internal collaborators just to make testing easier.
- Refactor while tests are red.
- Allow implementation details to redefine the acceptance criteria.
- Upgrade a **Trivial** change into a **Feature** just to run the full workflow.

---

## If Existing Project Conventions Conflict

If the repository already has established conventions for documentation location, test naming, issue tracking, feature plans, ADRs, diagrams, changelogs, or status tracking, follow the repository conventions while preserving this workflow.

If conventions are unclear, use the default files and structure defined here.

---

## Default Startup Response

When this skill activates, begin with this shape:

```markdown
I'll use the vertical-slice TDD workflow for this.

Band: <Trivial | Small | Feature | Large> — <one-line justification>.

<If Trivial: just do the change and stop.>

<Otherwise:> First I'll clarify anything that affects correctness, then I'll define testable
requirements and acceptance criteria, break the work into vertical slices, create or update the
slice tracking markdown files (Feature/Large only), write failing tests for the first slice,
confirm red, implement the minimum code to go green, refactor, then update docs and move the slice
from todo to implemented.
```

If clarifying questions are needed, ask them immediately.

If no clarifying questions are needed, proceed directly to requirements and acceptance criteria (or
just do the change, for **Trivial**).

---

## Changelog

Maintained by Kurt Mitchell. Versioning is MAJOR.MINOR.PATCH — MINOR for new capabilities that
don't change existing behavior, PATCH for clarifications and fixes. The top entry here must match
the `version` field in the frontmatter (under `metadata`).

### 1.1.0 — 2026-07-23
- Structural normalization pass to bring this skill onto the collection's shared SKILL.md skeleton
  (frontmatter → `## Purpose` → skill-specific sections, each separated by `---` → `##
  Proportionality` → `## Changelog`), matching `feynman-peer-review`, `investigation-carryover`,
  `refactoring-pass`, `legacy-code-safety`, `pragmatic-engineering`, `software-design-simplicity`,
  and `production-reliability`.
  - Added an explicit `## Purpose` heading, combining the previously unheaded workflow summary
    with the content of the now-removed package `README.md`.
  - Renamed the `Phase 0 — Proportionality` heading to `## Proportionality` to match the shared
    heading text. Deliberately kept it positioned right after Purpose rather than moving it to
    the collection's usual just-before-Changelog spot: for this skill, the band choice gates
    whether the rest of the workflow's phases run at all, so it has to be judged first. This is a
    documented, skill-specific deviation from the generic skeleton position, not an
    inconsistency.
  - Folded the separate `CHANGELOG.md`, `README.md`, and `LICENSE` files into this `SKILL.md` (this
    section and Purpose). No other skill in this collection carries per-skill README, CHANGELOG,
    or LICENSE files as separate files.
  - Moved `examples/dotnet-url-shortener-vertical-slices.md` and
    `examples/python-url-shortener-vertical-slices.md` into `references/`, and removed the
    `examples/` folder, to match the collection's `SKILL.md` + `references/` (+ `scripts/` /
    `assets/`) layout — no other skill here uses a top-level `examples/` folder.
  - Removed `scripts/verify-package.sh` and `scripts/verify-package.ps1` in favor of the shared
    `skill-creator` `quick_validate.py` already used to validate the rest of the collection,
    avoiding a bespoke duplicate validator per skill.
  - Moved the frontmatter `version` key under `metadata.version` to match the collection's
    recognized frontmatter schema (`name`, `description`, `license`, `allowed-tools`,
    `compatibility`, `metadata` are the only top-level keys the packaging validator recognizes).
  - No workflow content, phase logic, or band definitions changed — this is a packaging and
    structure normalization only.

### 1.0.0 — 2026-07-23
- Initial release. This skill's origin differs from the rest of the collection: it is original
  workflow content, not distilled from a published book via the agent-rules-books project, and it
  was authored Copilot-first — the GitHub Copilot Pro edition existed first and this Claude
  edition was adapted from it. That is the reverse of every other skill in this collection, where
  the Claude edition is authored first and Copilot is the port.
  - **Phase 0 — Proportionality** bands (Trivial / Small / Feature / Large) so a typo fix is no
    longer forced through the full ten-phase workflow.
  - Two worked examples using the same URL Shortener feature: one in .NET / C# / xUnit and one in
    Python / FastAPI / pytest, with stack labels explicit.
  - `allowed-tools` in frontmatter covering common test runners (`dotnet test`, `npm test`,
    `pytest`, `go test`, `cargo test`, `mvn test`, `gradle test`) plus `Read`, `Write`, `Edit`,
    `Glob`, `Grep`, so the workflow runs end-to-end without repeatedly prompting for permissions.
  - Example domain intentionally kept generic (URL Shortener) to avoid any risk of proprietary
    content leaking into a shareable skill.
