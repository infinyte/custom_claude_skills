# Skill Index

This index summarizes the skills currently checked into the repository and where their canonical
entry points live.

## Current Inventory

| Skill | Claude edition | GitHub Copilot Pro edition | Current notes |
| --- | --- | --- | --- |
| `feynman-peer-review` | `Claude Skills/feynman-peer-review/` | `GitHub Copilot Pro Skills/feynman-peer-review/` | Claude folder includes a checked-in `.skill` package and reference docs. |
| `investigation-carryover` | `Claude Skills/investigation-carryover/` | `GitHub Copilot Pro Skills/investigation-carryover/` | Claude folder includes a checked-in `.skill` package and example package docs. |
| `refactoring-pass` | `Claude Skills/refactoring-pass/` | `GitHub Copilot Pro Skills/refactoring-pass/` | Both editions include reference material; Claude folder also includes a `.skill` package. |
| `legacy-code-safety` | `Claude Skills/legacy-code-safety/` | `GitHub Copilot Pro Skills/legacy-code-safety/` | Both editions include reference material; Claude folder also includes a `.skill` package. |
| `pragmatic-engineering` | `Claude Skills/pragmatic-engineering/` | `GitHub Copilot Pro Skills/pragmatic-engineering/` | Both editions include reference material; Claude folder also includes a `.skill` package. |
| `software-design-simplicity` | `Claude Skills/software-design-simplicity/` | `GitHub Copilot Pro Skills/software-design-simplicity/` | Both editions include reference material; Claude folder also includes a `.skill` package. |
| `production-reliability` | `Claude Skills/production-reliability/` | `GitHub Copilot Pro Skills/production-reliability/` | Both editions include reference material; Claude folder also includes a `.skill` package. |
| `vertical-slice-tdd` | `Claude Skills/vertical-slice-tdd/` | `GitHub Copilot Pro Skills/vertical-slice-tdd/` | Both editions include reference material; Claude folder also includes a `.skill` package. Originally packaged with per-skill README/CHANGELOG/LICENSE files and (Copilot edition) a `.github/` repository-install bundle — normalized onto the same flat `SKILL.md` + `references/` layout as every other skill here; see the skill's Changelog for what changed. |

## Canonical Entry Points

Every package in both families follows the same rule: start with the package's `SKILL.md` — it's
the canonical, self-contained instruction file. No package requires reading anything outside
`SKILL.md` and its `references/` folder to use it.

## Current Packaging Notes

- The Claude package family has a checked-in `.skill` artifact for every skill listed above.
- The Copilot package family is source-first (no `.skill`-equivalent archive format); every skill
  is a flat `SKILL.md` + `references/` folder, installed by copying it into `.github/skills/`,
  `.claude/skills/`, or `.agents/skills/` per that folder's README. There is no longer a packaging
  outlier in this family — `vertical-slice-tdd` used to ship as a `.github/`-rooted
  repository-install bundle with separate prompt and instructions wrapper files; that bundle has
  been folded into the standard layout (see `GitHub Copilot Pro Skills/vertical-slice-tdd/SKILL.md`'s
  Changelog for the normalization details).
