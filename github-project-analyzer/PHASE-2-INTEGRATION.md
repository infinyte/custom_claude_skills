# Phase 2 Integration Guide

## How to Integrate Phase 2 into Your Skill

This guide shows exactly how to integrate Phase 2 report synthesis into the skill execution flow,
building on Phase 1's preference capture.

---

## Integration Architecture

### Where Phase 2 Fits

```
SKILL EXECUTION FLOW:

Phase 1: Capture preferences ✓ (DONE)
    ↓
Steps 1–6: Analyze repository ✓ (DONE)
    ↓
← PHASE 2 INTEGRATION POINT ← (YOU ARE HERE)
    ↓
Step 7: Synthesize report (TYPE-SPECIFIC CONTENT)
    ↓
Phase 3–5: Generate output (format-specific)
```

### Context Flow

```javascript
// After Phase 1 + Steps 1–6:
context = {
  githubUrl: "...",
  preferences: { reportType: "Full", outputFormat: "..." },
  repoMetadata: {...},      // Step 1
  codebaseInventory: {...}, // Step 2
  artifacts: {...},         // Step 3
  testCoverage: {...},      // Step 4
  incompleteItems: [...]    // Step 5
}

// After Phase 2:
context = {
  ...previous,
  report: "Complete markdown report (1200–2500 words)",
  reportMetadata: {
    type: "Full Report",
    wordCount: 1850,
    sectionCount: 7,
    generatedAt: "2026-03-23T..."
  }
}
```

---

## Step 1: Section Function Implementation

### Template for Each Section Function

```javascript
/**
 * Generate Section N: [Section Name]
 * 
 * Full Report: [Description of full content]
 * Short Report: [Description of short content / OMITTED]
 * 
 * @param {Object} context - Analysis context with repository data
 * @returns {string} Markdown section content (or empty string if omitted)
 */
function generateSectionN_SectionName(context) {
  const isFullReport = context.preferences.isFullReport;
  let section = "## Section Name\n\n";
  
  if (isFullReport) {
    // FULL REPORT VERSION
    // Include: detailed data, tables, multiple paragraphs
    section += fullVersionContent;
    
  } else {
    // SHORT REPORT VERSION
    
    // If this section is omitted for Short reports:
    if (sectionOmittedForShort) {
      return ""; // Return empty string
    }
    
    // If included, return condensed version:
    section += shortVersionContent;
  }
  
  return section;
}
```

### Example: Implementing Section 1

```javascript
function generateSection1_ProjectSummary(context) {
  const isFullReport = context.preferences.isFullReport;
  const metadata = context.repoMetadata;
  
  let section = "## Project Summary\n\n";
  
  if (isFullReport) {
    // FULL REPORT: Detailed metadata + 2–3 paragraph narrative
    section += `**Name:** ${metadata.name}\n`;
    section += `**Repository:** ${metadata.htmlUrl}\n`;
    section += `**Primary Language(s):** ${metadata.languages.join(', ')}\n`;
    section += `**Framework(s):** ${metadata.frameworks.join(', ')}\n`;
    section += `**License:** ${metadata.license}\n`;
    section += `**Last Active:** ${new Date(metadata.updatedAt).toLocaleDateString()}\n`;
    section += `**Commit Activity:** ${metadata.commitFrequency}\n`;
    section += `**Community Signals:** ⭐ ${metadata.stars} stars, 🍴 ${metadata.forks} forks\n\n`;
    
    // Narrative (2–3 paragraphs)
    section += generateFullProjectNarrative(context);
    
  } else {
    // SHORT REPORT: Essential metadata + 1 paragraph
    section += `**Name:** ${metadata.name}\n`;
    section += `**Repository:** ${metadata.htmlUrl}\n`;
    section += `**Primary Language:** ${metadata.topLanguage}\n`;
    section += `**Framework:** ${metadata.mainFramework}\n`;
    section += `**License:** ${metadata.license}\n`;
    section += `**Last Active:** ${new Date(metadata.updatedAt).toLocaleDateString()}\n\n`;
    
    // Narrative (1 paragraph)
    section += generateShortProjectNarrative(context);
  }
  
  return section;
}

// Helper: Generate Full Report narrative
function generateFullProjectNarrative(context) {
  const metadata = context.repoMetadata;
  
  let narrative = "";
  narrative += `${metadata.name} is a ${metadata.description}\n\n`;
  narrative += `The project addresses [problem] by providing [solution]. `;
  narrative += `Current maturity level is ${metadata.maturity}, with development pace `;
  narrative += `characterized as ${metadata.developmentPace}.\n\n`;
  narrative += `This is a ${metadata.useCase} project suitable for ${metadata.suitableFor}. `;
  narrative += `Community engagement is ${metadata.communityEngagement}.\n`;
  
  return narrative;
}

// Helper: Generate Short Report narrative
function generateShortProjectNarrative(context) {
  const metadata = context.repoMetadata;
  
  return `${metadata.name} is a ${metadata.description}. ` +
         `Maturity: ${metadata.maturity}. ` +
         `Last active: ${metadata.daysAgo} days ago.\n`;
}
```

---

## Step 2: Implement All Section Functions

Create all 7 section functions using the template above:

```javascript
function generateSection1_ProjectSummary(context) { ... }
function generateSection2_Features(context) { ... }
function generateSection3_IncompleteImplementations(context) { ... }
function generateSection4_TestCoverage(context) { ... }
function generateSection5_Architecture(context) { ... }
function generateSection6_Editorial(context) { ... }
function generateSection7_QuickReference(context) { ... }
```

---

## Step 3: Implement Main Orchestrator Function

```javascript
/**
 * Step 7: Synthesize type-specific report content
 * 
 * Calls all section functions in order and assembles the complete report
 * based on preferences (Full Report = 7 sections, Short Report = 4 sections).
 * 
 * @param {Object} context - Analysis context from Steps 1–6
 * @returns {Promise<Object>} Context with report and reportMetadata added
 */
async function step7_synthesizeReport(context) {
  console.log(`\nStep 7: Synthesizing ${context.preferences.reportType}...\n`);
  
  try {
    const isFullReport = context.preferences.isFullReport;
    const metadata = context.repoMetadata;
    
    // Initialize report with title and header
    let report = "";
    report += `# ${metadata.name} — Project Analysis\n\n`;
    report += `*Generated ${new Date().toLocaleDateString()} | `;
    report += `[View on GitHub](${metadata.htmlUrl})*\n\n`;
    report += "---\n\n";
    
    // Section 1: Project Summary (always included)
    console.log("  Generating Section 1: Project Summary...");
    const section1 = generateSection1_ProjectSummary(context);
    report += section1;
    report += "\n---\n\n";
    
    // Section 2: Features & Capabilities (always included)
    console.log("  Generating Section 2: Features & Capabilities...");
    const section2 = generateSection2_Features(context);
    report += section2;
    report += "\n---\n\n";
    
    // Section 3: Incomplete Implementations (Full only)
    if (isFullReport) {
      console.log("  Generating Section 3: Incomplete Implementations...");
      const section3 = generateSection3_IncompleteImplementations(context);
      if (section3) {
        report += section3;
        report += "---\n\n";
      }
    }
    
    // Section 4: Test Coverage Assessment (always included, different depths)
    console.log("  Generating Section 4: Test Coverage Assessment...");
    const section4 = generateSection4_TestCoverage(context);
    report += section4;
    report += "\n---\n\n";
    
    // Section 5: Architectural Overview (Full only)
    if (isFullReport) {
      console.log("  Generating Section 5: Architectural Overview...");
      const section5 = generateSection5_Architecture(context);
      if (section5) {
        report += section5;
        report += "\n---\n\n";
      }
    }
    
    // Section 6: Editorial Assessment (always included, different depths)
    console.log("  Generating Section 6: Editorial Assessment...");
    const section6 = generateSection6_Editorial(context);
    report += section6;
    report += "\n---\n\n";
    
    // Section 7: Quick Reference (always included, different depths)
    console.log("  Generating Section 7: Quick Reference...");
    const section7 = generateSection7_QuickReference(context);
    report += section7;
    
    // Calculate statistics
    const wordCount = report.split(/\s+/).length;
    const sectionCount = isFullReport ? 7 : 4;
    
    // Store report and metadata in context
    context.report = report;
    context.reportMetadata = {
      type: context.preferences.reportType,
      wordCount: wordCount,
      sectionCount: sectionCount,
      generatedAt: new Date().toISOString()
    };
    
    console.log(`✓ Report synthesized:`);
    console.log(`  Type: ${context.reportMetadata.type}`);
    console.log(`  Sections: ${context.reportMetadata.sectionCount}`);
    console.log(`  Words: ${context.reportMetadata.wordCount}`);
    console.log(`  Status: Ready for Phase 3+ output generation\n`);
    
    return context;
    
  } catch (error) {
    console.error("[ERROR] Report synthesis failed:", error);
    throw error;
  }
}
```

---

## Step 4: Integrate into Main Skill Flow

Modify your main skill execution to call Phase 2:

```javascript
/**
 * Main GitHub Project Analyzer skill execution
 * WITH PHASE 2 INTEGRATION
 */
async function analyzeGitHubRepository(githubUrl) {
  try {
    console.log("\n" + "=".repeat(70));
    console.log("GITHUB PROJECT ANALYZER");
    console.log("=".repeat(70));
    console.log(`Repository: ${githubUrl}\n`);
    
    // ========== PHASE 1: Capture preferences ==========
    const preferences = await phase1_capturePreferences();
    // =================================================
    
    // Create analysis context
    const context = createAnalysisContext(githubUrl, preferences);
    
    // ========== STEPS 1–6: Analysis (UNCHANGED) ==========
    console.log("Beginning repository analysis...\n");
    
    console.log("Step 1: Resolving repository metadata...");
    context.repoMetadata = await step1_resolveRepository(context);
    
    console.log("Step 2: Inventorying codebase...");
    context.codebaseInventory = await step2_inventoryCodebase(context);
    
    console.log("Step 3: Deep-reading key artifacts...");
    context.artifacts = await step3_deepReadArtifacts(context);
    
    console.log("Step 4: Assessing test coverage...");
    context.testCoverage = await step4_assessTestCoverage(context);
    
    console.log("Step 5: Identifying incomplete work...");
    context.incompleteItems = await step5_identifyIncompleteWork(context);
    
    // ========== PHASE 2: Synthesize type-specific report ==========
    await step7_synthesizeReport(context);
    // ==============================================================
    
    // ========== STEPS 8+: Output generation (Phases 3–5) ==========
    // (To be implemented in subsequent phases)
    // phase3_generateMarkdown(context);
    // phase4_generateHTML(context);
    // phase5_generatePDF(context);
    console.log("→ Ready for Phase 3+ (output generation)\n");
    // ==============================================================
    
    return context;
    
  } catch (error) {
    console.error("[FATAL ERROR] Skill execution failed:", error);
    throw error;
  }
}
```

---

## Step 5: Data Preparation

Ensure the context object has all required data from Steps 1–6:

```javascript
/**
 * Verify context has all data needed by Phase 2
 */
function validateContextForPhase2(context) {
  const required = [
    'repoMetadata',
    'codebaseInventory',
    'artifacts',
    'testCoverage',
    'incompleteItems'
  ];
  
  for (const field of required) {
    if (!context[field]) {
      console.warn(`[WARN] Context missing: ${field}`);
      return false;
    }
  }
  
  console.log("✓ Context has all required data for Phase 2\n");
  return true;
}

// Usage:
if (validateContextForPhase2(context)) {
  await step7_synthesizeReport(context);
}
```

---

## Testing Phase 2

### Test Case 1: Full Report Generation

```javascript
async function testPhase2_FullReport() {
  console.log("Test: Full Report Generation\n");
  
  // Create mock context
  const context = {
    preferences: {
      reportType: "Full Report",
      isFullReport: true,
      isShortReport: false
    },
    repoMetadata: {
      name: "test-repo",
      htmlUrl: "https://github.com/test/repo",
      languages: ["JavaScript", "TypeScript"],
      frameworks: ["React", "Express"],
      license: "MIT",
      updatedAt: new Date().toISOString(),
      commitFrequency: "Regular",
      stars: 150,
      forks: 25,
      description: "Test project for Phase 2"
    },
    codebaseInventory: {
      detectedFeatures: [
        { name: "Feature 1", description: "Test feature", subsystem: "Core" },
        { name: "Feature 2", description: "Test feature", subsystem: "API" }
      ]
    },
    artifacts: {
      architecture: {
        patterns: "MVC pattern",
        dependencies: "Express, React",
        dataFlow: "Request → Service → Response",
        scalability: "Horizontally scalable",
        decisions: "Using async/await",
        integrations: "REST API"
      },
      editorial: {
        codeQuality: 7,
        architecture: 8,
        projectValue: 7,
        productionReadiness: 6,
        strengths: ["Well documented", "Good architecture"],
        concerns: ["Limited test coverage"],
        quickWins: ["Add more tests"],
        mediumTerm: ["Refactor utilities"],
        strategic: ["Scale infrastructure"]
      }
    },
    testCoverage: {
      present: true,
      framework: "Jest",
      rating: "Good",
      infrastructureDetails: "Jest + GitHub Actions",
      scopeDetails: "Unit and integration tests",
      metricsDetails: "85% coverage",
      justification: "Comprehensive coverage"
    },
    incompleteItems: [
      {
        area: "Auth",
        file: "src/auth.js",
        description: "OAuth2 not implemented",
        severity: "High",
        impact: "Cannot do SSO"
      }
    ]
  };
  
  // Call Phase 2
  const result = await step7_synthesizeReport(context);
  
  // Verify
  console.assert(result.report.includes("# test-repo"), "Title present");
  console.assert(result.report.includes("## Project Summary"), "Section 1 present");
  console.assert(result.report.includes("## Features"), "Section 2 present");
  console.assert(result.report.includes("## Incomplete"), "Section 3 present (Full only)");
  console.assert(result.report.includes("## Test Coverage"), "Section 4 present");
  console.assert(result.report.includes("## Architectural"), "Section 5 present (Full only)");
  console.assert(result.report.includes("## Editorial"), "Section 6 present");
  console.assert(result.report.includes("## Quick Reference"), "Section 7 present");
  console.assert(result.reportMetadata.sectionCount === 7, "7 sections for Full");
  console.assert(result.reportMetadata.wordCount > 1200, "Word count >= 1200");
  
  console.log("✓ Full Report test PASSED\n");
}
```

### Test Case 2: Short Report Generation

```javascript
async function testPhase2_ShortReport() {
  console.log("Test: Short Report Generation\n");
  
  const context = {...sameAsAbove};
  context.preferences.reportType = "Short Report";
  context.preferences.isFullReport = false;
  context.preferences.isShortReport = true;
  
  const result = await step7_synthesizeReport(context);
  
  // Verify
  console.assert(result.report.includes("# test-repo"), "Title present");
  console.assert(result.report.includes("## Project Summary"), "Section 1 present");
  console.assert(result.report.includes("## Features"), "Section 2 present");
  console.assert(!result.report.includes("## Incomplete"), "Section 3 OMITTED");
  console.assert(result.report.includes("## Test Coverage"), "Section 4 present");
  console.assert(!result.report.includes("## Architectural"), "Section 5 OMITTED");
  console.assert(result.report.includes("## Editorial"), "Section 6 present");
  console.assert(result.report.includes("## Quick Reference"), "Section 7 present");
  console.assert(result.reportMetadata.sectionCount === 4, "4 sections for Short");
  console.assert(
    result.reportMetadata.wordCount >= 500 && result.reportMetadata.wordCount <= 1000,
    "Word count 500–1000"
  );
  
  console.log("✓ Short Report test PASSED\n");
}
```

### Run Tests

```javascript
// Run both test cases
async function runPhase2Tests() {
  await testPhase2_FullReport();
  await testPhase2_ShortReport();
  console.log("=== ALL PHASE 2 TESTS PASSED ===\n");
}

runPhase2Tests();
```

---

## Variable Passing Best Practices

### Pass Context Through All Functions

```javascript
// ✅ GOOD: Pass context object
step7_synthesizeReport(context);

function step7_synthesizeReport(context) {
  // Can access: context.repoMetadata, context.preferences, etc.
  generateSection1_ProjectSummary(context);
}

// ✗ BAD: Pass individual parameters
step7_synthesizeReport(repoMetadata, preferences, codebase, ...);
```

### Access Preferences Consistently

```javascript
// ✅ GOOD: Access from context
const isFullReport = context.preferences.isFullReport;

// ✗ BAD: Pass as separate parameter
generateSection1(context, isFullReport); // Redundant

// ✓ GOOD: Use convenience flags
if (context.preferences.isFullReport) { ... }
if (context.preferences.isHTML) { ... } // For Phase 3+
```

---

## Debugging Phase 2

### Log Section Generation

```javascript
function generateSectionN(context) {
  console.log(`Generating Section N for ${context.preferences.reportType}...`);
  let section = "## Title\n\n";
  
  if (context.preferences.isFullReport) {
    console.log("  → Full version (detailed)");
    section += "...";
  } else {
    console.log("  → Short version (condensed)");
    section += "...";
  }
  
  const wordCount = section.split(/\s+/).length;
  console.log(`  Words: ${wordCount}\n`);
  
  return section;
}
```

### Verify Report Structure

```javascript
function verifyReportStructure(report, reportType) {
  console.log(`\nVerifying ${reportType} Report Structure:\n`);
  
  const sections = {
    "## Project Summary": false,
    "## Features": false,
    "## Incomplete": reportType === "Full Report",
    "## Test Coverage": false,
    "## Architectural": reportType === "Full Report",
    "## Editorial": false,
    "## Quick Reference": false
  };
  
  for (const [section, required] of Object.entries(sections)) {
    const present = report.includes(section);
    const status = present ? "✓" : "✗";
    const expected = required ? "expected" : "expected";
    console.log(`${status} ${section} (${expected})`);
  }
}
```

---

## Rollback to Phase 1

If Phase 2 doesn't work, you can temporarily skip it:

```javascript
async function analyzeGitHubRepository_WithFallback(githubUrl) {
  // ... Phase 1 + Steps 1–6 ...
  
  try {
    // Try Phase 2
    await step7_synthesizeReport(context);
  } catch (error) {
    console.error("Phase 2 failed, skipping report generation");
    // Report generation skipped - can still do output
    context.report = "Report generation skipped due to error";
  }
  
  return context;
}
```

---

## Integration Checklist

Before moving to Phase 3, verify:

- [ ] All 7 section functions implemented
- [ ] `step7_synthesizeReport()` orchestrator implemented
- [ ] Full Report generates 7 sections
- [ ] Short Report generates 4 sections
- [ ] Word counts match targets (Full: 1200–2500, Short: 500–1000)
- [ ] Sections 3 & 5 omitted for Short reports
- [ ] All sections properly formatted as Markdown
- [ ] Test cases pass (Full + Short)
- [ ] Works with real GitHub repository data
- [ ] Integration with Phase 1 works
- [ ] Context object properly populated
- [ ] Ready for Phase 3 (Markdown file output)

---

## Next Phase (Phase 3)

Once Phase 2 is complete, Phase 3 will:

1. Take the report string from context.report
2. Format it based on output preferences
3. Write to file or return for display
4. Handle Markdown rendering

Phase 3 will be shorter (~2–3 hours) since content is already generated.

---

## Summary

**Phase 2 integration**:

✅ Implement all 7 section functions  
✅ Implement orchestrator (step7_synthesizeReport)  
✅ Integrate into main skill flow (after Steps 1–6)  
✅ Test Full Report (7 sections, 1200–2500 words)  
✅ Test Short Report (4 sections, 500–1000 words)  
✅ Pass context through all functions  
✅ Use convenience flags for conditionals  
✅ Return empty string for omitted sections  

