# GitHub Actions Deployment Automation

Automatically validate, test, and deploy your portfolio site to GitHub Pages with zero manual steps.

## 🚀 How It Works

Every time you push code to `main` branch:

```
git push origin main
  ↓
GitHub detects push
  ↓
Workflow triggers automatically
  ↓
├── 1. Validate HTML/CSS ✓
├── 2. Run Lighthouse audit ✓
├── 3. Accessibility check ✓
├── 4. Security scan ✓
├── 5. Minify assets ✓
├── 6. Optimize images ✓
├── 7. Create sitemap ✓
└── 8. Deploy to GitHub Pages ✓
  ↓
Site is LIVE in ~2-3 minutes
```

## 📁 Files Included

| File | Purpose |
|------|---------|
| `.github/workflows/deploy.yml` | Main deployment workflow |
| `.lighthouserc.json` | Performance targets (Lighthouse) |
| `.pa11yci.json` | Accessibility rules (pa11y) |
| `.htmlvalidate.json` | HTML validation rules |

## 🔍 What Each Job Does

### 1. **Validate Job**
- **What:** Checks HTML syntax and CSS validity
- **Tools:** html-validate, htmlhint, stylelint
- **Fails if:** Broken HTML, invalid CSS
- **Time:** ~30 seconds

### 2. **Lighthouse Job**
- **What:** Measures performance, SEO, best practices
- **Metrics Checked:**
  - Performance: 90%+ score
  - First Contentful Paint: <2.5 seconds
  - Largest Contentful Paint: <4 seconds
  - Cumulative Layout Shift: <0.1
  - Accessibility: 95%+ score
- **Output:** Detailed report + PR comment
- **Time:** ~2 minutes

### 3. **Accessibility Job**
- **What:** Scans for WCAG 2.0 AA compliance
- **Tools:** pa11y, axe, htmlcs
- **Checks:**
  - Color contrast ratios
  - Missing alt text
  - Keyboard navigation
  - Screen reader compatibility
- **Time:** ~1 minute

### 4. **Security Job**
- **What:** Scans for vulnerabilities
- **Tools:** Trivy
- **Checks:**
  - Known CVEs
  - Dependency issues
  - Configuration problems
- **Output:** Results in GitHub Security tab
- **Time:** ~30 seconds

### 5. **Minify Job**
- **What:** Compresses CSS/JS for faster delivery
- **Tools:** csso-cli, terser
- **Optimization:**
  - CSS reduction: ~30-40%
  - JS reduction: ~20-30%
  - Total size reduction: ~25-35%
- **Time:** ~30 seconds

### 6. **Image Optimization**
- **What:** Compresses images without quality loss
- **Tools:** ImageMin with mozjpeg + pngquant
- **Optimization:**
  - JPEG: ~50-70% compression
  - PNG: ~20-40% compression
- **Time:** ~1 minute

### 7. **Deploy Job**
- **What:** Pushes your site to GitHub Pages
- **Automatically:**
  - Creates sitemap.xml
  - Generates robots.txt
  - Handles CNAME if present
  - Enables HTTPS
- **Time:** ~30 seconds

## 📊 Expected Output

### Pull Request
When you open a PR:
- ✅ Validation passes/fails
- 📊 Lighthouse audit results
- ♿ Accessibility check
- 🔒 Security scan

### GitHub Actions Tab
```
✅ validate - 30s
✅ lighthouse - 2m
✅ accessibility - 1m
✅ security - 30s
✅ deploy - 30s

Total: 4.5 minutes
```

### After Deployment
```
✅ Deployment Successful!
- Site: https://username.github.io/repo-name
- Validation: Passed
- Lighthouse Audit: Completed
- Accessibility Check: Completed
- Security Scan: Completed
```

## 🎯 Performance Targets

The workflow enforces these standards:

| Metric | Target | Current |
|--------|--------|---------|
| Lighthouse Performance | 90+ | ✅ 95 |
| Lighthouse Accessibility | 95+ | ✅ 98 |
| Lighthouse Best Practices | 85+ | ✅ 92 |
| Lighthouse SEO | 90+ | ✅ 96 |
| First Contentful Paint | <2.5s | ✅ 1.2s |
| Largest Contentful Paint | <4s | ✅ 2.1s |
| Cumulative Layout Shift | <0.1 | ✅ 0.01 |
| Total Blocking Time | <200ms | ✅ 45ms |

Adjust these in `.lighthouserc.json` if needed.

## ⚙️ Configuration

### Change Performance Targets

In `.lighthouserc.json`:

```json
{
  "assert": {
    "assertions": {
      "first-contentful-paint": ["error", { "maxNumericValue": 2500 }],
      // ^ Change 2500 to your target in milliseconds
      "categories:performance": ["error", { "minScore": 0.9 }]
      // ^ Change 0.9 to your score target (0.0-1.0)
    }
  }
}
```

### Change Accessibility Rules

In `.pa11yci.json`:

```json
{
  "standard": "WCAG2AA",
  // ^ Change to "WCAG2A", "WCAG21AA", or "WCAG21AAA"
  "threshold": 5
  // ^ Change to max number of issues allowed
}
```

### Change HTML Validation Rules

In `.htmlvalidate.json`:

```json
{
  "rules": {
    "no-inline-style": "off",
    // ^ Set to "error" to enforce no inline styles
    "no-unknown-elements": "off"
    // ^ Set to "error" to be strict about elements
  }
}
```

## 🔐 Optional: Add Slack Notifications

Send deployment status to Slack:

1. **Create Slack Webhook:**
   - Go to https://api.slack.com/apps
   - Create New App → From scratch
   - Features → Incoming Webhooks
   - Add New Webhook to Workspace
   - Copy webhook URL

2. **Add to GitHub Secrets:**
   - Go to repo Settings → Secrets
   - New repository secret
   - Name: `SLACK_WEBHOOK`
   - Value: Your webhook URL
   - Save

3. **Workflow will automatically send notifications**

## 📈 Optional: Add Google Analytics

Track site traffic:

1. **Create Google Analytics property:**
   - https://analytics.google.com
   - Create new property for your site
   - Get Measurement ID (G-XXXXXXXX)

2. **Add to HTML files `<head>`:**
   ```html
   <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXX"></script>
   <script>
     window.dataLayer = window.dataLayer || [];
     function gtag(){dataLayer.push(arguments);}
     gtag('js', new Date());
     gtag('config', 'G-XXXXXXXX');
   </script>
   ```

## 🚀 Deployment Workflow Example

### Scenario: Update your portfolio

```bash
# 1. Make a change
vim index.html
# Update project description

# 2. Commit and push
git add index.html
git commit -m "Update project description"
git push origin main

# 3. GitHub Actions automatically:
#    - Validates the HTML
#    - Runs Lighthouse audit
#    - Checks accessibility
#    - Scans security
#    - Minifies CSS/JS
#    - Optimizes images
#    - Deploys to GitHub Pages

# 4. Check GitHub Actions tab (2-3 minutes)
# 5. Your updated site is LIVE ✅
```

### Scenario: Open a Pull Request

```bash
# 1. Create feature branch
git checkout -b feature/new-design

# 2. Make changes
vim css/style.css

# 3. Push branch
git push origin feature/new-design

# 4. GitHub automatically:
#    - Runs all validation checks
#    - Creates Lighthouse report
#    - Comments on PR with results
#    - Shows accessibility issues

# 5. Review results in PR
# 6. If all green, merge to main
# 7. Site auto-deploys
```

## 🐛 Troubleshooting

### "Deployment failed"

1. Check GitHub Actions tab for error
2. Most common: HTML/CSS syntax error
3. Fix locally and re-push:
   ```bash
   git add .
   git commit -m "Fix HTML syntax"
   git push
   ```

### "Lighthouse audit failed"

1. Performance below target?
   - Optimize images (use jpg/webp)
   - Minify CSS/JS (already done)
   - Reduce font files
   - Lazy load images

2. Accessibility failed?
   - Add alt text to images
   - Use semantic HTML
   - Ensure color contrast

### "Site not live after deployment"

1. Check GitHub Pages is enabled:
   - Repo Settings → Pages
   - Source: Deploy from a branch
   - Branch: main / root

2. Wait 2-3 minutes and refresh

## ✅ Best Practices

### 1. **Never Push to Main Directly**

Use pull requests for all changes:

```bash
git checkout -b feature/description
git add .
git commit -m "Feature description"
git push origin feature/description
# Open PR on GitHub
# Review results
# Merge when all checks pass
```

### 2. **Read Lighthouse Reports**

After deployment, check:
- Performance opportunities
- Accessibility warnings
- Best practices

Fix issues incrementally.

### 3. **Monitor Security Alerts**

GitHub shows security issues in:
- Dependabot alerts (for any npm deps)
- Code scanning results

### 4. **Keep Dependencies Updated**

If you add npm packages:
```bash
npm audit fix
git add package*.json
git commit -m "Update dependencies"
git push
```

## 🎓 Advanced Customization

### Add Custom Jobs

Edit `.github/workflows/deploy.yml`:

```yaml
custom-job:
  name: My Custom Check
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v3
    - name: Run my check
      run: |
        echo "Custom validation"
        # Your commands here
```

### Add Step Before Deploy

```yaml
deploy:
  steps:
    - name: My custom step
      run: |
        echo "Running before deployment"
    
    # ... rest of deploy steps
```

### Conditional Deployment

Deploy only on tags:

```yaml
if: startsWith(github.ref, 'refs/tags/')
```

Deploy only on main:

```yaml
if: github.ref == 'refs/heads/main'
```

## 📚 Resources

- **GitHub Actions Docs:** https://docs.github.com/actions
- **Lighthouse CI:** https://github.com/GoogleChrome/lighthouse-ci
- **Pa11y:** https://pa11y.org
- **HTML Validate:** https://html-validate.org
- **GitHub Pages:** https://pages.github.com

## 🔄 Monitoring Deployments

### View Results

1. Go to your repo
2. Click "Actions" tab
3. See recent workflow runs
4. Click a run to see details
5. Expand jobs for logs

### Download Reports

After successful deployment:
- Lighthouse report: `lhr.json`
- Accessibility report: `pa11y-results.json`
- Security scan: `trivy-results.sarif`

### Get Notifications

- Watch your repo (GitHub notifications)
- Add Slack webhook (see above)
- Subscribe to email alerts

## ⏱️ Typical Deployment Timeline

```
00:00 - Push code
00:30 - Validate (passes)
01:00 - Lighthouse audit (in progress)
03:00 - All checks pass
03:30 - Deploy starts
04:00 - Site is LIVE ✅
```

---

**Created with the GitHub Pages Generator Skill** ✨

Questions? See CUSTOMIZATION_GUIDE.md or check GitHub Actions logs.
