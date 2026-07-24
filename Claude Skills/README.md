# Claude Skills

Custom skills written for Claude's Agent Skills format (Claude.ai, Claude Code, and Cowork all
read the same `SKILL.md` structure).

## Layout

Each skill is a folder named for the skill (kebab-case, matching its frontmatter `name`):

```
<skill-name>/
├── SKILL.md              # required — YAML frontmatter (name, description, ...) + instructions
├── references/           # optional — docs the skill points to and reads on demand
├── scripts/               # optional — executable helpers
└── assets/                 # optional — templates, fonts, icons used in output
```

## Installing a skill

- **Claude.ai / Cowork:** package the folder as a `.skill` file (a zip — see below) and upload it,
  or drag the folder in directly where the interface supports it.
- **Claude Code:** copy the skill folder into `~/.claude/skills/<skill-name>/` (personal, all
  projects) or `<repo>/.claude/skills/<skill-name>/` (project-scoped).

### Packaging a `.skill` file

If you have the `skill-creator` skill available, it ships a packaging script:

```bash
python -m scripts.package_skill path/to/<skill-name> [output-dir]
```

This zips the folder and validates the frontmatter (`name`, `description`, and — if present —
`license`, `allowed-tools`, `compatibility`, `metadata` are the only recognized top-level keys).

## Shared SKILL.md structure

Every skill in this folder follows the same skeleton, so they read consistently regardless of
what each one actually does:

1. Frontmatter — `name`, `description` (third person, states what it does and when to trigger,
   ≤1024 chars), `metadata: {version: X.Y.Z}`.
2. `# Title Case Name` (H1).
3. `## Purpose` — what the skill does and why, attribution/provenance if the content is
   derived from a third-party source, a pointer to `references/` material, and a "When this
   doesn't fit" note scoping when *not* to use it.
4. Skill-specific sections, each separated from the next by a `---` rule.
5. `## Proportionality` — how the skill's rigor should scale with the stakes of the work (a
   throwaway spike gets a lighter touch than a mature, actively-evolving production system).
6. `## Changelog` (always the final section) — "Maintained by Kurt Mitchell," a
   MAJOR.MINOR.PATCH versioning note, and "the top entry here must match the `version` field
   in the frontmatter." Newest entry first.

New skills added to this folder should follow this same shape rather than inventing a new one.

## Skills in this folder

- **`feynman-peer-review/`** — a four-pass engineering review (Feynman clarity check, Enterprise
  Architect, Principal Engineer, Devil's Advocate) with a Severity Bridge that reconciles the
  four voices into one ranked, actionable list. See `feynman-peer-review/SKILL.md`.
- **`investigation-carryover/`** — session-continuity format for any multi-session
  investigation, audit, or research project: a structured XML package (findings, open
  questions, access gaps, next steps) carried from one Claude session into the next, plus
  open/close protocols for using it. Domain-agnostic — see
  `investigation-carryover/references/example-package.md` for a technical audit and a
  journalism source-tracking example side by side. Generalized from a project-specific
  original; see the Changelog in `investigation-carryover/SKILL.md` for what changed.
- **`refactoring-pass/`** — applies Martin Fowler's *Refactoring* discipline (preserve
  behavior, small reversible steps, safety net before risky changes, the named refactoring
  moves) to any request to clean up, restructure, or de-risk existing code. Includes a
  Proportionality gate so the discipline scales to the stakes instead of applying at full
  strength to a throwaway spike. Distilled from the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed);
  see `refactoring-pass/SKILL.md`'s Changelog for attribution and what was added in
  converting it to skill form.
- **`legacy-code-safety/`** — applies Michael Feathers' *Working Effectively with Legacy
  Code* discipline (characterize before redesign, find or create a seam, break the one
  blocking dependency) to any change touching code with weak or missing test coverage.
  Includes the same kind of Proportionality gate as `refactoring-pass`. Distilled from the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed);
  see `legacy-code-safety/SKILL.md`'s Changelog for attribution and what was added in
  converting it to skill form.
- **`pragmatic-engineering/`** — applies Andrew Hunt and David Thomas's *The Pragmatic
  Programmer* discipline (own the result beyond the local edit, DRY as one authoritative
  source per fact, orthogonality, reversibility, automation) as a general engineering
  operating style — the baseline the other rule-based skills here layer more specific
  discipline on top of. Distilled from the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed);
  see `pragmatic-engineering/SKILL.md`'s Changelog for attribution.
- **`software-design-simplicity/`** — applies John Ousterhout's *A Philosophy of Software
  Design* discipline (deep modules, information hiding, complexity as the primary metric) to
  designing or reshaping a module or interface — a design-time complement to
  `refactoring-pass`'s behavior-preserving cleanup focus. Distilled from the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed);
  see `software-design-simplicity/SKILL.md`'s Changelog for attribution.
- **`production-reliability/`** — applies Michael Nygard's *Release It!* discipline (explicit
  timeouts, disciplined retries, circuit breakers and bulkheads, backpressure, observability
  at every boundary) to any service, API, job, or queue that has to survive production
  failure. Distilled from the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed);
  see `production-reliability/SKILL.md`'s Changelog for attribution.
- **`vertical-slice-tdd/`** — a disciplined vertical-slice, test-driven workflow for any
  implementation, fix, or refactor request: judge the scale of the change first (a Proportionality
  gate, positioned right after Purpose here rather than at the end — see the skill's Changelog for
  why), clarify requirements, write testable acceptance criteria, write failing tests before each
  slice, implement one thin vertical slice at a time, then keep `FEATURES.md`/`todo.md`/
  `implemented.md` and docs in sync. Unlike the other skills here, this one is original content
  rather than distilled from agent-rules-books, and it governs the shape of a development task
  itself rather than one specific engineering discipline — see `vertical-slice-tdd/SKILL.md`'s
  Purpose and Changelog for how it relates to `refactoring-pass`, `legacy-code-safety`, and
  `pragmatic-engineering`.

A GitHub Copilot Pro edition of each skill here (where one exists) lives in the sibling
`../GitHub Copilot Pro Skills/` folder.
