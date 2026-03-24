# Phase 1 Quick Reference Card

## Phase 1: Core Preference Flow (Foundation)

**Scope**: Ask users for report type and format preferences before analysis  
**Effort**: 2–4 hours  
**Risk**: Low (minimal changes, fully backward compatible)  
**Outcome**: Two-step preference flow ready for Phases 2–5

---

## What Phase 1 Does

```
BEFORE: Single question ("How would you like the report?")
AFTER:  Two questions (Type → Format, conditional)

Step 0A: "Full or Short report?"
         ↓
Step 0B: "What format?" (options depend on Step 0A)
         ↓
         Continue with analysis (Steps 1–6)
```

---

## The Two Steps

### Step 0A: Ask Report Type
```javascript
ask_user_input_v0({
  question: "What level of detail would you like?",
  options: [
    "Full Report (comprehensive, all sections, editorial depth)",
    "Short Report (essentials only, condensed)"
  ]
})
```

### Step 0B: Ask Output Format (Conditional)
```javascript
// If Full Report:
ask_user_input_v0({
  question: "How would you like the full report delivered?",
  options: [
    "Interactive HTML (navigable, dark mode, collapsibles)",
    "Comprehensive Markdown (GitHub-compatible)",
    "PDF (professional, print-ready)"
  ]
})

// If Short Report:
ask_user_input_v0({
  question: "How would you like the short report delivered?",
  options: [
    "Markdown (copyable, documentation-friendly)",
    "PDF (portable, shareable)"
  ]
})
```

---

## Preference Storage

Store both preferences as variables for use throughout analysis:

```javascript
let preferences = {
  reportType: "Full Report",        // or "Short Report"
  outputFormat: "HTML",              // or "Markdown", "PDF"
  
  // Convenience flags for conditionals
  isFullReport: true,                // for "if (isFullReport)"
  isShortReport: false,
  isHTML: true,
  isMarkdown: false,
  isPDF: false
};
```

---

## Validation Rules

| Scenario | Action |
|----------|--------|
| Full Report + HTML | ✅ Valid |
| Full Report + Markdown | ✅ Valid |
| Full Report + PDF | ✅ Valid |
| Short Report + HTML | ❌ Invalid → Switch to Markdown |
| Short Report + Markdown | ✅ Valid |
| Short Report + PDF | ✅ Valid |
| Preferences missing | ⚠️ Fallback → Full Report, Markdown |

---

## Implementation Functions

### Function 1: Capture Report Type
```javascript
async function captureReportTypePreference() {
  const response = await ask_user_input_v0({...});
  return response.includes("Full") ? "Full Report" : "Short Report";
}
```

### Function 2: Capture Output Format
```javascript
async function captureOutputFormatPreference(reportType) {
  // Different options based on reportType
  const response = await ask_user_input_v0({...});
  if (response.includes("HTML")) return "HTML";
  if (response.includes("Markdown")) return "Markdown";
  if (response.includes("PDF")) return "PDF";
}
```

### Function 3: Validate & Store
```javascript
function createPreferencesObject(reportType, outputFormat) {
  // Prevent invalid combinations
  if (reportType === "Short Report" && outputFormat === "HTML") {
    outputFormat = "Markdown"; // Switch to valid option
  }
  
  return {
    reportType,
    outputFormat,
    isFullReport: reportType === "Full Report",
    isShortReport: reportType === "Short Report",
    isHTML: outputFormat === "HTML",
    isMarkdown: outputFormat === "Markdown",
    isPDF: outputFormat === "PDF"
  };
}
```

### Function 4: Orchestrate Phase 1
```javascript
async function phase1_capturePreferences() {
  const reportType = await captureReportTypePreference();
  const outputFormat = await captureOutputFormatPreference(reportType);
  return createPreferencesObject(reportType, outputFormat);
}
```

---

## Integration into Main Skill

```javascript
async function analyzeGitHubRepository(githubUrl) {
  // ← ADD THIS: Phase 1 preference capture
  const preferences = await phase1_capturePreferences();
  
  // Create context object with preferences
  const context = {
    githubUrl,
    preferences,
    // Will be populated by Steps 1–6
    repoMetadata: null,
    codebaseInventory: null,
    artifacts: null,
    testCoverage: null,
    incompleteItems: null
  };
  
  // Steps 1–6: Analyze (UNCHANGED)
  context.repoMetadata = await step1_resolveRepository(context);
  context.codebaseInventory = await step2_inventoryCodebase(context);
  context.artifacts = await step3_deepReadArtifacts(context);
  context.testCoverage = await step4_assessTestCoverage(context);
  context.incompleteItems = await step5_identifyIncompleteWork(context);
  
  // Steps 7–8: Synthesis & output (ready for Phase 2+)
  // Phase 2 will add type-specific synthesis
  // Phases 3–5 will add format-specific output
  
  return context;
}
```

---

## Using Preferences in Later Phases

### In Phase 2 (Report Synthesis)
```javascript
function step7_synthesizeReport(context) {
  if (context.preferences.isFullReport) {
    // Generate full 7-section report
  } else {
    // Generate short 4-section report
  }
}
```

### In Phases 3–5 (Output Generation)
```javascript
function step8_generateOutput(context) {
  if (context.preferences.isHTML) {
    // Phase 4: Generate HTML
  } else if (context.preferences.isMarkdown) {
    // Phase 3: Generate Markdown
  } else if (context.preferences.isPDF) {
    // Phase 5: Generate PDF
  }
}
```

---

## Testing Phase 1

### Test Case 1: Full Report + HTML
```
User selects: "Full Report" → "Interactive HTML"
Expected: preferences = { reportType: "Full Report", outputFormat: "HTML", ... }
```

### Test Case 2: Short Report + Markdown
```
User selects: "Short Report" → "Markdown"
Expected: preferences = { reportType: "Short Report", outputFormat: "Markdown", ... }
```

### Test Case 3: Invalid Combination
```
User selects: "Short Report"
Format options shown: ["Markdown", "PDF"] ← HTML hidden!
Expected: Cannot select HTML (not available for Short)
```

### Test Case 4: Fallback
```
Preferences not captured (edge case)
Expected: Default to Full Report + Markdown
```

---

## Success Checklist

- [ ] Step 0A captures report type
- [ ] Step 0B conditionally shows format options
- [ ] Both preferences stored in variables
- [ ] Invalid combinations prevented
- [ ] Fallback defaults work
- [ ] Preferences accessible throughout Steps 1–8
- [ ] Conditional logic pattern established
- [ ] Code is commented and clear
- [ ] No changes to Steps 1–6
- [ ] Test cases pass

---

## Code Summary

| Component | Lines | Purpose |
|-----------|-------|---------|
| `captureReportTypePreference()` | ~10 | Step 0A |
| `captureOutputFormatPreference()` | ~15 | Step 0B |
| `createPreferencesObject()` | ~15 | Validate & normalize |
| `phase1_capturePreferences()` | ~10 | Orchestrate Phase 1 |
| **Total Phase 1 Code** | **~50** | Core preference flow |

---

## Effort Breakdown

| Task | Hours | Notes |
|------|-------|-------|
| Implement Functions | 1–1.5 | Write 4 functions |
| Integration | 0.5–1 | Wire into main skill |
| Testing | 0.5–1 | Verify all test cases |
| Documentation | 0.5 | Comments and examples |
| **Total** | **2–4** | Actual development time |

---

## What Phase 1 Does NOT Include

❌ Type-specific report synthesis (Phase 2)  
❌ HTML generation (Phase 4)  
❌ Markdown rendering (Phase 3)  
❌ PDF generation (Phase 5)  
❌ Changes to Steps 1–6 analysis  

---

## Environment Variables

None required for Phase 1. Everything is captured from user input.

---

## Rollback Plan

If Phase 1 breaks, revert to old Step 0:

```javascript
// Fallback to single preference question
const response = await ask_user_input_v0({
  question: "How would you like the report?",
  options: ["Display in chat", "Downloadable .md file", "Both"]
});

// Continue with analysis...
```

---

## Key Insights

✅ Phase 1 is **foundation** — everything else depends on it  
✅ Preferences are **immutable** once captured — use throughout  
✅ Validation happens **immediately** — prevent bad combinations early  
✅ Framework is **extensible** — Phase 2+ can easily add conditional logic  
✅ **Backward compatible** — doesn't break anything  

---

## Next Steps

1. **Implement** Phase 1 functions (this document + PHASE-1-INTEGRATION.md)
2. **Test** all four test cases
3. **Verify** preferences are accessible in Steps 1–8
4. **Move** to Phase 2 (type-specific report synthesis)

---

## Questions?

Refer to:
- **PHASE-1-IMPLEMENTATION.md** — Detailed implementation guide
- **PHASE-1-INTEGRATION.md** — Practical integration patterns
- **SKILL.md** — Full skill specification with preference guidance

---

**Phase 1 Estimated Time**: 2–4 hours  
**Complexity**: Low  
**Impact**: High (foundation for all subsequent phases)

