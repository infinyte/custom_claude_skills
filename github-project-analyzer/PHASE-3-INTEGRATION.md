# Phase 3 Integration Guide

## How to Integrate Phase 3 into Your Skill

This guide shows exactly how to integrate Phase 3 Markdown file output generation into the skill execution flow,
building on Phase 1 + 2.

---

## Integration Architecture

### Where Phase 3 Fits

```
SKILL EXECUTION FLOW:

Phase 1: Capture preferences ✓ (DONE)
    ↓
Steps 1–6: Analyze repository ✓ (DONE)
    ↓
Phase 2: Synthesize report ✓ (DONE)
    ↓
← PHASE 3 INTEGRATION POINT ← (YOU ARE HERE)
    ↓
Step 8A: Generate Markdown output (WRITE TO FILE)
    ↓
Phase 4–5: Generate other formats (HTML, PDF)
```

### Context Flow

```javascript
// After Phase 2:
context = {
  githubUrl: "...",
  preferences: { reportType: "Full", outputFormat: "Markdown" },
  report: "Complete markdown report (1200–2500 words)",
  reportMetadata: { type: "Full Report", wordCount: 1850, sectionCount: 7 }
}

// After Phase 3:
context = {
  ...previous,
  outputFile: {
    path: "/mnt/user-data/outputs/repo-name-analysis.md",
    filename: "repo-name-analysis.md",
    size: 45235,
    wordCount: 1850,
    sectionCount: 7,
    createdAt: "2026-03-23T15:30:45.123Z"
  }
}
```

---

## Step 1: Implement Core Functions

### Function 1: Validate Report Content

```javascript
/**
 * Validate that report is ready for output
 */
function validateReportContent(context) {
  if (!context.report || context.report.length === 0) {
    throw new Error("Report content is missing or empty");
  }
  
  if (!context.reportMetadata) {
    throw new Error("Report metadata is missing");
  }
  
  const expectedSections = context.preferences.isFullReport ? 7 : 4;
  if (context.reportMetadata.sectionCount !== expectedSections) {
    console.warn(
      `Expected ${expectedSections} sections but got ${context.reportMetadata.sectionCount}`
    );
  }
  
  if (context.reportMetadata.wordCount < 500) {
    throw new Error("Report is too short (< 500 words)");
  }
  
  return true;
}
```

### Function 2: Generate Filename

```javascript
/**
 * Generate sanitized filename from repository name
 */
function generateFilename(repoName, reportType) {
  // Sanitize: lowercase, replace special chars, remove extra hyphens
  const sanitized = repoName
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
  
  // Add suffix for short reports
  const suffix = reportType === "Short Report" ? "-short" : "";
  
  return `${sanitized}-analysis${suffix}.md`;
}
```

### Function 3: Generate Markdown Header

```javascript
/**
 * Generate YAML frontmatter for Markdown file
 */
function generateMarkdownHeader(context) {
  const metadata = context.reportMetadata;
  const repoMetadata = context.repoMetadata;
  const now = new Date();
  
  let header = "---\n";
  header += `title: "${repoMetadata.name || 'Project'} — Project Analysis"\n`;
  header += `repository: "${context.githubUrl}"\n`;
  header += `report_type: "${metadata.type}"\n`;
  header += `generated_at: "${now.toISOString()}"\n`;
  header += `word_count: ${metadata.wordCount}\n`;
  header += `section_count: ${metadata.sectionCount}\n`;
  header += "---\n\n";
  
  return header;
}
```

### Function 4: Generate Table of Contents

```javascript
/**
 * Generate table of contents from report headers
 * Full reports only (skipped for Short)
 */
function generateTableOfContents(report, isFullReport) {
  if (!isFullReport) {
    return ""; // No TOC for short reports
  }
  
  const headers = [];
  const lines = report.split('\n');
  
  for (const line of lines) {
    // Extract markdown headers (## Section Name)
    const match = line.match(/^##\s+(.+)$/);
    if (match) {
      const title = match[1].trim();
      // Create anchor: lowercase, spaces to hyphens, remove special chars
      const anchor = title
        .toLowerCase()
        .replace(/[^\w\s-]/g, '')
        .replace(/\s+/g, '-');
      headers.push({ title, anchor });
    }
  }
  
  if (headers.length === 0) {
    return "";
  }
  
  let toc = "## Table of Contents\n\n";
  for (const header of headers) {
    toc += `- [${header.title}](#${header.anchor})\n`;
  }
  toc += "\n---\n\n";
  
  return toc;
}
```

### Function 5: Assemble Markdown File

```javascript
/**
 * Assemble all parts into complete Markdown file
 */
function assembleMarkdownFile(context) {
  let complete = "";
  
  // 1. Add header with metadata
  complete += generateMarkdownHeader(context);
  
  // 2. Add table of contents (Full reports only)
  const toc = generateTableOfContents(context.report, context.preferences.isFullReport);
  complete += toc;
  
  // 3. Add main report content
  complete += context.report;
  
  // 4. Add footer with metadata
  complete += "\n\n---\n\n";
  complete += "## Document Metadata\n\n";
  complete += "```\n";
  complete += `Generated: ${new Date().toISOString()}\n`;
  complete += `Report Type: ${context.reportMetadata.type}\n`;
  complete += `Sections: ${context.reportMetadata.sectionCount}\n`;
  complete += `Words: ${context.reportMetadata.wordCount}\n`;
  complete += `Repository: ${context.githubUrl}\n`;
  complete += "```\n";
  
  return complete;
}
```

### Function 6: Write to File

```javascript
/**
 * Write Markdown file to disk
 * Works with both Node.js and browser environments
 */
async function writeMarkdownFile(context, content, filename) {
  try {
    // Check if we're in Node.js environment
    if (typeof require !== 'undefined') {
      const path = require('path');
      const fs = require('fs').promises;
      
      const outputDir = '/mnt/user-data/outputs';
      const fullPath = path.join(outputDir, filename);
      
      // Write file
      await fs.writeFile(fullPath, content, 'utf8');
      
      // Get file stats
      const stats = await fs.stat(fullPath);
      
      return {
        success: true,
        path: fullPath,
        filename: filename,
        size: stats.size,
        createdAt: stats.mtime.toISOString()
      };
    } else {
      // Browser environment: return blob for download
      const blob = new Blob([content], { type: 'text/markdown' });
      
      return {
        success: true,
        path: `blob://${filename}`,
        filename: filename,
        size: blob.size,
        createdAt: new Date().toISOString(),
        blob: blob // For download
      };
    }
  } catch (error) {
    console.error(`Failed to write file: ${error.message}`);
    throw error;
  }
}
```

---

## Step 2: Implement Main Orchestrator

```javascript
/**
 * Step 8A: Generate Markdown file output
 * 
 * Takes report from Phase 2, writes to Markdown file,
 * returns file metadata for next phases
 */
async function step8a_generateMarkdownOutput(context) {
  console.log(`\nStep 8A: Generating Markdown output...\n`);
  
  try {
    // 1. Validate input from Phase 2
    console.log("  Validating report content...");
    validateReportContent(context);
    
    // 2. Generate filename
    const filename = generateFilename(
      context.repoMetadata.name,
      context.preferences.reportType
    );
    console.log(`  Filename: ${filename}`);
    
    // 3. Assemble complete markdown file
    console.log("  Assembling markdown file...");
    const completeMarkdown = assembleMarkdownFile(context);
    
    // 4. Write to disk
    console.log("  Writing to disk...");
    const fileStats = await writeMarkdownFile(context, completeMarkdown, filename);
    
    // 5. Store output metadata in context
    context.outputFile = {
      type: "Markdown",
      path: fileStats.path,
      filename: fileStats.filename,
      reportType: context.preferences.reportType,
      size: fileStats.size,
      wordCount: context.reportMetadata.wordCount,
      sectionCount: context.reportMetadata.sectionCount,
      createdAt: fileStats.createdAt,
      url: fileStats.blob ? undefined : `file://${fileStats.path}`,
      blob: fileStats.blob // For browser downloads
    };
    
    // 6. Log completion
    console.log(`✓ Markdown file generated:`);
    console.log(`  File: ${context.outputFile.filename}`);
    console.log(`  Size: ${(context.outputFile.size / 1024).toFixed(1)} KB`);
    console.log(`  Path: ${context.outputFile.path}\n`);
    
    return context;
    
  } catch (error) {
    console.error("[ERROR] Markdown output generation failed:", error);
    throw error;
  }
}
```

---

## Step 3: Integrate into Main Skill Flow

```javascript
/**
 * Main GitHub Project Analyzer skill execution
 * WITH PHASE 3 INTEGRATION
 */
async function analyzeGitHubRepository(githubUrl) {
  try {
    console.log("\n" + "=".repeat(70));
    console.log("GITHUB PROJECT ANALYZER");
    console.log("=".repeat(70));
    console.log(`Repository: ${githubUrl}\n`);
    
    // ========== PHASE 1: Capture preferences ==========
    const preferences = await phase1_capturePreferences();
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
    
    // ========== PHASE 2: Synthesize report ==========
    console.log("\nStep 7: Synthesizing report...");
    await step7_synthesizeReport(context);
    
    // ========== PHASE 3: Generate Markdown output ==========
    if (context.preferences.outputFormat === "Markdown" || 
        context.preferences.outputFormat !== "HTML") {
      console.log("Step 8A: Generating Markdown output...");
      await step8a_generateMarkdownOutput(context);
    }
    // ===================================================
    
    // ========== FUTURE PHASES ==========
    // Phase 4: Generate HTML (step8b_generateHTMLOutput)
    // Phase 5: Generate PDF (step8c_generatePDFOutput)
    
    console.log("=".repeat(70));
    console.log("✓ ANALYSIS COMPLETE");
    console.log("=".repeat(70) + "\n");
    
    return context;
    
  } catch (error) {
    console.error("[FATAL ERROR] Skill execution failed:", error);
    throw error;
  }
}
```

---

## Step 4: Testing Phase 3

### Test Case 1: Full Report Markdown

```javascript
async function testPhase3_FullReport() {
  console.log("Test: Full Report Markdown Generation\n");
  
  const mockContext = {
    githubUrl: "https://github.com/test/repo",
    repoMetadata: { name: "test-repo" },
    report: "# test-repo — Project Analysis\n\n## Project Summary\n\nTest content...",
    reportMetadata: {
      type: "Full Report",
      wordCount: 1850,
      sectionCount: 7
    },
    preferences: {
      reportType: "Full Report",
      isFullReport: true,
      isShortReport: false
    }
  };
  
  const result = await step8a_generateMarkdownOutput(mockContext);
  
  // Verify
  console.assert(result.outputFile.filename === "test-repo-analysis.md", "Filename correct");
  console.assert(result.outputFile.size > 0, "File has content");
  console.assert(result.outputFile.sectionCount === 7, "7 sections");
  console.assert(result.outputFile.wordCount === 1850, "Word count correct");
  
  console.log("✓ Full Report test PASSED\n");
}
```

### Test Case 2: Short Report Markdown

```javascript
async function testPhase3_ShortReport() {
  console.log("Test: Short Report Markdown Generation\n");
  
  const mockContext = {
    githubUrl: "https://github.com/test/repo",
    repoMetadata: { name: "test-repo" },
    report: "# test-repo — Project Analysis\n\n## Project Summary\n\nShort content...",
    reportMetadata: {
      type: "Short Report",
      wordCount: 750,
      sectionCount: 4
    },
    preferences: {
      reportType: "Short Report",
      isFullReport: false,
      isShortReport: true
    }
  };
  
  const result = await step8a_generateMarkdownOutput(mockContext);
  
  // Verify
  console.assert(result.outputFile.filename === "test-repo-analysis-short.md", "Filename has -short suffix");
  console.assert(result.outputFile.size > 0, "File has content");
  console.assert(result.outputFile.sectionCount === 4, "4 sections");
  console.assert(result.outputFile.wordCount === 750, "Word count correct");
  
  console.log("✓ Short Report test PASSED\n");
}
```

### Run Tests

```javascript
async function runPhase3Tests() {
  console.log("\n" + "=".repeat(70));
  console.log("PHASE 3 TEST SUITE");
  console.log("=".repeat(70) + "\n");
  
  try {
    await testPhase3_FullReport();
    await testPhase3_ShortReport();
    
    console.log("=".repeat(70));
    console.log("✓ ALL PHASE 3 TESTS PASSED");
    console.log("=".repeat(70) + "\n");
  } catch (error) {
    console.error("[ERROR] Test failed:", error);
  }
}
```

---

## Variable Passing Best Practices

### Pass Context Through All Functions

```javascript
// ✅ GOOD: Pass context object
step8a_generateMarkdownOutput(context);

function step8a_generateMarkdownOutput(context) {
  validateReportContent(context);
  const filename = generateFilename(context.repoMetadata.name, context.preferences.reportType);
}

// ✗ BAD: Pass individual parameters
step8a_generateMarkdownOutput(report, metadata, preferences, ...);
```

---

## Debugging Phase 3

### Log File Generation

```javascript
function assembleMarkdownFile(context) {
  console.log("Assembling markdown file...");
  
  let complete = "";
  
  console.log("  Adding header...");
  complete += generateMarkdownHeader(context);
  
  console.log("  Adding TOC...");
  const toc = generateTableOfContents(context.report, context.preferences.isFullReport);
  complete += toc;
  
  console.log("  Adding report content...");
  complete += context.report;
  
  console.log("  Adding footer...");
  complete += "\n\n---\n\n## Document Metadata\n\n...";
  
  console.log(`Total size: ${complete.length} bytes\n`);
  
  return complete;
}
```

### Verify File Contents

```javascript
async function verifyMarkdownFile(filepath) {
  try {
    const fs = require('fs').promises;
    const content = await fs.readFile(filepath, 'utf8');
    
    console.log("\nVerifying Markdown file:");
    console.assert(content.includes("---"), "✓ Has YAML frontmatter");
    console.assert(content.includes("##"), "✓ Has sections");
    console.assert(content.includes("Document Metadata"), "✓ Has footer");
    console.log(`✓ File size: ${content.length} bytes\n`);
    
  } catch (error) {
    console.error("Error reading file:", error);
  }
}
```

---

## Integration Checklist

Before moving to Phase 4, verify:

- [ ] All 6 core functions implemented
- [ ] Main orchestrator (step8a_generateMarkdownOutput) working
- [ ] Full Report markdown file valid
- [ ] Short Report markdown file valid
- [ ] Filenames sanitized correctly
- [ ] Files written to correct location
- [ ] YAML header present
- [ ] TOC present for Full reports
- [ ] TOC absent for Short reports
- [ ] Metadata footer present
- [ ] Markdown renders correctly
- [ ] File paths returned in context
- [ ] Ready for Phase 4 (HTML)

---

## Next Phase (Phase 4)

Once Phase 3 is complete, Phase 4 will:

1. Take the `context.outputFile.path` (Markdown file)
2. Convert to HTML format
3. Add styling and interactivity
4. Write HTML file to outputs directory

Phase 4 can also optionally read the original `context.report` string if direct HTML generation is preferred.

---

## Summary

**Phase 3 integration**:

✅ Implement 6 core functions  
✅ Implement orchestrator  
✅ Integrate into main skill flow  
✅ Test Full Report markdown  
✅ Test Short Report markdown  
✅ Verify files are readable  
✅ Return file metadata in context  

