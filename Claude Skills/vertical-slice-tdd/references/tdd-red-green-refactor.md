# TDD Red / Green / Refactor Contract

## Red

Write the smallest executable test set for the current vertical slice.

A valid red phase must fail because the requested behavior does not exist yet.

A red phase is invalid if the failure is caused by broken setup, syntax errors, missing test infrastructure, or assertions against implementation details.

Before proceeding, summarize:

```markdown
### Red Phase Evidence

- Test command: `<command>`
- Failing test(s): `<test names>`
- Expected failure reason: `<reason>`
- Red phase valid: Yes | No
```

## Green

Implement the minimum clean code required to pass the current slice tests.

Do not implement future slices.

Do not change tests unless the red phase was invalid or the acceptance criteria were wrong.

Before proceeding, summarize:

```markdown
### Green Phase Evidence

- Test command: `<command>`
- Passing test(s): `<test names>`
- Files changed: `<paths>`
- Green phase valid: Yes | No
```

## Refactor

Refactor only while tests are green.

Run the relevant tests again after refactoring.

Do not refactor for novelty. Refactor only for clarity, duplication removal, stronger boundaries, simpler design, better naming, or documented repository conventions.
