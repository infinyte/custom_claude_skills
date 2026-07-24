# Tracking File Templates

Use these exact templates unless the repository already has stronger conventions.

## FEATURES.md

```markdown
# Feature Implementation Summary

## Feature / Change

<Short description of the requested implementation>

## Current Status

- Overall status: Not Started | In Progress | Complete
- Current slice: <slice id and name, or None>

## Vertical Slices

| Slice ID | Slice Name | User / Business Value | Status | Tests Written | Tests Passing | Docs Updated |
|---|---|---|---|---|---|---|
| VS-001 | <name> | <value> | Todo | No | No | No |
```

Allowed status values:

```text
Todo
In Progress
Implemented
Blocked
Deferred
```

## todo.md

```markdown
# Vertical Slice Todo

## Queue Rules

- Implement slices in order unless blocked.
- Complete one slice before starting the next.
- Each slice must have failing tests before implementation.
- Each slice must update docs before being moved to implemented.md.

## Remaining Slices

### VS-001 - <Slice Name>

Status: Todo

#### Goal

<What this slice accomplishes>

#### Requirements

- REQ-001: <testable requirement>

#### Acceptance Criteria

- AC-001: Given <context>, when <action>, then <observable result>.

#### Tests to Write

- <test name or test behavior>

#### Implementation Notes

- <known notes, constraints, or affected layers>

#### Documentation to Update

- <docs, diagrams, README, ADRs, API docs, examples, etc.>
```

## implemented.md

```markdown
# Implemented Vertical Slices

## Completed Slices

### VS-001 - <Slice Name>

Status: Implemented

#### Completed Summary

<What was implemented>

#### Requirements Satisfied

- REQ-001: <requirement>

#### Acceptance Criteria Satisfied

- AC-001: <acceptance criterion>

#### Tests Added / Updated

- <test file and behavior>

#### Verification Evidence

- Failing test observed before implementation: Yes
- Passing test observed after implementation: Yes
- Relevant test command(s):
  - `<command>`

#### Files Changed

- `<path>` - <summary>

#### Documentation Updated

- `<path>` - <summary>

#### Diagrams Updated

- `<path>` - <summary, or "None required">

#### Notes / Follow-ups

- <optional notes>
```
