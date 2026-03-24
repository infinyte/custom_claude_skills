---
name: github-project-analyzer (Enhanced)
description: >
  Performs a comprehensive analysis of a GitHub repository and produces a structured project
  report with user-selectable output formats. Users can choose between Full (comprehensive with
  HTML/Markdown/PDF options) or Short (condensed with Markdown/PDF options) reports. Full reports
  include all seven sections with detailed editorial analysis; Short reports focus on essentials
  with a concise editorial assessment. Use this skill whenever the user provides a GitHub URL
  and wants a project summary, code review, status report, or "what does this repo do" analysis.
---

# GitHub Project Analyzer (Enhanced)

Produces project reports from any GitHub repository URL with user-selectable scope and format.

---

## Workflow Overview

0. **Ask report type preference** — Use `ask_user_input_v0` for report scope (Full/Short)
1. **Ask output format preference** — Use `ask_user_input_v0` based on selected scope
2. **Resolve the repository** — Parse the URL, fetch top-level metadata via GitHub API
3. **Inventory the codebase** — Walk directory tree, identify languages, frameworks, config files
4. **Deep-read key artifacts** — README, source files, test files, CI configs, dependency manifests
5. **Assess test coverage** — Detect test frameworks, count test files, look for coverage reports/badges
6. **Identify incomplete work** — Scan for TODOs, FIXMEs, stubs, NotImplementedException, placeholder comments
7. **Synthesize the report** — Produce sections based on report type (Full or Short)
8. **Generate output** — Render in chosen format (HTML/Markdown/PDF)

---

## Step 0A — Ask Report Type Preference

**Before making any fetch calls**, use `ask_user_input_v0` to present the first decision point.

```javascript
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

Store the user's selection. Do not proceed to Step 0B until this response is recorded.

---

## Step 0B — Ask Output Format Preference

Based on the report type selected in Step 0A, present the appropriate format options:

### If Full Report Selected:

```javascript
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
```

### If Short Report Selected:

```javascript
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

Wait for the user's response, then store both preferences (report type + format) and proceed to Step 1.
**Do not begin any web fetches until both preferences are recorded.**

---

## Steps 1–6: Analysis Workflow

*(Identical to original skill Steps 1–5; same data collection and analysis)*

---

## Step 7 — Synthesize the Report

Report generation differs by type. Follow the structure and guidance for your selected type below.

---

## FULL REPORT STRUCTURE

A comprehensive, opinionated project report designed for deep evaluation and executive
decision-making. Target length: **1200–2500 words** depending on project size.

All seven sections are included with full depth and candid editorial analysis.

### Section 1: Project Summary (Full)

- **Name**: Repo name + any product/marketing name from README
- **Repository**: Full GitHub URL
- **Primary Language(s)**: From file inventory, sorted by prevalence
- **Framework(s)**: All major detected frameworks
- **License**: From repo metadata (or "Not specified")
- **Last Active**: `updated_at` from API; also note creation date and total age
- **Commit Activity**: Recent commit frequency (e.g., "5–10 per week", "multiple per day", "1–2 per month")
- **Community Signals**: Star count, fork count, contributor count (if available)
- **Current State**: 2–3 paragraph narrative covering:
  - What the project is and the problem it solves
  - Current maturity level (prototype / alpha / beta / stable / maintenance / archived)
  - Development pace and health signals
  - Intended audience or use case
  - Notable dependencies or relationships to other projects

---

### Section 2: Features & Capabilities (Full)

A **detailed, bulleted list** of **confirmed, implemented** features organized into logical
subsystems or domains. For each feature, include:

- Feature name
- Brief description of what it does (1–2 sentences)
- Key technologies or patterns used (if notable)

**Recommended groupings** (adapt to project):
- **Core Functionality**
- **API / Integration Layer**
- **Data Access & Storage**
- **Authentication & Authorization**
- **Configuration & Deployment**
- **Observability & Diagnostics**
- **Developer Experience & Tooling**
- **Security & Compliance Features**

If the project is a library/framework, include:
- **Public API Surface** (major classes, interfaces, entry points)
- **Extension Points** (middleware, plugins, hooks, interceptors)

---

### Section 3: Incomplete Implementations (Full)

A **detailed table** of confirmed incomplete work, sourced from TODOs, FIXMEs, `NotImplementedException`,
stub/placeholder methods, declared ROADMAP items, and architectural gaps identified through code review.

**Format:**

| Area | File/Location | Description | Severity | Impact |
|------|--------------|-------------|----------|--------|
| Auth | `src/Auth/TokenService.cs:42` | Refresh token rotation not implemented | High | Cannot safely extend session lifetimes beyond 1 hour |
| Caching | `src/Services/CacheService.cs:18` | Cache invalidation strategy marked TODO | Medium | Risk of stale data in high-traffic scenarios |
| ... | | | | |

**Severity guide**:
- **High** — Blocks a core use case, critical path, or security concern
- **Medium** — Degrades functionality, required for production readiness, or architectural limitation
- **Low** — Nice-to-have, cosmetic, edge case, or technical debt

**Additional context:**
- Link issues/PRs if available from README or code comments
- If a ROADMAP exists, compare declared roadmap items against actual code state
- Flag any stubbed-out modules that are imported but not implemented

If no incomplete implementations are found, state this explicitly.

---

### Section 4: Test Coverage Assessment (Full)

A comprehensive evaluation covering:

1. **Test Infrastructure**
   - Presence/absence of test projects or test directories
   - Frameworks detected (xUnit, NUnit, Jest, pytest, etc.)
   - Test language vs. main language (e.g., TypeScript tests for JS)
   - CI integration (automated test runs on push/PR?)

2. **Test Scope**
   - Estimated test count (e.g., "127 test methods across 18 test classes")
   - Test categories if discernible: unit, integration, end-to-end, performance
   - Key areas with visible test coverage vs. unverified areas

3. **Coverage Metrics**
   - Is coverage actively measured and reported? (badges, CI artifacts, etc.)
   - If available, cite percentage or coverage metrics from recent runs
   - Note if coverage thresholds are enforced

4. **Maturity Assessment**
   - Rate using: **None** / **Unconfirmed** / **Minimal** / **Partial** / **Good** / **Comprehensive**
   - Provide 2–3 sentence justification

5. **Notable Gaps**
   - Any obvious untested areas visible from code review
   - If critical paths have no test coverage, flag this explicitly
   - Configuration, middleware, or integration layers often undertested

6. **Traversal Transparency**
   - If the directory tree was not fully retrieved (permissions, robots.txt), explicitly
     state which fallback evidence sources were checked and what each confirmed
   - Do NOT declare coverage as "None" based solely on unverifiable tree data

---

### Section 5: Architectural Overview (Full)

A detailed section covering the design and structure of the system. Only include if enough
source is readable to say something meaningful.

**Topics to cover:**
- **Design Pattern(s)**: Layered, clean architecture, hexagonal, event-driven, microservices,
  CQRS, serverless, etc.
- **Dependency Structure**: Major internal modules and how they relate; external dependencies
  and their roles
- **Data Flow**: How data enters, flows through, and exits the system (at a conceptual level)
- **Scalability Characteristics**: Any visible limitations or design decisions that affect scale
- **Key Design Decisions**: Notable architectural choices visible in code (e.g., why use async
  everywhere?, why a custom ORM vs. EF Core?, etc.)
- **Integration Points**: How does this system connect to external systems? (APIs, databases,
  message queues, etc.)

**Format suggestions:**
- Prose narrative (1–2 paragraphs) + ASCII diagram or bullet hierarchy if complex
- Reference actual files/classes to ground the explanation
- Be honest about gaps in understandability (e.g., "The event orchestration layer is not
  immediately clear from available documentation")

---

### Section 6: Editorial Assessment (Full)

This section is **opinionated and candid**. Write in first person and give the author real,
useful feedback — the purpose is evaluation, not diplomacy.

#### A. Overall Quality Rating

Rate on a **1–10 scale** across four dimensions with brief justification (2–3 sentences per):

- **Code Quality**: Readability, naming conventions, structure, consistency, adherence to language
  idioms. Does the code feel maintainable? Are there obvious anti-patterns?
- **Architecture**: Design soundness, separation of concerns, extensibility, testability. Does the
  structure support the project's goals? Would it be easy to add new features?
- **Project Value**: Usefulness to its intended audience, originality, problem-solution fit. Does
  it solve a real problem well?
- **Production Readiness**: Error handling, logging, configuration, security posture, deployment
  story, monitoring hooks. Is this production-ready or prototype-stage?

**Format:**
```
| Dimension | Rating | Justification |
|-----------|--------|---------------|
| Code Quality | 7/10 | Clear naming and consistent style, but some large methods could be broken down |
| ... | ... | ... |
```

#### B. Strengths

What is genuinely well done? List 3–5 concrete, specific strengths. Generic praise ("good work")
is not useful. Instead, cite specific examples:
- "Exception handling is comprehensive and provides context-specific error messages"
- "The CI pipeline enforces code quality gates (linting, tests, coverage thresholds)"
- "The module is loosely coupled and easy to test in isolation"

#### C. Concerns

What would give you pause before using or contributing to this project? Be frank and specific:
- Missing error handling in critical paths
- Weak test coverage in core features
- Heavy reliance on undocumented conventions
- Security vulnerabilities or dangerous patterns
- Undocumented dependencies or assumptions

#### D. Suggested Improvements

Organize into three tiers:

**Quick Wins** (low effort, high impact — hours to days):
- Specific, actionable items with concrete first steps
- Examples: "Add type annotations to the cache layer", "Document the token refresh flow in
  README", "Extract constant magic numbers to named constants"

**Medium-Term Improvements** (days to weeks):
- Specific, actionable items requiring some design work
- Examples: "Refactor the authentication middleware into a strategy pattern to support multiple
  auth providers", "Add integration tests for the HTTP client retry logic"

**Strategic Enhancements** (architectural or feature-level — weeks to months):
- Major structural or capability additions
- Examples: "Implement a plugin architecture for extensibility", "Add async/await support to
  synchronous code paths"

#### E. New Feature Recommendations

3–5 features not currently present that would meaningfully increase the project's value.
For each:
- **What**: Concise feature name and description
- **Why**: User benefit and alignment with project scope
- **How**: 1–2 sentence architectural approach (not implementation detail)

---

### Section 7: Quick Reference (Full)

A compact summary card:

```
Project:             [name]
Repository:          [github URL]
Language(s):         [primary languages]
Framework(s):        [frameworks if applicable]
License:             [license]
Maturity:            [Prototype / Alpha / Beta / Stable / Maintenance / Archived]
Test Coverage:       [rating: None / Minimal / Partial / Good / Comprehensive]
Incomplete Items:    [count of TODOs, FIXMEs, NotImplementedExceptions]
Code Quality:        [rating]/10
Architecture:        [rating]/10
Project Value:       [rating]/10
Production Ready:    [rating]/10
Overall Score:       [average]/10

Status:              [1–2 sentence summary of overall health and readiness]
Recommendation:      [one sentence: "Recommended for [use case]" or "Not recommended because..."]
Next Steps:          [3–5 bullet-pointed suggested first actions if adopting/contributing]
```

---

## SHORT REPORT STRUCTURE

A focused, decision-oriented report designed for quick evaluation. Target length: **500–1000 words**.

Includes Sections 1, 2, 4 (simplified), and a condensed editorial section. Omits detailed
Sections 3, 5, and 7.

### Section 1: Project Summary (Short)

- **Name**: Repo name + product name (if any)
- **Repository**: Full GitHub URL
- **Primary Language(s)**: Top 1–2 languages
- **Framework(s)**: Major frameworks only
- **License**: From repo metadata
- **Last Active**: Updated_at; note if dormant
- **Current State**: 1 paragraph covering: What is it? What problem does it solve? Is it stable?

---

### Section 2: Features & Capabilities (Short)

A **bulleted list** (10–15 items maximum) of core features only. No subsystem grouping needed.
For each: feature name + 1-sentence description.

Keep it scannable. Omit minor features, developer tooling, and secondary capabilities.

---

### Section 3: Test Coverage & Concerns (Short, Combined)

A single, concise paragraph covering:
- Test infrastructure present? (Yes / No / Unconfirmed) + brief framework note
- Coverage maturity (None / Minimal / Partial / Good / Comprehensive) with 1-sentence justification
- 1–2 sentence callout of any critical gaps or concerns (if applicable)

---

### Section 4: Editorial Summary (Short, Condensed)

A **frank, single paragraph** covering:
- Overall quality rating (X/10, averaged across all dimensions)
- Top 1–2 strengths and 1–2 concerns (be specific)
- Single biggest improvement that would increase value

---

### Section 5: Quick Reference (Short)

A compact summary:

```
Project:             [name]
Language:            [primary language]
Maturity:            [Prototype / Alpha / Beta / Stable / Maintenance]
Test Coverage:       [rating]
Overall Score:       [X]/10
Recommendation:      [one sentence]
```

---

## Output Format Generation

### HTML Format (Full Reports Only)

Generate an **interactive, navigable HTML report** with:

**Structure:**
- Fixed sidebar navigation with clickable section links (smooth scroll or tab switching)
- Main content area with full report text
- Section headers with anchor links
- Responsive design (mobile-friendly)
- Dark mode toggle (if feasible within constraints)

**Styling & Components:**
- Use semantic HTML5 (`<section>`, `<article>`, `<nav>`)
- Clean typography: sans-serif headings, readable line-height and font size
- Table styling with alternating row colors for readability
- Code blocks with syntax highlighting (if possible) or monospace styling
- Color scheme: professional (blues, grays, accent colors)
- Print-friendly CSS (hide nav, adjust spacing)

**Key Interactions:**
- Table of contents with deep links to each section
- "Copy to clipboard" buttons for code blocks and metadata cards
- Collapsible sections for Incomplete Implementations and Improvements (if lengthy)
- View all / View less toggles for long lists

**File location:** `/mnt/user-data/outputs/{repo-name}-analysis.html`

---

### Markdown Format (Full & Short)

Generate a **comprehensive, well-formatted Markdown document** with:

**Structure:**
- Clear `##` section headers
- Tables for structured data (Incomplete Implementations, Quality Ratings, etc.)
- Code blocks for file paths, snippets, and commands
- Bulleted and numbered lists for readability
- Blockquotes for important callouts or recommendations

**Conventions:**
- Use `| --- |` tables for multi-column data
- Link GitHub URLs directly (e.g., `[sentiment-analyzer](https://github.com/kmitch2300/sentiment-analyzer)`)
- Use fenced code blocks with language hints (```csharp, ```javascript, etc.)
- Horizontal rules (`---`) to visually separate major sections
- Inline `code` formatting for file names, method names, identifiers

**File location:** `/mnt/user-data/outputs/{repo-name}-analysis.md`

---

### PDF Format (Full & Short)

Generate a **professional, printable PDF report** with:

**Structure:**
- Title page with project name, repository URL, generation date, and high-level summary
- Table of contents with page numbers
- Main report content, paginated logically
- Headers and footers with repo name and page numbers
- Professional margins (1 inch on all sides)

**Styling:**
- Consistent typography (serif font for body, sans-serif for headings)
- Tables with appropriate spacing and shading
- Proper page breaks to avoid orphaned content
- Hyperlinked table of contents and section headers
- Boxed callouts for Quick Reference cards
- Footer with generation metadata (date, analyst note)

**Conversion approach:**
- Use Python `reportlab` or `pypdf` to programmatically build the PDF
- Or: Generate clean Markdown, then use `pandoc` or `weasyprint` to convert to PDF
- Ensure all content is preserved and readable

**File location:** `/mnt/user-data/outputs/{repo-name}-analysis.pdf`

---

## Delivery Rules (Updated)

| Selection | Chat Output | File Output |
|-----------|-------------|------------|
| Full + HTML | One-paragraph executive summary only | `{repo-name}-analysis.html` (interactive HTML) |
| Full + Markdown | One-paragraph executive summary only | `{repo-name}-analysis.md` (comprehensive Markdown) |
| Full + PDF | One-paragraph executive summary only | `{repo-name}-analysis.pdf` (printable PDF) |
| Short + Markdown | Short report inline | `{repo-name}-analysis.md` (short Markdown) |
| Short + PDF | Short report inline | `{repo-name}-analysis.pdf` (short PDF) |

**One-paragraph executive summary (Full reports only when file is primary output):**
Include: project name, primary language, maturity level, overall score, top 1–2 strengths,
and the single most important recommendation. Then present the file download.

---

## File Naming Convention

- Full reports: `{repo-name}-analysis-{format}.{ext}` or `{repo-name}-analysis.{ext}`
  - Examples: `sentiment-analyzer-analysis.html`, `sentiment-analyzer-analysis.md`
- Short reports: `{repo-name}-analysis-short.{ext}`
  - Examples: `sentiment-analyzer-analysis-short.md`, `sentiment-analyzer-analysis-short.pdf`

Where `{repo-name}` is the lowercased repository name from the GitHub URL.

---

## Error Handling

| Situation | Action |
|-----------|--------|
| Repo is private / 404 | Inform user, ask for public URL or access token |
| README is empty or missing | Note in Section 1; flag in editorial as a concern |
| Very small repo (< 5 files) | Complete the report but keep it proportionally brief; note in editorial |
| Monorepo | Focus on the primary/most active module; note the monorepo structure in Section 1 |
| No source code (docs-only, etc.) | Adjust report structure; skip code quality ratings; focus on documentation value |
| Rate limit hit | Use unauthenticated requests where possible; if blocked, report to user |
| Tree traversal blocked | Use fallback checks (CLAUDE.md, README, dependency manifests, CI workflows) before rating coverage |
| PDF generation fails | Fall back to Markdown output; note in chat that PDF generation encountered an issue |

---

## Implementation Notes

### For HTML Generation:
- Use `visualize:show_widget` with clean HTML/CSS for display in chat (preview only)
- Programmatically generate the full HTML file using string templating or a lightweight library
- Ensure CSS is embedded (not external) so the file is self-contained and portable
- Test on multiple viewport sizes

### For Markdown Generation:
- Build as a string with careful attention to table formatting
- Use consistent code fence markers and language hints
- Ensure all URLs are properly formatted as Markdown links
- Test rendering in GitHub markdown preview

### For PDF Generation:
- Option A: Use `reportlab` (Python) to build PDF programmatically
  ```python
  from reportlab.lib.pagesizes import letter
  from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table
  
  doc = SimpleDocTemplate(filename, pagesize=letter)
  story = [...]  # Build content elements
  doc.build(story)
  ```
- Option B: Generate clean Markdown, then pipe to `pandoc`:
  ```bash
  pandoc input.md -o output.pdf \
    --pdf-engine=weasyprint \
    --css=styles.css \
    --variable=geometry:margin=1in
  ```
- Option C: Use browser automation to export from HTML

### Calling Present Files
After generating any output file(s), always call `present_files` with the appropriate file path:

```javascript
present_files({
  filepaths: [
    "/mnt/user-data/outputs/{repo-name}-analysis.html"
  ]
})
```

Only call for files that exist and are ready for download.

---

## Notes for Kurt's Projects

When analyzing repos belonging to Kurt Mitchell (`github.com/kmitch2300` or similar organization
`github.com/infinyte`), apply additional context:

- **Primary stack**: .NET/C#, TypeScript/Node.js, Azure cloud services, Semantic Kernel
- **Architectural patterns**: Weight feedback toward Zero Trust, Clean Architecture, layered
  patterns, DDD, and canonical data models
- **Code conventions**: Flag deviations from Microsoft naming and coding guidelines
- **Integration patterns**: Note alignment or divergence from established patterns (DocFlow, CDM)
- **Development maturity**: Consider project context (side project vs. flagship); adjust editorial
  expectations accordingly
- **Feynman technique preference**: Lead with hole-checking for negative assessments before
  encouraging elements; provide evidence for positive ratings; avoid generic praise

---

## Changes Summary

### What's New:
1. **Two-step preference elicitation**: Report type (Full/Short) followed by format selection
2. **Three output formats**: HTML (interactive, Full only), Markdown, PDF
3. **Two report archetypes**: Full (comprehensive, 7 sections, 1200–2500 words) and Short
   (focused, 4 sections, 500–1000 words)
4. **Flexible content depth**: Sections adjust in detail based on report type
5. **Improved editorial**: Structured ratings with dimensions, actionable improvement tiers
6. **Enhanced HTML experience**: Navigation, interactivity, collapsible sections
7. **Professional PDF**: Title pages, TOC, pagination, styled for print

### Backward Compatibility:
- Full + Markdown is closest to the original "Display in chat" behavior
- All original analysis sections are preserved (just optionally condensed for Short reports)
- Error handling and traversal logic unchanged

