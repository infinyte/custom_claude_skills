# GitHub Project Analyzer — Complete Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the GitHub Project Analyzer skill (v3.0.0) to production.

**Current Status**: Production Ready  
**Last Updated**: March 23, 2026  
**Estimated Deployment Time**: 30 minutes

---

## Prerequisites

### System Requirements
- Node.js 18+
- Access to `/mnt/skills/user/` directory (write permissions)
- Access to `/mnt/user-data/outputs/` directory (read/write)
- Claude API access (for skill invocation)

### Required Skills/Tools
- Basic file management (copy, move, verify)
- Command line navigation
- Text editor (for configuration if needed)

---

## Pre-Deployment Checklist

Before deploying, verify:

- [ ] All three phases have been implemented
  - [ ] Phase 1 code copied from PHASE-1-WORKING-EXAMPLE.md
  - [ ] Phase 2 code copied from PHASE-2-WORKING-EXAMPLE.md
  - [ ] Phase 3 code copied from PHASE-3-WORKING-EXAMPLE.md
- [ ] All tests pass locally
  - [ ] testPhase1() ✅
  - [ ] runPhase2Tests() ✅
  - [ ] runPhase3Tests() ✅
- [ ] Code is integrated into main analyzeGitHubRepository() function
- [ ] `/mnt/user-data/outputs/` directory exists and is writable
- [ ] All documentation files are prepared

---

## Deployment Steps

### Step 1: Create Skill Directory Structure

```bash
# Create skill directory if it doesn't exist
mkdir -p /mnt/skills/user/github-project-analyzer/

# Verify directory created
ls -la /mnt/skills/user/github-project-analyzer/
```

**Expected Output**:
```
total 8
drwxr-xr-x  2 root root 4096 Mar 23 10:00 .
drwxr-xr-x  3 root root 4096 Mar 23 10:00 ..
```

### Step 2: Place the Main Skill File

```bash
# Copy SKILL.md to the skill directory
cp /mnt/user-data/outputs/SKILL.md /mnt/skills/user/github-project-analyzer/SKILL.md

# Verify file placement
ls -lh /mnt/skills/user/github-project-analyzer/SKILL.md
```

**Expected Output**:
```
-rw-r--r-- 1 root root 25K Mar 23 10:05 SKILL.md
```

### Step 3: Copy Supporting Documentation

```bash
# Copy documentation files to the skill directory
cp /mnt/user-data/outputs/DEPLOYMENT-GUIDE.md /mnt/skills/user/github-project-analyzer/
cp /mnt/user-data/outputs/PACKAGE-MANIFEST.md /mnt/skills/user/github-project-analyzer/
cp /mnt/user-data/outputs/README.md /mnt/skills/user/github-project-analyzer/

# Verify files
ls -lh /mnt/skills/user/github-project-analyzer/
```

### Step 4: Verify Output Directory

```bash
# Ensure outputs directory exists and is writable
mkdir -p /mnt/user-data/outputs/
chmod 755 /mnt/user-data/outputs/

# Test write permission
touch /mnt/user-data/outputs/.test_write
rm /mnt/user-data/outputs/.test_write

echo "✓ Output directory verified"
```

### Step 5: Run Pre-Deployment Tests

```javascript
// Run all three test suites
console.log("Running Phase 1 tests...");
await runPhase1Tests();

console.log("\nRunning Phase 2 tests...");
await runPhase2Tests();

console.log("\nRunning Phase 3 tests...");
await runPhase3Tests();

console.log("\n✓ All tests passed!");
```

**Expected Output**:
```
============================================================
PHASE 1 TEST SUITE
============================================================
✓ Test 1: Full Report + HTML → Corrected to Markdown
✓ Test 2: Short Report + Markdown → Valid
✓ Test 3: Short Report + HTML → Corrected to Markdown
✓ Test 4: Preferences summary utilities
✓ Test 5: Analysis context creation
✓ ALL PHASE 1 TESTS PASSED

============================================================
PHASE 2 TEST SUITE
============================================================
✓ Full Report test PASSED (1850 words)
✓ Short Report test PASSED (720 words)
✓ ALL PHASE 2 TESTS PASSED

============================================================
PHASE 3 TEST SUITE
============================================================
✓ Full Report test PASSED
✓ Short Report test PASSED
✓ ALL PHASE 3 TESTS PASSED
```

### Step 6: Test with Real Repository

```javascript
// Test with a real GitHub repository
const testUrl = "https://github.com/infinyte/sentiment-analyzer";

console.log(`Testing with: ${testUrl}\n`);
const result = await analyzeGitHubRepository(testUrl);

// Verify output
console.log("\nVerifying output:");
console.assert(result.preferences, "✓ Preferences captured");
console.assert(result.report, "✓ Report generated");
console.assert(result.outputFile, "✓ Output file created");
console.assert(result.outputFile.path, "✓ File path: " + result.outputFile.path);

console.log("\n✓ Real repository test passed!");
```

**Expected Output**:
```
Testing with: https://github.com/infinyte/sentiment-analyzer

Step 7: Synthesizing Full Report...
✓ Report synthesized (1850 words, 7 sections)

Step 8A: Generating Markdown output...
✓ Markdown file generated:
  Type: Full Report
  File: sentiment-analyzer-analysis.md
  Size: 45.2 KB
  Path: /mnt/user-data/outputs/sentiment-analyzer-analysis.md
  Status: Ready for download/viewing

Verifying output:
✓ Preferences captured
✓ Report generated
✓ Output file created
✓ File path: /mnt/user-data/outputs/sentiment-analyzer-analysis.md

✓ Real repository test passed!
```

### Step 7: Verify Generated Files

```bash
# List generated output files
ls -lh /mnt/user-data/outputs/*.md

# Verify file content (sample)
head -30 /mnt/user-data/outputs/sentiment-analyzer-analysis.md

# Check file is valid Markdown
file /mnt/user-data/outputs/sentiment-analyzer-analysis.md
```

**Expected Output**:
```
-rw-r--r-- 1 root root 45K Mar 23 10:15 sentiment-analyzer-analysis.md

---
title: "sentiment-analyzer — Project Analysis"
repository: "https://github.com/infinyte/sentiment-analyzer"
report_type: "Full Report"
generated_at: "2026-03-23T15:30:45.123Z"
word_count: 1850
section_count: 7
---

## Table of Contents
...
```

---

## Post-Deployment Verification

### Checklist

- [ ] Skill directory created at `/mnt/skills/user/github-project-analyzer/`
- [ ] SKILL.md placed in skill directory
- [ ] Supporting documentation copied
- [ ] All three test suites pass
- [ ] Real repository test succeeds
- [ ] Output files created in `/mnt/user-data/outputs/`
- [ ] Generated files are valid Markdown
- [ ] YAML frontmatter present in output files
- [ ] Metadata footer present in output files
- [ ] File permissions correct (readable)

### Smoke Tests

```javascript
// Quick smoke test
async function smokeTest() {
  // Test 1: Preferences
  const prefs = await phase1_capturePreferences();
  console.assert(prefs.reportType, "Phase 1 works");
  
  // Test 2: Report generation (mock context)
  const mockContext = { /* ... */ };
  const report = await step7_synthesizeReport(mockContext);
  console.assert(report.report, "Phase 2 works");
  
  // Test 3: File output (mock)
  const output = await step8a_generateMarkdownOutput(mockContext);
  console.assert(output.outputFile, "Phase 3 works");
  
  console.log("✓ Smoke tests passed");
}

await smokeTest();
```

---

## Configuration (Optional)

### Custom Output Directory

If you need to change the output directory:

1. Open SKILL.md in text editor
2. Find the `writeMarkdownFile()` function
3. Change this line:
   ```javascript
   const outputDir = '/mnt/user-data/outputs';  // ← Change this
   ```
4. Save and redeploy

### Custom Report Settings

To adjust report targets (word counts, section counts):

1. Open the relevant PHASE-*-WORKING-EXAMPLE.md
2. Find the word count constants
3. Adjust values:
   ```javascript
   const FULL_REPORT_TARGET = 1800;  // ← Adjust word count
   const SHORT_REPORT_TARGET = 750;
   ```
4. Reintegrate code and redeploy

---

## Troubleshooting Deployment Issues

### Issue: Permission Denied on Skill Directory

**Solution**:
```bash
# Check permissions
ls -la /mnt/skills/user/

# Fix permissions if needed
chmod 755 /mnt/skills/user/github-project-analyzer/
chmod 644 /mnt/skills/user/github-project-analyzer/SKILL.md
```

### Issue: Output Directory Not Found

**Solution**:
```bash
# Create output directory
mkdir -p /mnt/user-data/outputs/

# Set permissions
chmod 755 /mnt/user-data/outputs/
```

### Issue: Tests Fail on Phase 1

**Solution**:
- Verify ask_user_input_v0 tool is available
- Check that preference functions are properly integrated
- Review Phase 1 implementation in SKILL.md

### Issue: Tests Fail on Phase 2

**Solution**:
- Verify all 7 section functions are present
- Check context.report is properly populated
- Verify word count calculations are correct
- Review Phase 2 implementation

### Issue: Tests Fail on Phase 3

**Solution**:
- Verify `/mnt/user-data/outputs/` exists and is writable
- Check Node.js fs module is available
- Verify file write permissions
- Review Phase 3 implementation

### Issue: Real Repository Test Fails

**Solution**:
- Verify GitHub URL is valid
- Check API access to GitHub (Steps 1–6)
- Review error logs for specific failures
- Try with a different public repository

---

## Rollback Procedure

If deployment fails and you need to rollback:

### Rollback to Previous Version

```bash
# Backup current (broken) version
mv /mnt/skills/user/github-project-analyzer/SKILL.md \
   /mnt/skills/user/github-project-analyzer/SKILL.md.broken

# Restore previous version
cp /mnt/skills/user/github-project-analyzer/SKILL.md.previous \
   /mnt/skills/user/github-project-analyzer/SKILL.md

# Clean up output files (optional)
rm /mnt/user-data/outputs/*-analysis.md
```

### Verify Rollback

```bash
# Run Phase 1 test to verify rollback
await runPhase1Tests();

# Should pass with previous version
```

---

## Performance Baseline

After successful deployment, you should see these performance characteristics:

### Analysis Time
- **Phase 1** (Preferences): <1 second
- **Steps 1–5** (Analysis): 2–5 minutes
- **Phase 2** (Report): 30–60 seconds
- **Phase 3** (File): 1–5 seconds
- **Total**: 2.5–6 minutes per repository

### Output Characteristics
- **Full Report Size**: 20–50 KB
- **Short Report Size**: 10–25 KB
- **File Format**: UTF-8 Markdown with YAML frontmatter
- **Disk I/O**: Single write operation (~100 ms)

---

## Monitoring & Maintenance

### Daily Checks
- [ ] Skill directory accessible
- [ ] Output directory writable
- [ ] No stale files in output directory
- [ ] Recent test runs successful

### Weekly Tasks
- [ ] Archive old output files (older than 30 days)
- [ ] Review any error logs
- [ ] Run full test suite
- [ ] Test with new sample repositories

### Monthly Tasks
- [ ] Performance benchmarking
- [ ] Code review for updates
- [ ] Backup skill files
- [ ] Update documentation if needed

---

## Scaling Considerations

### For Multiple Users
- Ensure `/mnt/user-data/outputs/` has sufficient disk space
- Consider unique output directories per user
- Implement cleanup procedures for old files
- Monitor disk usage

### For Large Repositories
- Analysis time may exceed 10 minutes for very large repos
- Consider caching intermediate results
- Implement timeout handling
- Monitor memory usage

---

## Support

### Getting Help
1. Check **TROUBLESHOOTING** section above
2. Review **README.md** for usage questions
3. Check **PHASE-*-IMPLEMENTATION.md** for implementation issues
4. Review test output for specific errors

### Reporting Issues
Include in issue report:
- Exact command that failed
- Error message/stack trace
- System information (OS, Node.js version)
- Input (GitHub URL tested)
- Expected vs. actual output

---

## Success Criteria

Deployment is successful when:

✅ All three test suites pass (Phase 1, 2, 3)  
✅ Real repository test completes successfully  
✅ Output files are created in correct location  
✅ Generated Markdown files are valid  
✅ All required fields present in output  
✅ No permission errors  
✅ Performance meets baseline  

---

## Next Steps

After successful deployment:

1. **Share with Users**: Point users to README.md for usage instructions
2. **Monitor Deployment**: Track usage and performance for first week
3. **Gather Feedback**: Collect user feedback on report quality
4. **Plan Phase 4**: When ready, begin HTML output generation
5. **Plan Phase 5**: When Phase 4 complete, begin PDF generation

---

## Deployment Checklist (Final)

### Pre-Deployment
- [ ] All code implemented and tested locally
- [ ] All three test suites passing
- [ ] Code integrated into main function
- [ ] Documentation complete

### Deployment
- [ ] Skill directory created
- [ ] SKILL.md copied to skill directory
- [ ] Supporting documentation copied
- [ ] Output directory prepared
- [ ] Pre-deployment tests run
- [ ] Real repository test run

### Post-Deployment
- [ ] All tests still passing
- [ ] Output files created correctly
- [ ] Files accessible and readable
- [ ] Documentation accessible
- [ ] Monitoring/maintenance plan in place

---

## Summary

The GitHub Project Analyzer skill is now deployed and ready for production use.

**Status**: ✅ Production Ready  
**Version**: 3.0.0  
**Last Deployed**: March 23, 2026  

**Key Features**:
- Two-step preference capture
- Type-specific report generation
- Markdown file output
- Complete test coverage
- Production-grade code

**Ready to analyze repositories!** 🚀

