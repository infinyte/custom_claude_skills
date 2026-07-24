# Skill Index

This index summarizes every skill currently checked into this repository and where each canonical
entry point lives.

## Current Inventory

| Skill | Path | SKILL.md | references/ | .skill package | Current notes |
| --- | --- | --- | --- | --- | --- |
| `feynman-peer-review` | `Claude Skills/feynman-peer-review/` | Yes | Yes | Yes | Standardized core skill structure. |
| `github-pages-generator` | `Claude Skills/github-pages-generator/` | Yes | Yes | No | Legacy snapshots moved to archive; canonical docs map in place. |
| `github-project-analyzer` | `Claude Skills/github-project-analyzer/` | Yes | Yes | No | Legacy snapshots moved to archive; canonical docs map in place. |
| `investigation-carryover` | `Claude Skills/investigation-carryover/` | Yes | Yes | Yes | Standardized core skill structure. |
| `legacy-code-safety` | `Claude Skills/legacy-code-safety/` | Yes | Yes | Yes | Standardized core skill structure. |
| `portfolio-showcase-generator` | `Claude Skills/portfolio-showcase-generator/` | Yes | Yes | Yes | SKILL.md restored from packaged artifact. |
| `pragmatic-engineering` | `Claude Skills/pragmatic-engineering/` | Yes | Yes | Yes | Standardized core skill structure. |
| `production-reliability` | `Claude Skills/production-reliability/` | Yes | Yes | Yes | Standardized core skill structure. |
| `prompt-architect` | `Claude Skills/prompt-architect/` | Yes | Yes | Yes | SKILL.md and supporting folders restored from packaged artifact. |
| `refactoring-pass` | `Claude Skills/refactoring-pass/` | Yes | Yes | Yes | Standardized core skill structure. |
| `software-design-simplicity` | `Claude Skills/software-design-simplicity/` | Yes | Yes | Yes | Standardized core skill structure. |
| `todo-issue-formatter` | `Claude Skills/todo-issue-formatter/` | Yes | Yes | Yes | SKILL.md restored from packaged artifact; package name normalized. |
| `vertical-slice-tdd` | `Claude Skills/vertical-slice-tdd/` | Yes | Yes | Yes | Standardized core skill structure. |

## Canonical Entry Points

Start with each package's `SKILL.md`. It is the canonical, self-contained instruction file.

Use supporting folders (`references/`, `scripts/`, `assets/`, `examples/`) only when the skill
explicitly points to them.

## Current Packaging Notes

- Most skills include a checked-in `.skill` artifact for distribution.
- `github-pages-generator` and `github-project-analyzer` are currently source-first folders in this
  repository snapshot (no `.skill` artifact currently checked in).
- `todo-issue-formatter` package artifact now matches the folder name
  (`todo-issue-formatter.skill`).

## Standardization Focus Areas

1. Continue reducing duplication in documentation-heavy skill folders by merging overlapping active
  guides where practical.
2. Keep archive placement stable and add archive references only from docs-index files.
3. Expand CI quality gates over time (for example, stricter link patterns and metadata checks).
