# Repository Layout

This repository is currently organized around one active package family: Claude skills.

## Top-Level Structure

```text
AI-Agent-Skills/
  docs/
  Claude Skills/
  LICENSE
  README.md
```

- `docs/` contains repo-wide navigation and inventory notes.
- `Claude Skills/` contains the Claude-targeted packages.
- `README.md` is the repository root entry point.

## Claude Skills Package Family

Target folder shape for each skill:

```text
<skill-name>/
  SKILL.md
  references/             # optional support material
  scripts/                # optional executable helpers
  assets/                 # optional templates or static assets
  <skill-name>.skill      # optional checked-in packaged archive
```

Most skills in this repository follow `SKILL.md` + `references/`. A few skills include larger
standalone documentation sets that are being normalized.

## Current Standardization Snapshot

- Source-complete core skills: `feynman-peer-review`, `investigation-carryover`,
  `legacy-code-safety`, `pragmatic-engineering`, `production-reliability`,
  `refactoring-pass`, `software-design-simplicity`, `vertical-slice-tdd`.
- Restored from package archives to source-first shape: `prompt-architect`,
  `portfolio-showcase-generator`, `todo-issue-formatter`.
- High-documentation-sprawl folders under active consolidation: `github-pages-generator`,
  `github-project-analyzer`.

See `standardization-plan.md` for rollout phases and success criteria.

## Source Of Truth Rules

- `SKILL.md` is the canonical, self-contained instruction file for each skill package.
- `references/` holds support material the skill loads on demand.
- Package artifacts (`.skill`) are distribution outputs; source files in the folder are
  authoritative for maintenance.
- The docs in this folder describe repository inventory and standards; they do not replace
  per-skill instructions.
