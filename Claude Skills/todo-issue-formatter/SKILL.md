---
name: todo-formatter
description: Transform unstructured project plans, task lists, or feature descriptions into standardized, well-formatted todo issues in Markdown. Use this skill whenever the user provides raw project notes, feature lists, requirements docs, or any informal task descriptions and wants them formatted as clean, professional todo issues with consistent structure (issue number, title, priority, status, dependencies, description, acceptance criteria). Trigger on phrases like "format these tasks", "clean up project plan", "create todo issues", "standardize tasks", or when given a messy task/feature list alongside a reference to a well-formatted example. Essential for maintaining consistent project documentation style.
---

# Todo Formatter Skill

Transform unstructured project plans, task lists, and feature descriptions into professionally formatted todo issues using a consistent, Markdown-based structure.

## Purpose

This skill helps you convert informal project notes, scattered requirements, or raw task lists into standardized todo issues that match a defined style guide. It's ideal for:

- **Project onboarding**: Converting scattered feature requests into uniform backlog items
- **Sprint planning**: Cleaning up informal task notes into issue-format deliverables
- **Documentation consistency**: Ensuring all issues follow the same structure and style
- **Handoff clarity**: Making project plans more readable and actionable for teams

## The Standard Format

Your reference format uses this structure for each issue:

```markdown
### Issue N
- Issue Number: N
- Title: [Descriptive issue title]
- Priority: [High/Medium/Low]
- Status: [Not started/In progress/Done]
- Description: [Clear description of what needs to be done]
- Acceptance Criteria:
  1. [Specific, verifiable criterion]
  2. [Specific, verifiable criterion]
  3. [etc.]
```

**Optional field** (include if present in source):
- `Depends On: Issue X` — Link to blocking/prerequisite issues

## Workflow

### Step 1: Provide Your Input

Share the unstructured project plan. This can be:
- Informal notes from a meeting or brainstorm
- A requirements document with features listed
- A loose task list or feature backlog
- Email descriptions of work
- Comments or fragments from planning docs
- Any combination of the above

### Step 2: Provide a Reference Example (Optional but Recommended)

If you have an existing well-formatted example (like your todo.md), share it. This ensures the output matches your exact style for:
- Field wording and order
- Priority naming conventions (High/Medium/Low vs. P0/P1/etc.)
- Status values
- Tone and description length
- Acceptance criteria style

If not provided, the skill defaults to the standard format shown above.

### Step 3: Specify Any Constraints

Tell me if:
- Certain issues depend on others
- Issues should start at a specific number (default: 1)
- You want only certain issues formatted (vs. all of them)
- You have naming conventions for fields (e.g., "Blocked By" instead of "Depends On")
- Any issues should skip certain fields

### Step 4: Receive Formatted Output

The skill returns a clean Markdown file with all issues formatted consistently, ready to:
- Copy into your project management system
- Share with your team
- Use as a source of truth for backlog items
- Iterate and refine further

## Key Principles

**Consistency**: Every field follows the same structure and naming convention.

**Clarity**: Acceptance criteria are specific and verifiable (not vague goals).

**Dependencies**: Issues that block or depend on others are explicitly linked.

**Completeness**: Title, description, and criteria are complete enough to be actionable.

**Tone**: Professional but readable—suitable for technical documentation.

## Example Transformation

**Input** (unstructured notes):
```
- Add a realistic paper trading mode with real fees
  - should support different brokers/fee structures
  - apply slippage based on order side
  - fallback to live quotes when available
  - also need to wire this into the trading config system

- Frontend UI for realistic paper mode
  depends on: the paper trading mode (above)
  - add a selector button
  - show/hide broker config based on mode
  - update the history display to show which mode was used
```

**Output** (formatted):
```markdown
### Issue 4
- Issue Number: 4
- Title: Backend Realistic Paper Exchange
- Priority: Medium
- Status: Not started
- Description: Implement realistic paper trading with live pricing fallback, fees, and slippage.
- Acceptance Criteria:
  1. Add RealisticPaperExchange implementing exchange interface.
  2. Use live quote source with fallback behavior.
  3. Support provider fee presets.
  4. Apply slippage by side.
  5. Deduct fees and return commission details in orders.
  6. Add backend unit tests for fee and slippage behavior and fallback.
  7. Backend type-check and tests pass.

### Issue 5
- Issue Number: 5
- Title: Frontend Realistic Paper Mode UI
- Priority: Medium
- Status: Not started
- Depends On: Issue 4
- Description: Add realistic paper option to mode selector and update display labeling.
- Acceptance Criteria:
  1. Add mode selector button.
  2. Show/hide broker configuration based on mode.
  3. Update history display to show mode information.
  4. Frontend type-check and tests pass.
```

## How to Use This Skill

1. **Upload or paste** your unstructured project plan.
2. **Share a reference example** (your existing well-formatted todo.md or similar) if available.
3. **Specify any special requirements**: starting issue number, dependency mapping, priority conventions, etc.
4. **Receive** a formatted Markdown file ready to use.

I'll:
- Parse the content and identify distinct issues/tasks
- Map informal descriptions to structured fields
- Infer Priority and Status if not explicitly stated (default: Medium priority, Not started status)
- Extract or consolidate acceptance criteria from the source
- Identify and link dependencies
- Return clean, professional Markdown matching your style guide

---

## Tips for Best Results

**Be specific in your input**: The clearer your task descriptions, the better the acceptance criteria I can extract.

**Include dependencies**: If one task blocks another, mention it (e.g., "depends on issue X" or "needs X to be done first").

**Provide a style reference**: If you have existing well-formatted issues, include them so the output matches exactly.

**Review the output**: After formatting, you may want to refine acceptance criteria, adjust priorities, or add dependencies you noticed. That's expected—the skill provides a strong starting point, not the final version.

**Iterate**: If the first pass needs tweaks, share feedback and I'll refine it.
