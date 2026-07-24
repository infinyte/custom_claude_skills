# AI Agent Skills Repository

This repository contains reusable agent skills packaged for Claude-style skill workflows. It is organized as a skill library plus repo-level documentation that helps maintain and evolve the collection.

## What this repository includes

- A skill collection in Claude Skills, with each skill in its own folder.
- Repo-level inventory and navigation docs in docs.
- Packaged skill artifacts for many skills as .skill files.

## Repository layout

AI-Agent-Skills/
- Claude Skills/
  - feynman-peer-review/
  - investigation-carryover/
  - legacy-code-safety/
  - pragmatic-engineering/
  - production-reliability/
  - refactoring-pass/
  - software-design-simplicity/
  - vertical-slice-tdd/
  - github-pages-generator/
  - github-project-analyzer/
  - portfolio-showcase-generator/
  - prompt-architect/
  - todo-issue-formatter/
- docs/
  - README.md
  - repository-layout.md
  - skill-index.md
- LICENSE

## Skill folder conventions

Target convention for each skill folder:

- SKILL.md as the canonical skill definition.
- references/ for supporting material loaded on demand.
- Optional scripts/ and assets/ only when needed.
- Optional packaged artifact file named to match the skill.

Current repository reality:

- Most core skills follow SKILL.md plus references/.
- Some folders are package-only and do not yet include SKILL.md source.
- Some advanced skills include large standalone documentation sets not yet normalized to the shared pattern.

## Quick start

1. Open Claude Skills and choose a skill folder.
2. Read SKILL.md first.
3. Use references material only when the skill points to it.
4. Use docs/ for repo-wide navigation.

## Documentation map

- docs/README.md: Repo-level doc entry point.
- docs/repository-layout.md: Current structure and packaging notes.
- docs/skill-index.md: Skill inventory and location summary.
- Claude Skills/README.md: Claude skill authoring conventions.

## Current status summary

- The repository has a strong core pattern for most foundational skills.
- Documentation has grown organically and now needs consolidation.
- A formal standardization plan is tracked in docs/standardization-plan.md.

## Governance direction

The medium-term goal is one consistent, source-first skill package shape across all skills:

- One canonical SKILL.md per skill.
- One predictable references structure.
- One changelog strategy.
- One cross-repo documentation architecture.

See docs/standardization-plan.md for a phased execution roadmap.