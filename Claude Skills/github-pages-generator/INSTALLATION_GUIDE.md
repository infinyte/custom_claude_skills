# Installation Guide - GitHub Pages Generator Skill

Complete instructions for installing and deploying the GitHub Pages Generator skill.

## 📋 Pre-Installation Checklist

Before installing, ensure you have:

- [ ] Claude 3.5 or later
- [ ] Access to file system for skill installation
- [ ] GitHub account (for generating projects)
- [ ] Basic understanding of GitHub Pages

## 🚀 Installation Methods

### Method 1: Direct Installation (Recommended)

#### Step 1: Obtain the Skill Package

```bash
# Clone from repository
git clone https://github.com/infinyte/github-pages-generator.git

# Or download as ZIP
# https://github.com/infinyte/github-pages-generator/releases/latest
```

#### Step 2: Copy Files to Skills Directory

```bash
# On Linux/Mac
cp -r github-pages-generator /mnt/skills/user/github-pages-generator

# On Windows (PowerShell)
Copy-Item -Recurse github-pages-generator -Destination "C:\Users\[USERNAME]\.claude\skills\github-pages-generator"
```

#### Step 3: Verify Installation

```bash
# Check that all files are present
ls /mnt/skills/user/github-pages-generator/

# Should show:
# - SKILL.md
# - OVERVIEW.md
# - EXAMPLE_PROMPTS.md
# - CUSTOMIZATION_GUIDE.md
# - DEPLOYMENT_AUTOMATION_GUIDE.md
# - skill-manifest.json
# - package.json
# - .github/workflows/deploy.yml
# - .lighthouserc.json
# - .pa11yci.json
# - .htmlvalidate.json
```

#### Step 4: Register Skill with Claude

```bash
# Update Claude's skill registry
# Add this to your Claude configuration file:

{
  "skills": {
    "github-pages-generator": {
      "path": "/mnt/skills/user/github-pages-generator",
      "enabled": true,
      "version": "1.0.0"
    }
  }
}
```

---

### Method 2: Package Manager Installation

If using a skill package manager:

```bash
# Install via skill registry
skill install github-pages-generator

# Or with version specification
skill install github-pages-generator@1.0.0
```

---

### Method 3: Manual Installation in Claude.ai

1. **Download the package:**
   - Go to: https://github.com/infinyte/github-pages-generator/releases/latest
   - Download `github-pages-generator-1.0.0.zip`

2. **Extract files:**
   - Extract to your local directory
   - Verify all files are present

3. **Add to Claude:**
   - In Claude.ai, go to Settings → Skills
   - Click "Add Custom Skill"
   - Browse to the extracted directory
   - Click "Import"

4. **Verify:**
   - Skill appears in your available skills list
   - Green checkmark indicates active status

---

## ✅ Post-Installation Verification

### Test 1: Skill Registration

In Claude, ask:
```
Does the github-pages-generator skill show up in your available skills?
```

**Expected response:** Confirmation that the skill is available.

---

### Test 2: Skill Triggering

Provide a GitHub repository:
```
Create a portfolio website for https://github.com/infinyte/sentiment-analyzer
```

**Expected behavior:**
- Skill auto-detects project type (TypeScript/Node.js)
- Asks about design preference
- Asks customization questions
- Generates site files

---

### Test 3: File Generation

After generation, verify:

```bash
# Check generated files
ls {project}-portfolio/

# Should contain:
# - index.html
# - architecture.html
# - features.html
# - quick-start.html
# - demo.html
# - css/ (directory)
# - js/ (directory)
# - README.md
```

---

## 🔧 Configuration

### Optional: Customize Skill Settings

Edit `skill-manifest.json` to customize:

```json
{
  "metadata": {
    "version": "1.0.0",
    "description": "Your custom description"
  },
  "triggers": {
    "explicit": [
      "Add your custom trigger phrases here"
    ]
  }
}
```

### Optional: Adjust GitHub Actions Defaults

Edit `.github/workflows/deploy.yml`:

```yaml
# Change performance targets
- name: Lighthouse audit
  run: |
    # Modify performance thresholds
```

---

## 🐛 Troubleshooting Installation

### Problem: Skill Not Showing Up

**Solution:**
1. Verify all files are in the correct directory
2. Check file permissions (should be readable)
3. Restart Claude application
4. Clear cache if available

```bash
# Verify permissions
chmod -R 755 /mnt/skills/user/github-pages-generator
```

---

### Problem: "Skill Not Recognized"

**Solution:**
1. Ensure SKILL.md is in the root directory
2. Check that skill-manifest.json is valid JSON
3. Verify file paths in manifest

```bash
# Validate JSON
python -m json.tool skill-manifest.json
```

---

### Problem: GitHub Actions Files Missing

**Solution:**
1. Ensure `.github/workflows/deploy.yml` exists
2. Check hidden file visibility

```bash
# Show hidden files
ls -la /mnt/skills/user/github-pages-generator/

# Should show:
# .github
# .lighthouserc.json
# .pa11yci.json
# .htmlvalidate.json
```

---

## 📚 Post-Installation Setup

### Step 1: Review Documentation

Read in this order:
1. **OVERVIEW.md** - Understand the skill
2. **EXAMPLE_PROMPTS.md** - Learn how to use it
3. **CUSTOMIZATION_GUIDE.md** - For later customization

### Step 2: Test with a Repository

```bash
# Find a GitHub project you own
# Provide the URL to Claude in this format:
"Create a portfolio website for https://github.com/[username]/[repo]"
```

### Step 3: Review Generated Output

```bash
# Examine the generated files
cd {project}-portfolio/
ls -la

# Check file structure
tree . # (if tree command available)
```

### Step 4: Deploy to GitHub Pages

```bash
# Push generated files to a repo
git init
git add .
git commit -m "Initial portfolio site"
git remote add origin https://github.com/[username]/[repo].git
git push -u origin main
```

---

## 🚀 First Run Checklist

- [ ] Skill installed and registered
- [ ] OVERVIEW.md reviewed
- [ ] GitHub repository identified
- [ ] Claude skill triggered successfully
- [ ] Design style selected
- [ ] Customization questions answered
- [ ] Files generated without errors
- [ ] Generated site README.md reviewed
- [ ] Files ready to push to GitHub
- [ ] GitHub Pages enabled on repository

---

## 🔄 Updating the Skill

### Check for Updates

```bash
# Check current version
cat package.json | grep version

# Check for available updates
git fetch origin
git log --oneline -n 5
```

### Update to Latest Version

```bash
# Update from repository
cd github-pages-generator
git pull origin main

# Or download latest release
# https://github.com/infinyte/github-pages-generator/releases/latest
```

### Update Installation

```bash
# Copy updated files
cp -r github-pages-generator /mnt/skills/user/github-pages-generator

# Verify updated version
cat /mnt/skills/user/github-pages-generator/package.json | grep version
```

---

## 📞 Support

### Getting Help

1. **Check Documentation:**
   - OVERVIEW.md - General information
   - EXAMPLE_PROMPTS.md - Usage examples
   - CUSTOMIZATION_GUIDE.md - Modifications
   - DEPLOYMENT_AUTOMATION_GUIDE.md - Deployment

2. **Check GitHub Issues:**
   - https://github.com/infinyte/github-pages-generator/issues
   - Search for similar issues first

3. **Report Issues:**
   - Provide skill version
   - Include GitHub repo URL (sanitized)
   - Describe what went wrong
   - Include any error messages

---

## ✨ Next Steps

After successful installation:

1. **Learn the skill:** Read OVERVIEW.md
2. **Find examples:** Browse EXAMPLE_PROMPTS.md
3. **Test it:** Generate a site from a repository
4. **Customize:** Use CUSTOMIZATION_GUIDE.md
5. **Deploy:** Follow DEPLOYMENT_AUTOMATION_GUIDE.md

---

## 🎓 System Requirements

### Minimum
- Claude 3.5 or later
- 500MB disk space for skill
- 150-200MB per generated site
- GitHub account
- Basic Git knowledge

### Recommended
- Claude 3.6 or later
- 1GB disk space
- GitHub Desktop or Git CLI
- Terminal/command line experience
- Understanding of HTML/CSS (for customization)

---

## 📊 Installation Verification Checklist

### Files Present
- [ ] SKILL.md (1,025+ lines)
- [ ] OVERVIEW.md (950+ lines)
- [ ] EXAMPLE_PROMPTS.md (1,300+ lines)
- [ ] CUSTOMIZATION_GUIDE.md (1,200+ lines)
- [ ] DEPLOYMENT_AUTOMATION_GUIDE.md (1,050+ lines)
- [ ] skill-manifest.json
- [ ] package.json
- [ ] .github/workflows/deploy.yml
- [ ] .lighthouserc.json
- [ ] .pa11yci.json
- [ ] .htmlvalidate.json

### Skill Status
- [ ] Appears in Claude skill list
- [ ] Can be triggered with GitHub URL
- [ ] Responds to skill-specific prompts
- [ ] Generates expected output

### Documentation
- [ ] All guides readable
- [ ] No broken links in guides
- [ ] Examples understandable
- [ ] Code samples copy-able

---

## 🎉 Installation Complete!

Once you've verified everything:

1. **Try the skill:** Provide a GitHub repository URL
2. **Follow the workflow:** Answer customization questions
3. **Get your site:** Receive complete generated portfolio
4. **Deploy it:** Push to GitHub Pages
5. **Enjoy:** Share your professional showcase! 🚀

---

**Need help?** Check the troubleshooting section above or review OVERVIEW.md for more context.

*Last Updated: March 2024*
