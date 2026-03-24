# Phase 3 Quick Reference Card

## Phase 3: Markdown File Output Generation

**Scope**: Write report to Markdown file with formatting and metadata  
**Effort**: 2–3 hours  
**Risk**: Low (simple file I/O)  
**Outcome**: Downloadable Markdown file ready for viewing/sharing

---

## What Phase 3 Does

```
INPUT (from Phase 2):
  context.report = "Complete markdown report (1200–2500 words)"
  context.reportMetadata = { type, wordCount, sectionCount }

PROCESS:
  1. Validate report content
  2. Generate sanitized filename
  3. Add metadata headers/footers
  4. Generate table of contents (Full reports only)
  5. Assemble complete file
  6. Write to /mnt/user-data/outputs/
  7. Return file metadata

OUTPUT (to Phase 4+):
  context.outputFile = {
    path, filename, size, wordCount,
    sectionCount, createdAt, url
  }
```

---

## The 7 Functions

### 1. Validate Report Content
```javascript
function validateReportContent(context)
```
Check that report exists, has proper metadata, expected section count

### 2. Generate Filename
```javascript
function generateFilename(repoName, reportType)
```
Sanitize repo name + add suffix for short reports
- "sentiment-analyzer", "Full" → "sentiment-analyzer-analysis.md"
- "sentiment-analyzer", "Short" → "sentiment-analyzer-analysis-short.md"

### 3. Generate Markdown Header
```javascript
function generateMarkdownHeader(context)
```
Add YAML frontmatter with metadata
```yaml
---
title: "Project — Analysis"
report_type: "Full Report"
word_count: 1850
section_count: 7
---
```

### 4. Generate Table of Contents
```javascript
function generateTableOfContents(report, isFullReport)
```
Extract headers from report, create TOC with anchors
Full reports only (skipped for Short reports)

### 5. Write to File
```javascript
async function writeMarkdownFile(context, content, filename)
```
Write content to `/mnt/user-data/outputs/filename`
Return file stats (path, size, timestamp)

### 6. Assemble Markdown File
```javascript
function assembleMarkdownFile(context)
```
Combine header + TOC + report + footer into complete file

### 7. Main Orchestrator
```javascript
async function step8a_generateMarkdownOutput(context)
```
Call all above functions, write file, return context with outputFile

---

## File Structure

### Output Path
```
/mnt/user-data/outputs/[repo-name]-analysis.md
/mnt/user-data/outputs/[repo-name]-analysis-short.md  (if Short Report)
```

### File Content Structure
```
[YAML Frontmatter]
---
title: "..."
repository: "..."
report_type: "Full Report"
word_count: 1850
section_count: 7
---

[Table of Contents (Full only)]
## Table of Contents
- [Project Summary](#project-summary)
- [Features](#features--capabilities)
...

---

[Report Content from Phase 2]
# sentiment-analyzer — Project Analysis

## Project Summary
...

---

[Metadata Footer]
## Document Metadata

```
Generated: 2026-03-23T...
Report Type: Full Report
Words: 1850
```
```

---

## Key Implementation Pattern

```javascript
async function step8a_generateMarkdownOutput(context) {
  // 1. Validate input from Phase 2
  validateReportContent(context);
  
  // 2. Generate filename
  const filename = generateFilename(
    context.repoMetadata.name,
    context.preferences.reportType
  );
  
  // 3. Assemble complete file
  const markdown = assembleMarkdownFile(context);
  
  // 4. Write to disk
  const fileStats = await writeMarkdownFile(context, markdown, filename);
  
  // 5. Store output metadata
  context.outputFile = {
    path: fileStats.path,
    filename: fileStats.filename,
    size: fileStats.size,
    // ... more fields ...
  };
  
  return context;
}
```

---

## Data Available

```javascript
context = {
  repoMetadata: {
    name,                    // "sentiment-analyzer"
    htmlUrl,                 // "https://github.com/..."
    // ... other fields ...
  },
  report: "Complete markdown report string (1200–2500 words)",
  reportMetadata: {
    type: "Full Report" | "Short Report",
    wordCount: number,
    sectionCount: 7 | 4,
    generatedAt: ISO timestamp
  },
  preferences: {
    isFullReport: boolean,
    isShortReport: boolean,
    // ... other preferences ...
  }
}
```

---

## Filename Sanitization

| Input | Output |
|-------|--------|
| "sentiment-analyzer" | "sentiment-analyzer-analysis.md" |
| "My-Cool_Repo!" | "my-cool-repo-analysis.md" |
| "UPPERCASE" | "uppercase-analysis.md" |
| "Special@#$Chars" | "special-chars-analysis.md" |

**Rule**: Lowercase, replace non-alphanumeric with hyphens, remove leading/trailing hyphens

---

## Markdown Output Format

### Full Report File
```
[Header]
---
title: "..."
report_type: "Full Report"
...
---

[TOC]
## Table of Contents
- [Section 1](#section-1)
...

[Content from Phase 2]
[All 7 sections]

[Footer]
## Document Metadata
```
Generated: ...
Report Type: Full Report
Sections: 7
Words: 1850
```
```

### Short Report File
```
[Header]
---
title: "..."
report_type: "Short Report"
...
---

[NO TOC - skipped for Short]

[Content from Phase 2]
[Only 4 sections: 1, 2, 4, 6, 7]

[Footer]
## Document Metadata
```
Generated: ...
Report Type: Short Report
Sections: 4
Words: 750
```
```

---

## Integration with Phase 2

```javascript
// After Phase 2:
context = await step7_synthesizeReport(context);
// Now context has:
//   - context.report: markdown string
//   - context.reportMetadata: type, wordCount, sectionCount

// Phase 3 (NEW):
context = await step8a_generateMarkdownOutput(context);
// Now context has:
//   - context.outputFile: { path, filename, size, createdAt }
```

---

## Testing & Validation

### Test Case 1: Full Report File
```javascript
const context = {
  repoMetadata: { name: "test-repo" },
  report: "Complete markdown report (1200+ words)",
  reportMetadata: { type: "Full Report", wordCount: 1850, sectionCount: 7 },
  preferences: { isFullReport: true }
};

const result = await step8a_generateMarkdownOutput(context);

// Verify:
✓ result.outputFile.path = "/.../test-repo-analysis.md"
✓ result.outputFile.filename = "test-repo-analysis.md"
✓ File contains YAML header
✓ File contains Table of Contents
✓ File contains all report content
✓ File contains metadata footer
```

### Test Case 2: Short Report File
```javascript
const context = {
  repoMetadata: { name: "test-repo" },
  report: "Complete markdown report (700 words)",
  reportMetadata: { type: "Short Report", wordCount: 720, sectionCount: 4 },
  preferences: { isShortReport: true }
};

const result = await step8a_generateMarkdownOutput(context);

// Verify:
✓ result.outputFile.path = "/.../test-repo-analysis-short.md"
✓ result.outputFile.filename = "test-repo-analysis-short.md"
✓ File contains YAML header
✓ File does NOT contain Table of Contents
✓ File contains all report content
✓ File contains metadata footer
```

---

## Validation Checklist

- [ ] Report content exists and is not empty
- [ ] Report metadata is present and correct
- [ ] Filename is properly sanitized
- [ ] Output directory exists and is writable
- [ ] File successfully written to disk
- [ ] File contains YAML frontmatter
- [ ] File contains TOC (Full reports only)
- [ ] File contains complete report
- [ ] File contains metadata footer
- [ ] File is valid Markdown

---

## Output Structure

### Return Object
```javascript
context.outputFile = {
  type: "Markdown",                         // Format type
  path: "/mnt/user-data/outputs/...",      // Full file path
  filename: "sentiment-analyzer-analysis.md", // Just filename
  reportType: "Full Report" | "Short Report", // Report type
  size: 45235,                              // File size in bytes
  wordCount: 1850,                          // Word count
  sectionCount: 7,                          // Section count
  createdAt: "2026-03-23T15:30:45.123Z",   // ISO timestamp
  url: "file:///mnt/user-data/outputs/..." // File URL
}
```

---

## Error Handling

| Error | Response |
|-------|----------|
| Missing report | Throw error, stop processing |
| Missing metadata | Throw error, stop processing |
| Invalid filename | Throw error before writing |
| Write permission denied | Throw error, provide path info |
| Disk full | Throw error, suggest cleanup |

---

## Word Count Targets

| Report Type | Target | Range | Output |
|-------------|--------|-------|--------|
| Full Report | 1800 | 1200–2500 | .md file |
| Short Report | 750 | 500–1000 | -short.md file |

---

## Code Summary

| Component | Lines | Purpose |
|-----------|-------|---------|
| validateReportContent() | 20–25 | Input validation |
| generateFilename() | 10–15 | Filename generation |
| generateMarkdownHeader() | 15–20 | YAML frontmatter |
| generateTableOfContents() | 20–25 | TOC generation |
| writeMarkdownFile() | 20–25 | File I/O |
| assembleMarkdownFile() | 15–20 | File assembly |
| step8a_generateMarkdownOutput() | 30–40 | Orchestrator |
| **Total Phase 3 Code** | **130–170** | Core output generation |

---

## Integration Points

```
Phase 2 generates:       ← context.report (string)
                         ← context.reportMetadata (object)

Phase 3 generates:       → context.outputFile (object)
                         → Markdown file on disk

Phase 4 uses:            ← context.outputFile.path (for HTML)
Phase 5 uses:            ← context.report (for PDF)
```

---

## What Phase 3 Does NOT Include

❌ HTML generation (Phase 4)  
❌ PDF generation (Phase 5)  
❌ Web interface  
❌ File uploads  
❌ Automatic cleanup  
❌ Version control  

---

## Success Criteria

Phase 3 is complete when:

- [x] File validation working
- [x] Filename sanitization working
- [x] YAML header generation working
- [x] Table of contents generation (Full only)
- [x] File written to disk successfully
- [x] Metadata footer added
- [x] Full Report file valid (7 sections)
- [x] Short Report file valid (4 sections)
- [x] File paths returned in context
- [x] Ready for Phase 4 (HTML)

---

## Next Steps

1. **Implement** Phase 3 functions
2. **Test** with Full and Short reports
3. **Verify** Markdown files render correctly
4. **Move** to Phase 4 (HTML generation)

---

**Phase 3 Estimated Time**: 2–3 hours  
**Complexity**: Low  
**Impact**: Output artifact generated  

