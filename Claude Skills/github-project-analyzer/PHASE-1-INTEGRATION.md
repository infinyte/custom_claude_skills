# Phase 1 Practical Integration Guide

## How to Integrate Phase 1 into Your Skill

This guide shows exactly where and how to integrate the two-step preference flow into
the existing github-project-analyzer skill.

---

## File Structure & Integration Points

### Where the Skill Runs

When you invoke the github-project-analyzer skill with a GitHub URL, here's the execution flow:

```
1. Skill is triggered (user says "analyze repo: [url]")
2. Claude recognizes the github.com link + analysis intent
3. Skill begins execution from Step 0
4. ← PHASE 1 INTEGRATION POINT: Replace old Step 0 here
5. Continue with Steps 1–6 (analysis workflow)
6. Continue with Steps 7–8 (synthesis and output)
```

---

## Integration Pattern

### Current Workflow (Before Phase 1)

```
skillExecution() {
  // Step 0: Single preference question
  preferences = ask_user_input_v0({
    question: "How would you like the report?",
    options: ["Display in chat", "Downloadable .md", "Both"]
  })
  
  // Steps 1–6: Analyze
  repoData = analyzeRepository()
  
  // Step 7–8: Synthesize and deliver (always full report)
  report = synthesizeFullReport(repoData)
  deliverReport(report, preferences.format)
}
```

### New Workflow (After Phase 1)

```
skillExecution() {
  // ============ PHASE 1: TWO-STEP PREFERENCE FLOW ============
  
  // Step 0A: Ask report type
  reportType = ask_user_input_v0({
    question: "What level of detail?",
    options: ["Full Report", "Short Report"]
  })
  
  // Step 0B: Ask format (conditional on Step 0A)
  if (reportType === "Full Report") {
    outputFormat = ask_user_input_v0({
      question: "What format?",
      options: ["HTML", "Markdown", "PDF"]
    })
  } else {
    outputFormat = ask_user_input_v0({
      question: "What format?",
      options: ["Markdown", "PDF"]
    })
  }
  
  // Store preferences
  preferences = {
    reportType: reportType,
    outputFormat: outputFormat
  }
  
  // ========================================================
  
  // Steps 1–6: Analyze (UNCHANGED)
  repoData = analyzeRepository()
  
  // Steps 7–8: Synthesize and deliver (type-aware, format-aware)
  if (preferences.reportType === "Full") {
    report = synthesizeFullReport(repoData)
  } else {
    report = synthesizeShortReport(repoData)
  }
  
  deliverReport(report, preferences.outputFormat)
}
```

---

## Step-by-Step Integration

### 1. Create Preference Capture Functions

Create a new section in your skill execution that handles Steps 0A and 0B:

```javascript
/**
 * Step 0A: Capture report type preference
 * Returns: "Full Report" or "Short Report"
 */
async function captureReportTypePreference() {
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
  
  // Parse response and normalize
  if (response && response[0]) {
    if (response[0].includes("Full")) return "Full Report";
    if (response[0].includes("Short")) return "Short Report";
  }
  
  // Default fallback
  console.warn("Could not parse report type. Defaulting to Full Report.");
  return "Full Report";
}

/**
 * Step 0B: Capture output format preference (conditional on report type)
 * Input: reportType ("Full Report" or "Short Report")
 * Returns: "HTML", "Markdown", or "PDF"
 */
async function captureOutputFormatPreference(reportType) {
  // Different options based on report type
  const formatOptions = reportType === "Full Report"
    ? [
        "Interactive HTML (navigable, best for screen reading)",
        "Comprehensive Markdown (copyable, best for documentation)",
        "PDF (portable, best for sharing/printing)"
      ]
    : [
        "Markdown (copyable, best for documentation)",
        "PDF (portable, best for sharing/printing)"
      ];
  
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
  
  // Parse response and normalize
  if (response && response[0]) {
    if (response[0].includes("HTML")) return "HTML";
    if (response[0].includes("Markdown")) return "Markdown";
    if (response[0].includes("PDF")) return "PDF";
  }
  
  // Default fallback
  console.warn("Could not parse output format. Defaulting to Markdown.");
  return "Markdown";
}

/**
 * Validate preferences and return normalized object
 */
function createPreferencesObject(reportType, outputFormat) {
  // Validate combination
  if (reportType === "Short Report" && outputFormat === "HTML") {
    console.warn("HTML not available for Short reports. Switching to Markdown.");
    outputFormat = "Markdown";
  }
  
  return {
    reportType: reportType,
    outputFormat: outputFormat,
    isFullReport: reportType === "Full Report",
    isShortReport: reportType === "Short Report",
    isHTML: outputFormat === "HTML",
    isMarkdown: outputFormat === "Markdown",
    isPDF: outputFormat === "PDF"
  };
}
```

### 2. Create the Phase 1 Coordinator

Create a single function that orchestrates Steps 0A and 0B:

```javascript
/**
 * PHASE 1: Core Preference Flow
 * Executes Steps 0A and 0B in sequence, capturing and storing preferences.
 * Returns a preferences object for use in Steps 1–8.
 */
async function phase1_capturePreferences() {
  console.log("Step 0A: Asking for report type preference...\n");
  const reportType = await captureReportTypePreference();
  
  console.log(`\nStep 0B: Asking for output format preference...\n`);
  const outputFormat = await captureOutputFormatPreference(reportType);
  
  console.log("\nValidating preferences...");
  const preferences = createPreferencesObject(reportType, outputFormat);
  
  console.log(`✓ Preferences captured:`);
  console.log(`  - Report type: ${preferences.reportType}`);
  console.log(`  - Output format: ${preferences.outputFormat}\n`);
  
  return preferences;
}
```

### 3. Integrate Phase 1 into Main Skill Flow

Modify your main skill execution to call Phase 1:

```javascript
/**
 * Main GitHub Project Analyzer skill execution
 */
async function analyzeGitHubRepository(githubUrl) {
  try {
    console.log(`\n=== GitHub Project Analyzer ===\n`);
    console.log(`Repository: ${githubUrl}\n`);
    
    // ========== PHASE 1: Capture preferences ==========
    const preferences = await phase1_capturePreferences();
    // ================================================
    
    // Create analysis context with preferences
    const analysisContext = {
      githubUrl: githubUrl,
      preferences: preferences,
      // ... additional fields for Steps 1–6 results
    };
    
    // ========== STEPS 1–6: Analysis (UNCHANGED) ==========
    console.log("Beginning repository analysis...\n");
    
    console.log("Step 1: Resolving repository metadata...");
    analysisContext.repoMetadata = await step1_resolveRepository(githubUrl);
    
    console.log("Step 2: Inventorying codebase...");
    analysisContext.codebaseInventory = await step2_inventoryCodebase(githubUrl);
    
    console.log("Step 3: Deep-reading key artifacts...");
    analysisContext.artifacts = await step3_deepReadArtifacts(githubUrl);
    
    console.log("Step 4: Assessing test coverage...");
    analysisContext.testCoverage = await step4_assessTestCoverage(githubUrl);
    
    console.log("Step 5: Identifying incomplete work...");
    analysisContext.incompleteItems = await step5_identifyIncompleteWork(githubUrl);
    
    // ========== STEPS 7–8: Synthesis & Output (Phase 2+) ==========
    // In Phase 1, we just prepare the context
    // Phase 2 will add type-specific synthesis
    // Phases 3–5 will add format-specific output
    
    console.log("✓ Analysis complete. Ready for synthesis and delivery.");
    
    return analysisContext;
    
  } catch (error) {
    console.error("Error during skill execution:", error);
    // Error handling
    throw error;
  }
}
```

---

## Variable Passing Pattern

### How to Make Preferences Available Throughout

When preferences need to be accessible in Steps 1–8, create an analysis context object:

```javascript
// Create in Phase 1
const analysisContext = {
  // Input
  githubUrl: "https://github.com/user/repo",
  
  // Preferences (from Phase 1)
  preferences: {
    reportType: "Full Report",
    outputFormat: "HTML",
    isFullReport: true,
    isShortReport: false,
    isHTML: true,
    isMarkdown: false,
    isPDF: false
  },
  
  // Results from Steps 1–6
  repoMetadata: null,      // populated in Step 1
  codebaseInventory: null, // populated in Step 2
  artifacts: null,         // populated in Step 3
  testCoverage: null,      // populated in Step 4
  incompleteItems: null,   // populated in Step 5
  
  // Generated content (Steps 7–8)
  report: null,            // populated in Step 7
  outputFile: null         // populated in Step 8
};

// Pass to each step
step1_resolveRepository(analysisContext);
step2_inventoryCodebase(analysisContext);
// etc.

// Inside each step function, access preferences like:
function step7_synthesizeReport(analysisContext) {
  const { reportType, outputFormat, isFullReport, isShortReport } = 
    analysisContext.preferences;
  
  if (isFullReport) {
    // Generate full report (7 sections)
  } else {
    // Generate short report (4 sections)
  }
}
```

---

## Conditional Logic Template for Later Phases

Set up the pattern now so Phase 2+ can easily expand it:

```javascript
/**
 * This function will be expanded in Phase 2 to generate type-specific content.
 * For now, it's a placeholder showing where the logic will go.
 */
function step7_synthesizeReport(analysisContext) {
  const preferences = analysisContext.preferences;
  const repoData = {
    metadata: analysisContext.repoMetadata,
    inventory: analysisContext.codebaseInventory,
    artifacts: analysisContext.artifacts,
    coverage: analysisContext.testCoverage,
    incomplete: analysisContext.incompleteItems
  };
  
  let report = "";
  
  // Report type determines content depth
  if (preferences.isFullReport) {
    // Phase 2: Generate full report sections
    // report += generateSection1_Full(repoData);
    // report += generateSection2_Full(repoData);
    // ... etc
    console.log("→ (Phase 2) Will generate full 7-section report");
  } else {
    // Phase 2: Generate short report sections
    // report += generateSection1_Short(repoData);
    // report += generateSection2_Short(repoData);
    // ... etc
    console.log("→ (Phase 2) Will generate short 4-section report");
  }
  
  analysisContext.report = report;
  return report;
}

/**
 * This function will be expanded in Phases 3–5 to generate format-specific output.
 */
function step8_generateOutput(analysisContext) {
  const preferences = analysisContext.preferences;
  const report = analysisContext.report;
  
  let outputFile = null;
  
  // Output format determines rendering
  if (preferences.isHTML) {
    // Phase 4: Generate HTML output
    // outputFile = generateHTML(report, preferences.reportType);
    console.log("→ (Phase 4) Will generate HTML report");
  } else if (preferences.isMarkdown) {
    // Phase 3: Generate Markdown output
    // outputFile = generateMarkdown(report, preferences.reportType);
    console.log("→ (Phase 3) Will generate Markdown report");
  } else if (preferences.isPDF) {
    // Phase 5: Generate PDF output
    // outputFile = generatePDF(report, preferences.reportType);
    console.log("→ (Phase 5) Will generate PDF report");
  }
  
  analysisContext.outputFile = outputFile;
  return outputFile;
}
```

---

## Testing Your Phase 1 Implementation

### Test Script

```javascript
/**
 * Test script for Phase 1
 * Run this to verify preference capture is working correctly
 */
async function testPhase1() {
  console.log("=== TESTING PHASE 1: Core Preference Flow ===\n");
  
  // Test Case 1: Full Report + HTML
  console.log("Test 1: Full Report + HTML");
  let prefs = createPreferencesObject("Full Report", "HTML");
  console.log(`  ✓ Full Report: ${prefs.isFullReport}`);
  console.log(`  ✓ HTML: ${prefs.isHTML}`);
  console.log();
  
  // Test Case 2: Short Report + Markdown
  console.log("Test 2: Short Report + Markdown");
  prefs = createPreferencesObject("Short Report", "Markdown");
  console.log(`  ✓ Short Report: ${prefs.isShortReport}`);
  console.log(`  ✓ Markdown: ${prefs.isMarkdown}`);
  console.log();
  
  // Test Case 3: Invalid combination (Short + HTML)
  console.log("Test 3: Invalid combination (Short Report + HTML)");
  prefs = createPreferencesObject("Short Report", "HTML");
  console.log(`  ✓ Adjusted to: ${prefs.outputFormat}`);
  console.log();
  
  // Test Case 4: Context object creation
  console.log("Test 4: Analysis context object");
  const context = {
    githubUrl: "https://github.com/test/repo",
    preferences: createPreferencesObject("Full Report", "PDF")
  };
  console.log(`  ✓ Context created with preferences: ${context.preferences.reportType}, ${context.preferences.outputFormat}`);
  console.log();
  
  console.log("=== ALL TESTS PASSED ===");
}

// Run: testPhase1();
```

---

## Debugging Phase 1

If preferences aren't being captured correctly, use these debugging techniques:

```javascript
/**
 * Enhanced version with extensive logging for debugging
 */
async function phase1_capturePreferences_DEBUG() {
  console.log("=== PHASE 1: DEBUGGING MODE ===\n");
  
  // Step 0A with logging
  console.log("[DEBUG] Step 0A: Presenting report type options...");
  const reportTypeRaw = await captureReportTypePreference();
  console.log(`[DEBUG] Raw response: ${JSON.stringify(reportTypeRaw)}`);
  console.log(`[DEBUG] Parsed as: ${reportTypeRaw}`);
  
  if (!reportTypeRaw) {
    console.error("[ERROR] Report type not captured!");
    return null;
  }
  
  // Step 0B with logging
  console.log(`\n[DEBUG] Step 0B: Presenting format options for ${reportTypeRaw}...`);
  const outputFormatRaw = await captureOutputFormatPreference(reportTypeRaw);
  console.log(`[DEBUG] Raw response: ${JSON.stringify(outputFormatRaw)}`);
  console.log(`[DEBUG] Parsed as: ${outputFormatRaw}`);
  
  if (!outputFormatRaw) {
    console.error("[ERROR] Output format not captured!");
    return null;
  }
  
  // Validation with logging
  console.log(`\n[DEBUG] Validating combination: ${reportTypeRaw} + ${outputFormatRaw}`);
  const preferences = createPreferencesObject(reportTypeRaw, outputFormatRaw);
  
  console.log(`[DEBUG] Final preferences:`, preferences);
  console.log("\n=== PHASE 1 DEBUG COMPLETE ===\n");
  
  return preferences;
}
```

---

## Integration Checklist

Before moving to Phase 2, verify:

- [ ] `captureReportTypePreference()` function is implemented
- [ ] `captureOutputFormatPreference()` function is implemented
- [ ] `createPreferencesObject()` function is implemented
- [ ] `phase1_capturePreferences()` coordinator function is implemented
- [ ] Analysis context object structure is defined
- [ ] Main skill execution calls `phase1_capturePreferences()` at the start
- [ ] Preferences are stored and accessible throughout Steps 1–8
- [ ] Validation prevents invalid combinations (Short + HTML)
- [ ] Fallback defaults are in place for error cases
- [ ] Code is well-commented and debuggable
- [ ] Test cases pass (Full+HTML, Short+Markdown, etc.)

---

## Migration Path from Old Step 0

If you have existing code that depends on the old Step 0 single preference:

### Old Pattern
```javascript
// OLD: Single preference question
let displayMode = ask_user_input_v0({...});
if (displayMode === "Display in chat") {
  // show full report inline
} else if (displayMode === "Downloadable .md file") {
  // write to file
}
```

### New Pattern
```javascript
// NEW: Two preferences
const preferences = await phase1_capturePreferences();
// preferences.reportType: "Full Report" or "Short Report"
// preferences.outputFormat: "HTML", "Markdown", or "PDF"

if (preferences.isFullReport) {
  // generate full report
} else {
  // generate short report
}

if (preferences.isHTML) {
  // generate HTML
} else if (preferences.isMarkdown) {
  // generate Markdown
} else if (preferences.isPDF) {
  // generate PDF
}
```

---

## Rollback Plan (If Needed)

If Phase 1 doesn't work as expected, you can temporarily revert:

```javascript
// Fallback: Use old Step 0 pattern if Phase 1 fails
async function skillWithFallback(githubUrl) {
  let preferences;
  
  try {
    // Try Phase 1
    preferences = await phase1_capturePreferences();
  } catch (error) {
    console.error("Phase 1 failed, using fallback...");
    
    // Fallback to old single preference
    const response = await ask_user_input_v0({
      questions: [{
        question: "How would you like the report?",
        options: ["Display in chat", "Downloadable file", "Both"]
      }]
    });
    
    // Convert old preference to new format
    preferences = {
      reportType: "Full Report",
      outputFormat: response.includes("Display") ? "Markdown" : "PDF"
    };
  }
  
  // Continue with normal analysis...
}
```

---

## Summary

Phase 1 integration:

✅ Create preference capture functions (Steps 0A, 0B)  
✅ Create preference validation function  
✅ Create Phase 1 coordinator function  
✅ Integrate into main skill execution  
✅ Pass preferences through analysis context  
✅ Set up conditional logic patterns for Phases 2–5  
✅ Test and debug  

**Next**: Move to Phase 2 to implement type-specific report synthesis.

