# Repository Standardization Plan

## Objective

Standardize all skills, documents, markdown files, and packaging artifacts so the repository is:

- Easy to navigate.
- Consistent to maintain.
- Predictable to extend.
- Safe to automate.

## Execution Status (2026-07-24)

Completed in this pass:

- Added a root `README.md` with repository navigation and governance direction.
- Corrected repo-level documentation to match the current repository structure.
- Restored source files (`SKILL.md`) for package-only skills by extracting packaged artifacts.
- Added `references/index.md` for skills that previously lacked explicit references structure.
- Added shared templates and policy docs:
	- `docs/templates/SKILL.template.md`
	- `docs/templates/references-index.template.md`
	- `docs/markdown-style-guide.md`
	- `docs/document-lifecycle.md`
- Added per-folder documentation authority maps in:
	- `Claude Skills/github-pages-generator/docs-index.md`
	- `Claude Skills/github-project-analyzer/docs-index.md`
- Added automated validation gate:
	- `scripts/validate-repo-structure.ps1`
	- `.github/workflows/repo-validation.yml`
- Added docs quality gates in CI:
	- `scripts/lint-markdown.ps1`
	- `scripts/check-markdown-links.ps1`
	- `.github/workflows/docs-quality.yml`
- Archived legacy markdown snapshots in high-volume skill folders and updated active references.
- Normalized `todo-issue-formatter` package artifact name to `todo-issue-formatter.skill`.

Open items from this plan now focus on deeper consolidation and automation.

## Scope

In scope:

- Every folder under Claude Skills.
- Every markdown and text documentation file.
- Every packaged .skill artifact and related metadata.
- Repo-level docs and navigation files.

Out of scope for initial pass:

- Changing core skill behavior unless required for consistency.
- Rewriting technical content that is already accurate and complete.

## Baseline findings from repository review

1. Structural inconsistency across skill folders.
2. Three skill folders were package-only with no SKILL.md source. Status: resolved in this pass.
3. Two skill folders have large, fragmented documentation sets outside the common pattern.
4. Repo-level docs referenced layout that did not fully match current repository contents. Status:
	resolved in this pass.
5. Naming and file conventions vary across documents.

## Target standards

### Standard skill folder shape

Each skill folder should converge to:

- SKILL.md
- references/
- Optional scripts/
- Optional assets/
- Optional package artifact named skill-name.skill

### Standard document taxonomy

Use four documentation layers only:

1. Root README for repo overview and navigation.
2. docs/ for cross-repo policies and indexes.
3. Skill-level SKILL.md as canonical instructions.
4. references/ for deep supporting material.

### Standard naming conventions

- Kebab-case for skill folder names.
- UPPER_SNAKE_CASE only for widely accepted doc names if retained, otherwise kebab-case markdown names.
- One naming scheme for phase docs, examples, and guides.

### Standard markdown style

- Consistent heading hierarchy with one H1 per file.
- Consistent section ordering for skill docs.
- Consistent link style and relative path usage.
- Consistent callout terms for status, decisions, and next steps.

## Execution plan

## Phase 1: Inventory and classification

Deliverables:

- Full file inventory by type and folder.
- Classification matrix: canonical, duplicate, legacy, archive, generated.
- Owner and decision log for each ambiguous file set.

Actions:

1. Generate a machine-readable inventory snapshot.
2. Tag each file with lifecycle status.
3. Identify exact duplicate or near-duplicate docs.

Exit criteria:

- Every documentation file is classified.

## Phase 2: Define standards and templates

Deliverables:

- Skill folder contract document.
- SKILL.md template and references index template.
- Markdown style guide for this repository.
- Naming convention guide and migration map.

Actions:

1. Publish templates in docs/templates.
2. Approve mandatory versus optional sections.
3. Define deprecation markers for legacy docs.

Exit criteria:

- Standards approved and ready for migration.

## Phase 3: Skill structure normalization

Deliverables:

- Source-complete skill folders for all package-only skills.
- references folders created or intentionally omitted with rationale.
- Consistent artifact naming.

Actions:

1. Reconstruct SKILL.md source for package-only folders.
2. Add minimal references index where missing.
3. Normalize package artifact naming to folder name.

Exit criteria:

- No skill folder remains package-only.
- Every skill matches the standard folder contract.

## Phase 4: Documentation consolidation

Deliverables:

- Reduced doc sprawl in github-pages-generator and github-project-analyzer.
- Canonical guides with archives for superseded content.
- Updated cross-links and navigation files.

Actions:

1. Merge overlapping phase summaries into single canonical tracks.
2. Move historical snapshots into docs/archive with clear labels.
3. Keep one active README and one quick reference per complex skill.

Exit criteria:

- No active duplicate docs with overlapping authority.

## Phase 5: Repo-level doc correction

Deliverables:

- Updated docs/README.md, docs/repository-layout.md, docs/skill-index.md aligned with actual tree.
- Accuracy checks for platform references and folder links.

Actions:

1. Remove or correct stale references to absent folder trees.
2. Refresh inventory tables.
3. Add a maintenance cadence section.

Exit criteria:

- Repo-level docs fully match the repository state.

## Phase 6: Quality gates and automation

Deliverables:

- Markdown lint configuration.
- Link validation and path validation scripts.
- Optional frontmatter schema validation for SKILL.md files.

Actions:

1. Add markdown lint and link check commands.
2. Add CI job for docs and structure checks.
3. Add pre-release checklist for skill package updates.

Exit criteria:

- Quality checks run automatically on pull requests.

## Phase 7: Controlled rollout

Deliverables:

- Migration changelog.
- Contributor update notes.
- Final verification report.

Actions:

1. Batch changes by skill family.
2. Preserve backward-compatible paths where practical.
3. Publish final migration summary.

Exit criteria:

- Standardized repository with complete audit trail.

## Priority backlog

Priority 1:

- Correct repo-level docs that conflict with actual structure.
- Add SKILL.md source for package-only skills.

Priority 2:

- Consolidate high-volume documentation folders.
- Normalize naming and heading patterns.

Priority 3:

- Add automation and policy enforcement.

## Risks and mitigations

Risk: Losing historical context while consolidating docs.
Mitigation: Archive before merge and preserve dated snapshots.

Risk: Breaking links during renames.
Mitigation: Run automated link validation after each batch.

Risk: Inconsistent interpretation of canonical versus legacy docs.
Mitigation: Maintain one decision log with explicit ownership.

## Success metrics

- 100 percent of skills match standard folder contract.
- 100 percent of markdown docs pass lint and link checks.
- Zero stale cross-references in repo-level docs.
- At least 50 percent reduction in overlapping documentation files in high-volume skill folders.

## Suggested implementation order

1. Repo-level doc corrections.
2. Package-only skill source reconstruction.
3. High-volume folder consolidation.
4. Automation rollout.
5. Final pass and sign-off.