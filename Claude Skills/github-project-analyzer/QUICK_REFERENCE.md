# GitHub Project Analyzer — Quick Reference Guide

A one-page reference for executing comprehensive GitHub repository analysis. Print this or keep it open while analyzing projects.

---

## Execution Checklist

### Phase 1: Validate & Setup (5 min)
- [ ] Parse GitHub URL (owner/repo format)
- [ ] Fetch repo metadata from API
- [ ] Fetch file tree (recursive)
- [ ] Check for 404/403/401 errors; handle if needed

### Phase 2: Fetch Priority Files (10–15 min)
**Tier 1 (Always)**
- [ ] README.md
- [ ] Workflows (.github/workflows/*.yml)
- [ ] package.json OR *.csproj OR requirements.txt
- [ ] src/Program.cs OR equivalent entry point

**Tier 2 (If present)**
- [ ] CHANGELOG.md / ROADMAP.md
- [ ] appsettings.json / .env.example
- [ ] Dockerfile / docker-compose.yml
- [ ] Main test project / jest.config.js / pytest.ini

### Phase 3: Pattern Analysis (5–10 min)
- [ ] Scan source files for incomplete markers (TODO, FIXME, NotImplementedException)
- [ ] Identify test frameworks and coverage configuration
- [ ] Tally file extensions to identify primary languages
- [ ] Detect frameworks from dependencies

### Phase 4: Synthesize Report (15–20 min)
- [ ] Write Section 1: Project Summary (metadata + 3 paragraphs)
- [ ] Write Section 2: Features & Capabilities (8–15 items, organized)
- [ ] Write Section 3: Incomplete Implementations (table or list)
- [ ] Write Section 4: Test Coverage (with maturity rating)
- [ ] Write Section 5: Architectural Overview (if determinable)
- [ ] Write Section 6: Editorial Assessment (4 quality ratings + recommendations)
- [ ] Write Section 7: Quick Reference (summary table)

### Phase 5: Validate & Present (2–5 min)
- [ ] Verify all 7 sections present
- [ ] Check Markdown formatting (headers, tables, links)
- [ ] Verify tone is specific and candid (not generic)
- [ ] Check project URLs are linkified
- [ ] Output report to user

**Total time: 45–60 minutes for comprehensive analysis**

---

## Key Data Points to Collect

### Project Identity
```
Name:              [from repo metadata or README]
URL:               https://github.com/owner/repo
Language:          [primary by file count]
Framework(s):      [detected from dependencies]
License:           [from repo metadata]
Last Active:       [updated_at date]
```

### Code Metrics
```
Total Files:       [from tree count]
Primary Language:  [tally by extension]
Test Files:        [count in test directories]
Incomplete Items:  [count TODOs, FIXMEs, NotImplemented]
```

### Maturity Signals
```
Repo Age:          [created_at to present]
Commit Frequency:  [infer from updated_at]
Stars:             [from metadata]
Open Issues:       [from metadata]
Test Coverage:     [Coverage maturity: None/Minimal/Partial/Good/Comprehensive]
```

---

## Error Reference

| Problem | Solution |
|---------|----------|
| 404 URL | Confirm with user; offer GitHub token option |
| 403 Rate Limited | Wait for reset (check header); recommend auth token |
| No README | Proceed; note in Section 1; reduce narrative detail |
| No Tests | State "No test files found" in Section 4; flag in Section 6 |
| Archived Repo | Proceed; mark as "Archived" in Current State |
| Empty Repo | Ask user to confirm worthiness; minimal analysis |
| Huge Tree | Note truncation; fetch specific directories instead |
| Large Files | Sample key content; note truncation if needed |

---

## Report Section Templates

### Section 1: Project Summary
```
## Project Summary

**Name**: {name}
**Repository**: {URL}
**Primary Language**: {lang}
**Framework(s)**: {frameworks}
**License**: {license}
**Last Active**: {YYYY-MM-DD}
**Current State**: {Prototype | Alpha | Beta | Stable | Maintenance | Archived}

{Paragraph 1: What is it? What problem does it solve?}
{Paragraph 2: Who's it for? What's the maturity?}
{Paragraph 3: Notable context or caveats}
```

### Section 2: Features & Capabilities
```
## Features & Capabilities

### [Subsystem Name]
- **Feature**: Description of what it does
- **Feature**: Description

### [Subsystem Name]
- **Feature**: Description
```

### Section 3: Incomplete Implementations
```
## Incomplete Implementations

| Area | File/Location | Description | Severity |
|------|--------------|-------------|----------|
| {area} | {path:line} | {description} | {High/Medium/Low} |
```

### Section 4: Test Coverage Assessment
```
## Test Coverage Assessment

**Test Infrastructure**: ✓/✗ {framework names}
**Estimated Test Count**: {number} tests
**CI Integration**: ✓/✗ {CI system}
**Coverage Reporting**: ✓/✗ {coverage system or "Not configured"}
**Coverage Maturity**: **{Rating}** — {Justification}

**Notable Gaps**:
- {gap}
- {gap}
```

### Section 5: Architectural Overview
```
## Architectural Overview

**Pattern**: {pattern name}
**Core Dependencies**: {dependency list}
**Data Flow**: {flow description}
**Notable Decisions**: {decision descriptions}
```

### Section 6: Editorial Assessment
```
## Editorial Assessment

### Overall Quality Ratings

| Dimension | Score | Justification |
|-----------|-------|---------------|
| Code Quality | {1–10}/10 | {specific justification} |
| Architecture | {1–10}/10 | {specific justification} |
| Project Value | {1–10}/10 | {specific justification} |
| Production Readiness | {1–10}/10 | {specific justification} |

### Strengths
- {Specific strength with evidence}

### Concerns
- {Specific concern with evidence}

### Suggested Improvements

#### Quick Wins (hours–days)
- {actionable item}

#### Medium-Term (days–weeks)
- {actionable item}

#### Strategic Enhancements (weeks–months)
- {actionable item}

### New Feature Recommendations
1. **Feature Name**: {description + user benefit}
```

### Section 7: Quick Reference
```
## Quick Reference

| Field | Value |
|-------|-------|
| **Project** | {name} |
| **Language** | {language} |
| **Maturity** | {Prototype/Alpha/Beta/Stable/Maintenance} |
| **Test Coverage** | {None/Minimal/Partial/Good/Comprehensive} |
| **Incomplete Items** | {count} |
| **Overall Score** | {avg}/10 |
| **Recommendation** | {one sentence} |
```

---

## Scoring Guide (Section 6)

### Code Quality (1–10)
- **1–3**: Inconsistent style, poor naming, hard to follow
- **4–6**: Readable with some inconsistencies; room for refactoring
- **7–8**: Clean, consistent, well-named; follows conventions
- **9–10**: Exemplary; sets best practice examples

### Architecture (1–10)
- **1–3**: Tangled, circular dependencies, tight coupling
- **4–6**: Structured but with some coupling; needs refinement
- **7–8**: Clear separation of concerns; well-organized
- **9–10**: Elegant design; extensible and maintainable

### Project Value (1–10)
- **1–3**: Niche or limited use; solving a small problem
- **4–6**: Solves a real problem; useful in specific contexts
- **7–8**: High utility; addresses a significant need
- **9–10**: Unique, powerful solution; clear competitive advantage

### Production Readiness (1–10)
- **1–3**: Prototype/experimental; many gaps for production
- **4–6**: Core functionality ready; gaps in error handling, logging, security
- **7–8**: Production-capable; minor gaps (config, monitoring, etc.)
- **9–10**: Enterprise-ready; comprehensive error handling, security, monitoring

---

## Test Coverage Maturity Scale

| Level | Indicator | Example |
|-------|-----------|---------|
| **None** | No test files exist | No `Tests/` directory; no `test/` files |
| **Minimal** | Sparse, ad-hoc tests | Few test files; no framework discipline; inconsistent coverage |
| **Partial** | Structured tests with gaps | Systematic test structure; unit tests present; integration tests limited; no coverage config |
| **Good** | Systematic, CI-integrated | Test framework in use; CI runs tests on PR; most paths covered; visible coverage gaps |
| **Comprehensive** | High coverage, enforced | 80%+ coverage; thresholds enforced; advanced techniques (mutation testing, property tests) |

---

## Language Identification

**File Extension Tally** (count by extension; highest = primary):
- `.cs`, `.csproj` → **C# / .NET**
- `.ts`, `.tsx`, `.js`, `.jsx` → **TypeScript / JavaScript**
- `.py` → **Python**
- `.go` → **Go**
- `.rs` → **Rust**
- `.java` → **Java**
- `.rb` → **Ruby**

**Framework Detection** (from dependencies):
- C#: Look in `.csproj` for `<FrameworkVersion>` (net6.0, net8.0, etc.)
- JS/TS: Look in `package.json` → `dependencies` → `react`, `vue`, `angular`, `express`, `fastapi`, etc.
- Python: Look in `requirements.txt` or `pyproject.toml` → Django, FastAPI, Flask, etc.

---

## Incomplete Work Markers

### Hard Signals (Definite)
```
throw new NotImplementedException();
throw new NotSupportedException();
TODO: {description}
FIXME: {issue}
HACK: {workaround}
XXX: {problem}
// placeholder
// stub
// mock
// temporary
```

### Soft Signals (Probable)
- Empty methods: `{ }` or `{ return null; }`
- Methods returning default with no logic
- Interfaces with all members throwing
- Large commented-out code blocks (>5 lines)
- Methods named `DoLater`, `TempFix`, `Workaround`
- Tests marked `[Ignore]` or `@Skip`

---

## API Request Budget

**GitHub API Rate Limit**: 60 requests/hour (unauthenticated)

**Typical Analysis**: 12–15 API calls
| Task | Calls | Est. Time |
|------|-------|-----------|
| Repo metadata | 1 | <1s |
| File tree | 1 | <1s |
| Tier 1 files (parallel) | 4–6 | 2–3s |
| Tier 2 files (if needed) | 2–4 | 1–2s |
| Source sampling (if needed) | 2–4 | 1–2s |
| **Total** | **12–15** | **5–8s** |

**Well within rate limit.** Recommend user auth token if analyzing multiple repos in same session.

---

## Writing Style Checklist

### ✓ Specific & Candid
- [ ] Not generic ("good error handling" → "structured logging with correlation IDs")
- [ ] Uses evidence ("ServiceX doesn't catch timeout from PaymentAPI; should implement exponential backoff")
- [ ] Avoids hedging ("might perhaps" → "needs")
- [ ] Quantified when possible ("87-line method" vs. "some methods are long")

### ✓ Editorial Voice (Section 6)
- [ ] First person ("I see...", "We recommend...")
- [ ] Specific criticism paired with suggestion
- [ ] No vague praise
- [ ] Actionable recommendations

### ✓ Format Compliance
- [ ] Markdown headers correct (##, ###)
- [ ] Tables properly formatted
- [ ] All URLs linkified
- [ ] Code blocks with language tag
- [ ] **bold** for emphasis

### ✓ Completeness
- [ ] All 7 sections present
- [ ] No "I haven't run this code" disclaimers
- [ ] No broken links
- [ ] No typos or formatting errors

---

## Quick Wins for Enhancement

**When you finish the analysis**, flag these for user if applicable:

1. **Missing README** → "Add comprehensive README with setup, features, examples"
2. **No CI/CD** → "Set up GitHub Actions for automated testing and deployment"
3. **No tests** → "Add test project with at least 20 unit tests for core business logic"
4. **No coverage config** → "Add Coverlet for C# or Jest for TypeScript; target 70%+ coverage"
5. **Poor logging** → "Implement structured logging with correlation IDs for debugging"
6. **No error handling** → "Wrap external API calls with retry logic and specific exception types"
7. **Tight coupling** → "Introduce interfaces for major dependencies; add DI container"
8. **Documentation gaps** → "Add CONTRIBUTING.md, architecture decision records, setup guide"

---

## Kurt's Stack Quick Reference

When analyzing Kurt's projects (GitHub: kmitch2300):

### Expected Stack
- **Language**: C# (primary), TypeScript (frontend), Python (AI/ML)
- **Cloud**: Azure (compute, storage, AI services)
- **Framework**: ASP.NET Core 8, React
- **Testing**: xUnit, Jest
- **Architecture**: Layered + DDD patterns
- **Patterns**: Zero Trust, Event-driven, CQRS (where applicable)

### Red Flags
- ❌ Non-PascalCase naming for public members
- ❌ Missing async/await on I/O operations
- ❌ Business logic coupled to HTTP layer
- ❌ No distributed tracing instrumentation
- ❌ Unclear service boundaries

### Strengths to Highlight
- ✅ Clean middleware pipeline usage
- ✅ Clear layer separation
- ✅ Comprehensive test coverage
- ✅ Well-documented API contracts
- ✅ Specific exception types with context

---

## Need Help?

### Common Questions

**Q: The repo is huge; do I need to analyze everything?**
A: No. Use the 3-tier file system. Tier 1 alone gives you 80% of what you need.

**Q: File tree is truncated (>700 files)?**
A: Note this in Section 1. Fetch specific directories (`/src`, `/tests`) individually if needed.

**Q: No tests found. What do I do?**
A: State "No test files detected" in Section 4. Flag as major concern in Section 6. Recommend adding tests as Quick Win.

**Q: Repo is archived. Should I skip it?**
A: No. Proceed; mark Current State as "Archived" in Section 1. Adjust tone in Section 6 appropriately.

**Q: I'm rate-limited. What now?**
A: Stop; tell user you hit the 60 req/hour limit. Recommend auth token for next analysis. Provide partial report if useful.

**Q: How long should this take?**
A: 45–60 minutes for comprehensive analysis. 20–30 minutes if using Tier 1 only.

---

## Keyboard Shortcuts (Markdown)

- `##` → Section header
- `###` → Subsection header
- `| Table |` → Markdown table
- `**bold**` → Emphasis
- `*italic*` → De-emphasis
- `[Link](url)` → Hyperlink
- `` `code` `` → Inline code
- ` ``` ` → Code block

---

**Version**: Enhanced 2.1  
**Last Updated**: March 2026  
**For**: GitHub Project Analyzer Skill
