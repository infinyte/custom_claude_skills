# Repository Layout

This repository is organized around two target platforms that share the same skill concepts.

## Top-Level Structure

```text
AI-Agent-Skills/
  docs/
  Claude Skills/
  GitHub Copilot Pro Skills/
```

- `docs/` contains repo-wide navigation and inventory notes.
- `Claude Skills/` contains the Claude-targeted packages.
- `GitHub Copilot Pro Skills/` contains the Copilot-targeted packages.

## Claude Package Family

Every skill is organized as a direct skill folder:

```text
<skill-name>/
  SKILL.md
  references/
  <skill-name>.skill      # checked-in packaged archive, kept alongside the source
```

`scripts/` or `assets/` are added only where a specific skill genuinely needs them; none of the
skills currently in this folder do. No skill carries a separate per-skill `README.md`,
`CHANGELOG.md`, or `LICENSE` file — that content lives inside `SKILL.md`'s `## Purpose` and
`## Changelog` sections instead.

## GitHub Copilot Pro Package Family

Every skill is also stored as a direct skill folder, with the same shape as the Claude side minus
the packaged archive (Copilot has no `.skill`-equivalent format):

```text
<skill-name>/
  SKILL.md
  references/
```

Skills are installed by dropping the folder into `.github/skills/<skill-name>/` (or
`.claude/skills/`, `.agents/skills/`) — see `GitHub Copilot Pro Skills/README.md` for the full
installation paths. No skill in this folder ships a `.github/`-rooted repository-install bundle,
separate prompt/instructions wrapper files, or per-skill README/CHANGELOG/LICENSE files.

## Source Of Truth Rules

- `SKILL.md` is the canonical, self-contained instruction file for each skill package — nothing
  outside it (and the `references/` material it points to) is required reading to use the skill.
- `references/` holds support material the skill loads on demand; it is not a separate skill.
- The docs in this folder describe the repository inventory and layout only; they do not replace
  the per-skill instructions.
