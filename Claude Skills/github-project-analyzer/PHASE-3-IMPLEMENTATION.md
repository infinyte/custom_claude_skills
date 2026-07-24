# Phase 3 Implementation Guide: Markdown File Output Generation

## Overview

**Phase 3** implements Markdown file generation and output. It takes the report string generated in Phase 2
and writes it to a properly formatted Markdown file with metadata, timestamps, and organizational structure.

**Scope**: Write report to Markdown file with formatting and metadata  
**Effort**: 2–3 hours  
**Risk**: Low (builds on Phase 2 output)  
**Dependency**: Phase 2 (report synthesis)

---

## What Phase 3 Accomplishes

✅ Validate report content from Phase 2  
✅ Add metadata headers and footers  
✅ Format table of contents (Full reports)  
✅ Add timestamps and file information  
✅ Write to outputs directory with proper naming  
✅ Return file metadata (path, size, word count, type)  
✅ Create downloadable artifact  
✅ Ready for Phase 4+ (other formats)  

---

## Phase 3 Architecture

### Input (from Phase 2)
```javascript
context = {
  githubUrl: "...",
  preferences: { reportType, outputFormat, ... },
  report: "Complete markdown report content (1200–2500 words)",
  reportMetadata: {
    type: "Full Report" | "Short Report",
    wordCount: number,
    sectionCount: 7 | 4,
    generatedAt: ISO timestamp
  }
}
```

### Output (to Phase 4+)
```javascript
context = {
  ...previous,
  outputFile: {
    path: "/mnt/user-data/outputs/repo-name-analysis.md",
    filename: "repo-name-analysis.md",
    reportType: "Full Report" | "Short Report",
    size: 45235,  // bytes
    wordCount: 1850,
    sectionCount: 7,
    createdAt: ISO timestamp,
    url: "file:///mnt/user-data/outputs/repo-name-analysis.md"
  }
}
```

---

## Implementation Steps

### Step 1: Validate Report Content

```javascript
/**
 * Validate that the report is ready for output
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
    console.warn("Report appears to be very short (< 500 words)");
  }
  
  return true;
}
```

### Step 2: Generate Filename

```javascript
/**
 * Generate a clean, safe filename from repository name
 */
function generateFilename(repoName, reportType) {
  // Sanitize repo name: lowercase, replace special chars with hyphens
  const sanitized = repoName
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, ''); // Remove leading/trailing hyphens
  
  // Add report type suffix for short reports
  const suffix = reportType === "Short Report" ? "-short" : "";
  
  return `${sanitized}-analysis${suffix}.md`;
}

// Examples:
// "sentiment-analyzer", "Full Report" → "sentiment-analyzer-analysis.md"
// "sentiment-analyzer", "Short Report" → "sentiment-analyzer-analysis-short.md"
// "My-Cool_Repo!", "Full Report" → "my-cool-repo-analysis.md"
```

### Step 3: Add Metadata Headers

```javascript
/**
 * Generate metadata header for the Markdown file
 */
function generateMarkdownHeader(context) {
  const metadata = context.reportMetadata;
  const repoMetadata = context.repoMetadata;
  const now = new Date();
  
  let header = "";
  
  // Front matter (YAML for markdown parsers)
  header += "---\n";
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

### Step 4: Generate Table of Contents (Full Reports Only)

```javascript
/**
 * Generate table of contents for Full reports
 */
function generateTableOfContents(report, isFullReport) {
  if (!isFullReport) {
    return ""; // No TOC for short reports
  }
  
  // Extract section headers from report
  const headers = [];
  const lines = report.split('\n');
  
  for (const line of lines) {
    // Match markdown headers (## Section Name)
    const match = line.match(/^##\s+(.+)$/);
    if (match) {
      const title = match[1].trim();
      // Create anchor link (lowercase, replace spaces with hyphens)
      const anchor = title.toLowerCase().replace(/[^\w\s-]/g, '').replace(/\s+/g, '-');
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

### Step 5: Write to File

```javascript
/**
 * Write the complete markdown file to disk
 */
async function writeMarkdownFile(context, content, filename) {
  const path = require('path');
  const fs = require('fs').promises;
  
  // Output directory
  const outputDir = '/mnt/user-data/outputs';
  const fullPath = path.join(outputDir, filename);
  
  try {
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
    
  } catch (error) {
    console.error(`Failed to write file: ${error.message}`);
    throw error;
  }
}
```

### Step 6: Assemble Complete Markdown File

```javascript
/**
 * Assemble all parts into complete markdown file
 */
function assembleMarkdownFile(context) {
  let complete = "";
  
  // 1. Add metadata header
  complete += generateMarkdownHeader(context);
  
  // 2. Add table of contents (Full reports only)
  const toc = generateTableOfContents(context.report, context.preferences.isFullReport);
  complete += toc;
  
  // 3. Add main report content
  complete += context.report;
  
  // 4. Add metadata footer
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

### Step 7: Main Phase 3 Orchestrator

```javascript
/**
 * Step 8A: Generate Markdown file output
 * 
 * Takes report from Phase 2, writes to Markdown file, returns file metadata
 */
async function step8a_generateMarkdownOutput(context) {
  console.log(`\nStep 8A: Generating Markdown output...\n`);
  
  try {
    // Validate input
    validateReportContent(context);
    
    // Generate filename
    const filename = generateFilename(
      context.repoMetadata.name,
      context.preferences.reportType
    );
    console.log(`  Filename: ${filename}`);
    
    // Assemble complete markdown file
    console.log("  Assembling markdown file...");
    const completeMarkdown = assembleMarkdownFile(context);
    
    // Write to disk
    console.log("  Writing to disk...");
    const fileStats = await writeMarkdownFile(context, completeMarkdown, filename);
    
    // Store output metadata in context
    context.outputFile = {
      type: "Markdown",
      path: fileStats.path,
      filename: fileStats.filename,
      reportType: context.preferences.reportType,
      size: fileStats.size,
      wordCount: context.reportMetadata.wordCount,
      sectionCount: context.reportMetadata.sectionCount,
      createdAt: fileStats.createdAt,
      url: `file://${fileStats.path}`
    };
    
    console.log(`✓ Markdown file generated:`);
    console.log(`  Path: ${context.outputFile.path}`);
    console.log(`  Size: ${(context.outputFile.size / 1024).toFixed(1)} KB`);
    console.log(`  Status: Ready for download/viewing\n`);
    
    return context;
    
  } catch (error) {
    console.error("[ERROR] Markdown output generation failed:", error);
    throw error;
  }
}
```

---

## Integration with Phase 2

Phase 3 is called immediately after Phase 2:

```javascript
async function analyzeGitHubRepository(githubUrl) {
  // Phase 1: Capture preferences
  const preferences = await phase1_capturePreferences();
  const context = createAnalysisContext(githubUrl, preferences);
  
  // Steps 1–6: Analyze
  context.repoMetadata = await step1_resolveRepository(context);
  // ... Steps 2–5 ...
  
  // Phase 2: Synthesize report
  await step7_synthesizeReport(context);
  
  // === PHASE 3: Generate Markdown output ===
  await step8a_generateMarkdownOutput(context);
  // =========================================
  
  // Phases 4–5: Generate other formats (HTML, PDF)
  // (To be implemented in subsequent phases)
  
  return context;
}
```

---

## File Output Format

### Markdown File Structure

```markdown
---
title: "sentiment-analyzer — Project Analysis"
repository: "https://github.com/infinyte/sentiment-analyzer"
report_type: "Full Report"
generated_at: "2026-03-23T15:30:45.123Z"
word_count: 1850
section_count: 7
---

## Table of Contents

- [Project Summary](#project-summary)
- [Features & Capabilities](#features--capabilities)
- [Incomplete Implementations](#incomplete-implementations)
- [Test Coverage Assessment](#test-coverage-assessment)
- [Architectural Overview](#architectural-overview)
- [Editorial Assessment](#editorial-assessment)
- [Quick Reference](#quick-reference)

---

# sentiment-analyzer — Project Analysis

*Generated 03/23/2026 | [View on GitHub](https://github.com/infinyte/sentiment-analyzer)*

---

## Project Summary

[Report content from Phase 2...]

---

## Features & Capabilities

[Report content from Phase 2...]

... (more sections) ...

---

## Document Metadata

```
Generated: 2026-03-23T15:30:45.123Z
Report Type: Full Report
Sections: 7
Words: 1850
Repository: https://github.com/infinyte/sentiment-analyzer
```
```

---

## Implementation Checklist

### Setup
- [ ] Understand context object from Phase 2
- [ ] Plan output directory structure
- [ ] Understand file naming conventions

### Implementation
- [ ] `validateReportContent()` function
- [ ] `generateFilename()` function
- [ ] `generateMarkdownHeader()` function
- [ ] `generateTableOfContents()` function
- [ ] `writeMarkdownFile()` function (using Node.js fs or appropriate API)
- [ ] `assembleMarkdownFile()` function
- [ ] `step8a_generateMarkdownOutput()` main orchestrator

### Testing
- [ ] Full Report markdown file valid
- [ ] Short Report markdown file valid
- [ ] Filenames sanitized correctly
- [ ] File written to correct location
- [ ] Metadata present in file
- [ ] Table of contents accurate
- [ ] Markdown renders correctly

### Integration
- [ ] Called after Phase 2
- [ ] Context object properly updated
- [ ] File path accessible for download
- [ ] Ready for Phase 4 (HTML generation)

---

## What Phase 3 Does NOT Include

Phase 3 focuses ONLY on Markdown file output:

❌ HTML generation (Phase 4)  
❌ PDF generation (Phase 5)  
❌ Web interface/rendering  
❌ Changes to Phases 1–2  
❌ Automatic file uploads  

These will be implemented in Phases 4–5.

---

## Key Insights

✅ Phase 3 is **output formatting** — file writing and structure  
✅ The heavy lifting (content generation) is done in Phase 2  
✅ All logic branching is already done in Phase 1 + 2  
✅ Phase 3 is **simpler** than Phase 1 or 2  
✅ Framework is **minimal** — just file I/O and formatting  

---

## Next Steps

1. **Implement** Phase 3 functions (use PHASE-3-WORKING-EXAMPLE.md)
2. **Test** with Full and Short reports
3. **Verify** Markdown files are valid and renderable
4. **Move** to Phase 4 (HTML generation)

---

**Phase 3 Estimated Time**: 2–3 hours  
**Complexity**: Low (file I/O and string assembly)  
**Impact**: Medium (provides downloadable artifact)  

