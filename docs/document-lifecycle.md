# Document Lifecycle

## States

Use one lifecycle state for each doc set:

- canonical: Primary source of truth for an active topic.
- supporting: Useful adjunct content that depends on a canonical doc.
- legacy: Historical content retained for context but not authoritative.
- archived: Inactive historical record moved out of active navigation.
- generated: Tool output retained for traceability.

## Required Metadata For Legacy Or Archived Files

At the top of legacy or archived docs, include:

- Status: Legacy or Archived
- Canonical Replacement: Relative path or "None"
- Reason: Why this file remains
- Last Reviewed: YYYY-MM-DD

## Consolidation Rules

1. One active README per skill folder.
2. One active quick reference per skill folder.
3. Merge overlapping summaries into canonical docs.
4. Move superseded material into an archive folder with status headers.

## Review Cadence

- Review high-change folders monthly.
- Review stable folders quarterly.
- Validate links and status markers in each review pass.
