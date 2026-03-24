# Phase 1 Implementation Guide: Core Preference Flow (Foundation)

## Overview

**Phase 1** establishes the two-step preference elicitation system that will drive all
downstream decisions in the skill. This is the foundation upon which all subsequent phases depend.

**Scope**: Ask users for report type and format preferences BEFORE any analysis begins.  
**Effort**: 2–4 hours  
**Risk**: Low (minimal code changes, additive only)  
**Dependency**: None (foundation phase)

---

## What Phase 1 Accomplishes

✅ Users see two sequential preference questions (not one)  
✅ Both preferences are captured and stored  
✅ Preferences are available to all downstream steps  
✅ Framework is ready for Phase 2 conditional logic  
✅ Backward compatible (old workflow still works if preferences not obtained)  

---

## Implementation Steps

### Step 1: Understand the Current Workflow

The original skill starts with a single preference question in Step 0:

```javascript
// ORIGINAL Step 0
ask_user_input_v0({
  questions: [
    {
      question: "How would you like the analysis report delivered?",
      type: "single_select",
      options: [
        "Display in chat",
        "Downloadable .md file",
        "Both"
      ]
    }
  ]
})
```

In Phase 1, we replace this with a two-step flow.

---

### Step 2: Implement Two-Step Preference Flow

Replace the original Step 0 with Steps 0A and 0B:

#### **Step 0A: Ask Report Type**

```javascript
// Step 0A: Ask for report type (Full or Short)
ask_user_input_v0({
  questions: [
    {
      question: "What level of detail would you like in your analysis?",
      type: "single_select",
      options: [
        "Full Report (comprehensive, all sections, editorial depth)",
        "Short Report (essentials only, condensed)"
      ]
    }
  ]
})
```

**Key points:**
- This is the FIRST question Claude asks
- User response determines what Step 0B will offer
- Store response in a variable (see Step 3)

#### **Step 0B: Ask Output Format (Conditional)**

```javascript
// Step 0B: Ask for output format based on Step 0A response

// If reportType === "Full Report":
ask_user_input_v0({
  questions: [
    {
      question: "How would you like the full report delivered?",
      type: "single_select",
      options: [
        "Interactive HTML (navigable, best for screen reading)",
        "Comprehensive Markdown (copyable, best for documentation)",
        "PDF (portable, best for sharing/printing)"
      ]
    }
  ]
})

// If reportType === "Short Report":
ask_user_input_v0({
  questions: [
    {
      question: "How would you like the short report delivered?",
      type: "single_select",
      options: [
        "Markdown (copyable, best for documentation)",
        "PDF (portable, best for sharing/printing)"
      ]
    }
  ]
})
```

**Key points:**
- Format options differ based on report type
- Full reports offer HTML + Markdown + PDF
- Short reports offer only Markdown + PDF
- Store response in a variable (see Step 3)

---

### Step 3: Implement Preference Storage

After both preferences are captured, store them as variables for use throughout the workflow:

```javascript
// After both ask_user_input_v0 calls complete, store preferences:

let reportType = null;        // "Full Report" or "Short Report"
let outputFormat = null;      // "HTML", "Markdown", or "PDF"

// Example 1: User selected Full Report + HTML
reportType = "Full Report";
outputFormat = "HTML";

// Example 2: User selected Short Report + Markdown
reportType = "Short Report";
outputFormat = "Markdown";

// These variables are now available for conditional logic in Steps 1–8
```

**Storage strategy:**
- Keep preferences in simple variables/constants
- Prefix with underscore if they're preference flags: `_reportType`, `_outputFormat`
- Make them available to all subsequent functions and steps
- Consider logging them for debugging: `console.log(`Selected: ${reportType}, ${outputFormat}`)`

---

### Step 4: Implement Validation & Fallback

Add safety checks to ensure both preferences are set before proceeding:

```javascript
// Validation function - run before proceeding to Step 1
function validatePreferences(reportType, outputFormat) {
  // Check that both preferences were captured
  if (!reportType || !outputFormat) {
    console.error("Preferences not captured. Defaulting to Full + Markdown.");
    
    // Fallback defaults
    reportType = reportType || "Full Report";
    outputFormat = outputFormat || "Markdown";
  }
  
  // Validate combinations
  if (reportType === "Short Report" && outputFormat === "HTML") {
    console.warn("HTML not available for Short reports. Switching to Markdown.");
    outputFormat = "Markdown";
  }
  
  return { reportType, outputFormat };
}

// Usage:
const { reportType: finalReportType, outputFormat: finalFormat } = 
  validatePreferences(reportType, outputFormat);
```

**Why this matters:**
- Handles edge cases where preferences aren't captured
- Prevents invalid combinations (e.g., Short Report + HTML)
- Graceful degradation if something goes wrong
- Safe fallback to sensible defaults

---

### Step 5: Implement Conditional Logic Framework

Create a pattern for using preferences throughout the workflow. This framework will be
expanded in later phases:

```javascript
// CONDITIONAL LOGIC PATTERN - Use throughout Phases 2–8

// Example 1: In Step 1 (optional - affects verbosity)
if (reportType === "Full Report") {
  // Log verbose progress
  console.log("Full report selected - preparing comprehensive analysis");
} else {
  // Log concise progress
  console.log("Short report selected - focusing on essentials");
}

// Example 2: In Step 7 (synthesis - Phase 2 will expand this)
let report = "";

if (reportType === "Full Report") {
  report += generateFullReportSectionOne();
  report += generateFullReportSectionTwo();
  // ... all 7 sections
} else {
  report += generateShortReportSectionOne();
  report += generateShortReportSectionTwo();
  // ... only 4 sections
}

// Example 3: In Step 8 (output generation - Phase 3-5 will expand this)
let outputFile = null;

if (outputFormat === "HTML") {
  outputFile = generateHTMLReport(report, reportType);
} else if (outputFormat === "Markdown") {
  outputFile = generateMarkdownReport(report, reportType);
} else if (outputFormat === "PDF") {
  outputFile = generatePDFReport(report, reportType);
}
```

**Key pattern:**
- If/else branches on `reportType` for CONTENT decisions
- If/else branches on `outputFormat` for RENDERING decisions
- Keep preferences accessible throughout
- Each phase extends the conditional logic

---

## Implementation Checklist

### Data Capture (Steps 0A–0B)
- [ ] Step 0A calls `ask_user_input_v0` with Full/Short options
- [ ] User response is captured and stored in `reportType` variable
- [ ] Step 0B conditionally presents format options based on `reportType`
- [ ] User response is captured and stored in `outputFormat` variable
- [ ] Both preferences are confirmed before proceeding to Step 1

### Validation
- [ ] Fallback defaults are set if preferences missing
- [ ] Invalid combinations are prevented (Short + HTML)
- [ ] Validation errors are logged for debugging
- [ ] User is informed of any fallback defaults in chat

### Framework Setup
- [ ] Preferences are stored as accessible variables
- [ ] Conditional logic pattern is established for future phases
- [ ] Each conditional branch has a clear purpose (content vs. rendering)
- [ ] Code is commented explaining preference usage

### Integration
- [ ] Original Steps 1–6 are UNCHANGED
- [ ] Step 7 synthesis is ready for Phase 2 expansion
- [ ] Step 8 output generation is ready for Phase 3–5 expansion
- [ ] No breaking changes to existing workflow

---

## Code Implementation Example

Here's a complete Phase 1 implementation showing the preference flow integration:

```javascript
/**
 * PHASE 1: Core Preference Flow Implementation
 * 
 * This function handles Steps 0A and 0B: capturing and storing user preferences
 * for report type and output format. Preferences are then available for use
 * in Steps 1–8.
 */

// ============================================================================
// STEP 0A: Ask Report Type
// ============================================================================

async function stepZeroA_AskReportType() {
  console.log("Step 0A: Asking user for report type preference...");
  
  const response = await ask_user_input_v0({
    questions: [
      {
        question: "What level of detail would you like in your analysis?",
        type: "single_select",
        options: [
          "Full Report (comprehensive, all sections, editorial depth)",
          "Short Report (essentials only, condensed)"
        ]
      }
    ]
  });

  // Extract and normalize the response
  let reportType = null;
  if (response && response[0]) {
    const selection = response[0];
    if (selection.includes("Full")) {
      reportType = "Full Report";
    } else if (selection.includes("Short")) {
      reportType = "Short Report";
    }
  }

  console.log(`Report type selected: ${reportType}`);
  return reportType;
}

// ============================================================================
// STEP 0B: Ask Output Format (Conditional on Step 0A)
// ============================================================================

async function stepZeroB_AskOutputFormat(reportType) {
  console.log(`Step 0B: Asking user for output format (${reportType})...`);
  
  let formatOptions = [];
  
  // Different format options based on report type
  if (reportType === "Full Report") {
    formatOptions = [
      "Interactive HTML (navigable, best for screen reading)",
      "Comprehensive Markdown (copyable, best for documentation)",
      "PDF (portable, best for sharing/printing)"
    ];
  } else if (reportType === "Short Report") {
    formatOptions = [
      "Markdown (copyable, best for documentation)",
      "PDF (portable, best for sharing/printing)"
    ];
  } else {
    // Fallback (shouldn't happen if Step 0A worked)
    console.warn("Report type not set. Defaulting to Full Report options.");
    formatOptions = [
      "Interactive HTML (navigable, best for screen reading)",
      "Comprehensive Markdown (copyable, best for documentation)",
      "PDF (portable, best for sharing/printing)"
    ];
  }

  const response = await ask_user_input_v0({
    questions: [
      {
        question: reportType === "Full Report" 
          ? "How would you like the full report delivered?"
          : "How would you like the short report delivered?",
        type: "single_select",
        options: formatOptions
      }
    ]
  });

  // Extract and normalize the response
  let outputFormat = null;
  if (response && response[0]) {
    const selection = response[0];
    if (selection.includes("HTML")) {
      outputFormat = "HTML";
    } else if (selection.includes("Markdown")) {
      outputFormat = "Markdown";
    } else if (selection.includes("PDF")) {
      outputFormat = "PDF";
    }
  }

  console.log(`Output format selected: ${outputFormat}`);
  return outputFormat;
}

// ============================================================================
// PREFERENCE VALIDATION & STORAGE
// ============================================================================

function validateAndStorePreferences(reportType, outputFormat) {
  console.log("Validating and storing preferences...");
  
  // Validate that both preferences were captured
  if (!reportType || !outputFormat) {
    console.error(
      "One or both preferences were not captured. " +
      "Setting defaults: Full Report, Markdown."
    );
    reportType = reportType || "Full Report";
    outputFormat = outputFormat || "Markdown";
  }

  // Validate combinations
  if (reportType === "Short Report" && outputFormat === "HTML") {
    console.warn(
      "Invalid combination: HTML is not available for Short reports. " +
      "Switching to Markdown."
    );
    outputFormat = "Markdown";
  }

  // Log final preferences
  console.log(`✓ Preferences stored: reportType="${reportType}", outputFormat="${outputFormat}"`);

  // Return preferences object for use in subsequent steps
  return {
    reportType: reportType,
    outputFormat: outputFormat,
    
    // Convenience methods for conditional checks
    isFullReport: () => reportType === "Full Report",
    isShortReport: () => reportType === "Short Report",
    isHTML: () => outputFormat === "HTML",
    isMarkdown: () => outputFormat === "Markdown",
    isPDF: () => outputFormat === "PDF"
  };
}

// ============================================================================
// MAIN WORKFLOW: Steps 0A + 0B + Validation
// ============================================================================

async function executePhaseOne_PreferenceFlow(githubUrl) {
  console.log("=== PHASE 1: CORE PREFERENCE FLOW ===\n");
  
  try {
    // Step 0A: Get report type
    const reportType = await stepZeroA_AskReportType();
    
    // Step 0B: Get output format (conditional on Step 0A)
    const outputFormat = await stepZeroB_AskOutputFormat(reportType);
    
    // Validate and store preferences
    const preferences = validateAndStorePreferences(reportType, outputFormat);
    
    console.log("\n✓ Step 0: Preference elicitation complete\n");
    
    // Return preferences for use in Steps 1–8
    return preferences;
    
  } catch (error) {
    console.error("Error in Phase 1 preference flow:", error);
    
    // Fallback: return default preferences
    return validateAndStorePreferences("Full Report", "Markdown");
  }
}

// ============================================================================
// INTEGRATION: Call Phase 1 at Skill Start
// ============================================================================

async function analyzeGitHubRepository(githubUrl) {
  console.log(`Analyzing repository: ${githubUrl}\n`);
  
  // PHASE 1: Get user preferences (THIS IS NEW - STEP 0)
  const preferences = await executePhaseOne_PreferenceFlow(githubUrl);
  
  // Make preferences available to all downstream steps
  const analysisContext = {
    githubUrl: githubUrl,
    reportType: preferences.reportType,
    outputFormat: preferences.outputFormat,
    isFullReport: preferences.isFullReport(),
    isShortReport: preferences.isShortReport(),
    isHTML: preferences.isHTML(),
    isMarkdown: preferences.isMarkdown(),
    isPDF: preferences.isPDF()
  };
  
  // Steps 1–6: UNCHANGED - analyze repository as before
  console.log("Step 1: Resolving repository...");
  const repoMetadata = await stepOne_ResolveRepository(githubUrl);
  
  console.log("Step 2: Inventorying codebase...");
  const codebaseInventory = await stepTwo_InventoryCodebase(githubUrl);
  
  console.log("Step 3: Deep-reading key artifacts...");
  const artifacts = await stepThree_DeepReadArtifacts(githubUrl);
  
  console.log("Step 4: Assessing test coverage...");
  const testCoverage = await stepFour_AssessTestCoverage(githubUrl);
  
  console.log("Step 5: Identifying incomplete work...");
  const incompleteItems = await stepFive_IdentifyIncompleteWork(githubUrl);
  
  // PHASE 2 ONWARDS (not implemented in Phase 1):
  // Step 7: Synthesize report (type-specific content)
  // Step 8: Generate output (format-specific rendering)
  
  // For Phase 1, just show what was captured:
  console.log("\n=== PHASE 1 COMPLETE ===");
  console.log(`Report Type: ${analysisContext.reportType}`);
  console.log(`Output Format: ${analysisContext.outputFormat}`);
  console.log("\nProceeding to analysis steps 1–6...");
  
  return analysisContext;
}

// ============================================================================
// USAGE EXAMPLE
// ============================================================================

// Call the main function with a GitHub URL:
// const context = await analyzeGitHubRepository("https://github.com/infinyte/sentiment-analyzer");
// 
// Output:
// =========================
// Step 0A: Asking user for report type preference...
// [User sees: Full Report / Short Report options]
// [User selects: Full Report]
// Report type selected: Full Report
//
// Step 0B: Asking user for output format (Full Report)...
// [User sees: HTML / Markdown / PDF options]
// [User selects: HTML]
// Output format selected: HTML
//
// Validating and storing preferences...
// ✓ Preferences stored: reportType="Full Report", outputFormat="HTML"
//
// ✓ Step 0: Preference elicitation complete
//
// Step 1: Resolving repository...
// Step 2: Inventorying codebase...
// ... (Steps 1–6 continue as before)
```

---

## Integration Points with Existing Workflow

### Where Phase 1 Fits

```
ORIGINAL WORKFLOW:
├── Step 0: Ask single preference (Display/Download/Both)
├── Steps 1–6: Analyze repository
├── Step 7: Synthesize full report
└── Step 8: Deliver output

NEW WORKFLOW (Phase 1):
├── Step 0A: Ask report type (Full/Short)
├── Step 0B: Ask output format (conditional)
├── ✓ Store preferences
├── Steps 1–6: Analyze repository (UNCHANGED)
├── Step 7: Synthesize report (PHASE 2 - type-specific)
├── Step 8: Generate output (PHASES 3–5 - format-specific)
└── Deliver with preferences applied
```

### Variables to Pass to Step 1

```javascript
// Create a context object with preferences
const analysisContext = {
  githubUrl: "https://github.com/...",
  reportType: "Full Report",      // or "Short Report"
  outputFormat: "HTML",            // or "Markdown", "PDF"
  
  // Convenience flags for conditionals
  isFullReport: true,              // reportType === "Full Report"
  isShortReport: false,            // reportType === "Short Report"
  isHTML: true,                    // outputFormat === "HTML"
  isMarkdown: false,               // outputFormat === "Markdown"
  isPDF: false,                    // outputFormat === "PDF"
  
  // Store analysis results (populated in Steps 1–6)
  repoMetadata: {...},
  codebaseInventory: {...},
  artifacts: {...},
  testCoverage: {...},
  incompleteItems: [...]
};

// Pass this to each subsequent step
stepOne_ResolveRepository(analysisContext);
stepTwo_InventoryCodebase(analysisContext);
// etc.
```

---

## What Phase 1 Does NOT Include

Phase 1 establishes the foundation only. The following are deferred to later phases:

❌ **Not in Phase 1**: Conditional content synthesis (Section 1, 2, etc.)  
❌ **Not in Phase 1**: HTML generation logic  
❌ **Not in Phase 1**: Markdown rendering  
❌ **Not in Phase 1**: PDF generation  

These will be implemented in Phases 2–5.

---

## Testing Phase 1

### Test Case 1: Full Report + HTML
```
User input:
1. Step 0A → Select "Full Report"
2. Step 0B → Select "Interactive HTML"

Expected:
✓ reportType = "Full Report"
✓ outputFormat = "HTML"
✓ Analysis proceeds with preferences stored
```

### Test Case 2: Short Report + Markdown
```
User input:
1. Step 0A → Select "Short Report"
2. Step 0B → Select "Markdown"

Expected:
✓ reportType = "Short Report"
✓ outputFormat = "Markdown"
✓ Analysis proceeds with preferences stored
```

### Test Case 3: Short Report + HTML (Invalid)
```
User input:
1. Step 0A → Select "Short Report"
2. Step 0B → [HTML option not shown because invalid]

Expected:
✓ Step 0B only shows Markdown + PDF options
✓ Cannot select HTML (not available)
```

### Test Case 4: Preference Fallback
```
Scenario: User preferences not captured (edge case)

Expected:
✓ Default to "Full Report", "Markdown"
✓ Warning logged: "Defaulting to Full Report, Markdown"
✓ Analysis proceeds
```

---

## Success Criteria for Phase 1

- [x] Step 0A presents report type options (Full/Short)
- [x] Step 0B conditionally presents format options
- [x] Both preferences are captured and stored
- [x] Preferences are available to all subsequent steps
- [x] Invalid combinations are prevented
- [x] Fallback defaults are set if preferences missing
- [x] Code is well-commented and structured
- [x] No changes to Steps 1–6 analysis workflow
- [x] Ready for Phase 2 conditional logic expansion

---

## Next Steps (Phase 2)

Once Phase 1 is complete and tested:

1. **Phase 2**: Use preferences to synthesize type-specific report content
   - Section 1, 2, 3, 4, 5, 6, 7 generation based on `reportType`
   - Full vs. Short branches for each section
   - Estimated effort: 6–8 hours

2. **Phases 3–5**: Implement format-specific output rendering
   - Markdown generation (Phase 3, 4–6 hours)
   - HTML generation (Phase 4, 8–12 hours)
   - PDF generation (Phase 5, 6–10 hours)

---

## Summary

**Phase 1 establishes:**

✅ Two-step preference flow  
✅ Conditional format options based on report type  
✅ Preference storage and validation  
✅ Framework for downstream conditional logic  
✅ Zero breaking changes to existing workflow  

**Phase 1 is the foundation** upon which all subsequent phases depend. Once complete,
the skill can ask users exactly what they want before beginning analysis.

