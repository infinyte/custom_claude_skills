# Customization Guide - Post-Generation

After the skill generates your portfolio site, here's how to customize it for your exact needs.

## 🎨 Design Customization

### Change Color Scheme

Edit `css/variables.css` (all colors defined here):

```css
:root {
  /* Primary colors - change these for instant theme change */
  --color-primary: #667eea;      /* Main accent color */
  --color-secondary: #764ba2;    /* Secondary accent */
  --color-accent: #f093fb;       /* Highlight color */
  --color-success: #51cf66;      /* Success/positive indicator */
  --color-warning: #ffb236;      /* Warning/attention */
  --color-danger: #ff6b6b;       /* Error/negative */
}
```

**Quick Change Examples:**

1. **Blue theme** → `#0066cc`, `#0052a3`, `#0d7377`
2. **Purple theme** → `#7c3aed`, `#6d28d9`, `#a855f7`
3. **Green theme** → `#10b981`, `#059669`, `#34d399`
4. **Orange theme** → `#f97316`, `#ea580c`, `#fb923c`

### Change Fonts

In `css/variables.css`:

```css
/* System fonts (fast, no external requests) */
--font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;

/* Or use Google Fonts - add to HTML <head>: */
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

/* Then update CSS variable: */
--font-sans: 'Poppins', sans-serif;
```

**Popular Font Combinations:**

- **Modern:** Poppins (sans) + Courier Prime (mono)
- **Professional:** Inter (sans) + JetBrains Mono (mono)
- **Elegant:** Lora (sans) + IBM Plex Mono (mono)
- **Technical:** IBM Plex Sans (sans) + IBM Plex Mono (mono)

### Change Logo/Branding

Find in all HTML files:
```html
<span class="logo-icon">📊</span>
Sentiment
```

**Replace with:**

Option 1: Different emoji
```html
<span class="logo-icon">🚀</span>
```

Option 2: Text only
```html
My Project
```

Option 3: SVG logo
```html
<span class="logo-icon">
  <svg width="24" height="24" viewBox="0 0 24 24">
    <!-- Your SVG content -->
  </svg>
</span>
```

---

## 📄 Content Customization

### Update Project Information

**In every HTML file, update:**

```html
<!-- Homepage title -->
<h1>Your Project Name</h1>

<!-- Project description -->
<p class="hero-subtitle">
  Your compelling one-line description
</p>

<!-- Contact/links -->
<a href="https://github.com/YOUR_USERNAME/YOUR_REPO">GitHub</a>
```

### Add/Remove Pages

**To add a new page:**

1. Copy `features.html` and rename (e.g., `team.html`)
2. Update content inside `<main>` tags
3. Add navigation link in sidebar (all HTML files):

```html
<a href="team.html" class="nav-item">Team</a>
```

4. Update the link in all other pages too

**To remove a page:**

1. Delete the HTML file
2. Remove the `<a>` tag from all sidebars

### Update Tech Stack

In `index.html`, find:
```html
<div class="tech-category">
  <h3>Frontend</h3>
  <ul>
    <li>React 18</li>
    <li>TypeScript</li>
    <!-- Update these -->
  </ul>
</div>
```

### Add Images/Screenshots

1. Create `images/` folder (if not present)
2. Add your images (PNG, JPG, WebP)
3. Reference in HTML:

```html
<img src="images/screenshot.png" alt="Feature demonstration">
```

**Optimize images:**
```bash
# Compress images
convert screenshot.png -quality 85 screenshot-optimized.png

# Or use ImageMagick
mogrify -resize 1200x800 -quality 85 images/*.png
```

---

## 🎯 Feature Customization

### Modify Metrics/KPIs

In `index.html` and `demo.html`:

```html
<div class="stat-card">
  <div class="stat-value">YOUR_NUMBER</div>
  <div class="stat-label">What it measures</div>
  <p class="stat-desc">Context/explanation</p>
</div>
```

### Update Feature Cards

In `features.html`:

```html
<div class="card">
  <h3>Feature Name</h3>
  <p>Your feature description with details about what makes it special</p>
</div>
```

### Customize Quick-Start

In `quick-start.html`:

```html
<div class="code-block">
  <pre><code>your installation commands here</code></pre>
</div>
```

### Add Demo/Live Links

Update links throughout:

```html
<!-- Replace with your actual links -->
<a href="https://your-live-demo.com" target="_blank">Live Demo</a>
<a href="https://your-video-link.com" target="_blank">Video Walkthrough</a>
```

---

## 🎬 Add Animations

### Stagger Animation for Cards

Add to `<section>` or `<div>`:

```html
<div style="animation: slideUp 0.6s ease forwards; animation-delay: 0.1s;">
  Content here
</div>
```

Adjust `animation-delay` for each card: `0.1s`, `0.2s`, `0.3s`, etc.

### Add Hover Effects

To `css/style.css`:

```css
.your-element:hover {
  transform: translateY(-5px);
  box-shadow: var(--shadow-lg);
  color: var(--color-primary);
}
```

### Create Custom Animations

Add to `css/style.css`:

```css
@keyframes yourAnimation {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.your-class {
  animation: yourAnimation 0.6s ease forwards;
}
```

---

## 📱 Responsive Adjustments

### Adjust Mobile Breakpoints

In `css/responsive.css`:

```css
/* Current: 768px for tablet */
@media (max-width: 768px) {
  /* Mobile styles */
}

/* Change to 900px if preferred */
@media (max-width: 900px) {
  /* Your adjustments */
}
```

### Hide/Show Elements on Mobile

```css
/* Hide on mobile */
@media (max-width: 768px) {
  .hide-mobile {
    display: none !important;
  }
}

/* Show only on mobile */
@media (max-width: 768px) {
  .show-mobile-only {
    display: block !important;
  }
}
```

Then in HTML:
```html
<div class="hide-mobile">Desktop-only content</div>
<div class="show-mobile-only">Mobile-only content</div>
```

---

## 🔗 Update External Links

Search and replace across all files:

```bash
# Find all instances of old link
grep -r "old-link.com" .

# Replace with new link (all files)
sed -i 's/old-link.com/new-link.com/g' *.html
```

Or manually update:
- GitHub repository URLs
- Live demo links
- Social media profiles
- Email/contact info

---

## 🎓 Add Learning Resources

In any HTML file, add:

```html
<section class="resources-section">
  <h2>Resources & Links</h2>
  <ul>
    <li><a href="https://docs.example.com">Official Documentation</a></li>
    <li><a href="https://tutorial.example.com">Tutorial</a></li>
    <li><a href="https://community.example.com">Community</a></li>
  </ul>
</section>
```

---

## 🔄 Version Control Best Practices

### Recommended Workflow

```bash
# 1. Create a development branch
git checkout -b develop

# 2. Make changes locally
vim index.html
vim css/style.css

# 3. Test locally (if you set up a local server)
python -m http.server 8000

# 4. Commit changes
git add .
git commit -m "Update metrics and styling"

# 5. Push to GitHub Pages
git push origin main

# 6. Site updates automatically via GitHub Actions
```

### Keep Track of Changes

```bash
# See what changed
git diff

# View commit history
git log --oneline

# Revert to previous version if needed
git revert <commit-hash>
```

---

## 🐛 Common Customizations

### Add a Newsletter Signup

```html
<section class="newsletter-section">
  <h2>Get Updates</h2>
  <form action="https://your-email-service.com/subscribe" method="POST">
    <input type="email" placeholder="Your email" required>
    <button type="submit" class="btn btn-primary">Subscribe</button>
  </form>
</section>
```

### Add a Contact Form

```html
<section class="contact-section">
  <h2>Get in Touch</h2>
  <form action="https://formspree.io/f/YOUR_ID" method="POST">
    <input type="email" name="email" placeholder="Your email" required>
    <textarea name="message" placeholder="Your message" required></textarea>
    <button type="submit" class="btn btn-primary">Send</button>
  </form>
</section>
```

### Add a Team Section

```html
<section class="team-section">
  <h2>Team</h2>
  <div class="team-grid">
    <div class="team-member">
      <img src="images/person1.jpg" alt="Person Name">
      <h3>Person Name</h3>
      <p>Role / Title</p>
      <a href="https://twitter.com/handle">Twitter</a>
    </div>
  </div>
</section>
```

---

## 🔍 SEO Optimization

### Update Meta Tags

In `<head>` of each HTML file:

```html
<meta name="description" content="Your compelling description">
<meta name="keywords" content="tag1, tag2, tag3">
<meta name="author" content="Your Name">
<meta property="og:title" content="Your Title">
<meta property="og:description" content="Description for social sharing">
<meta property="og:image" content="https://your-domain.com/image.png">
```

### Add Google Analytics

```html
<!-- Add before </head> -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```

### Generate Sitemap

```xml
<!-- sitemap.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://your-site.com/</loc>
  </url>
  <url>
    <loc>https://your-site.com/architecture.html</loc>
  </url>
  <url>
    <loc>https://your-site.com/features.html</loc>
  </url>
</urlset>
```

---

## ⚡ Performance Optimization

### Minimize CSS

```bash
npm install -g csso-cli
csso css/style.css -o css/style.min.css
```

### Minimize JavaScript

```bash
npm install -g terser
terser js/main.js -o js/main.min.js
```

### Optimize Images

```bash
# Use ImageMagick
mogrify -quality 85 -strip images/*.jpg
mogrify -quality 85 images/*.png

# Or use online tools
# - TinyPNG.com
# - ImageOptim.com
```

### Lazy Load Images

```html
<img src="image.jpg" loading="lazy" alt="Description">
```

---

## 🎓 Testing Checklist

Before deploying:

- [ ] All links work (internal and external)
- [ ] Images load correctly
- [ ] Mobile view looks good (test on actual phone)
- [ ] No console errors (F12 → Console)
- [ ] Fast page load (<3 seconds on 4G)
- [ ] Accessibility: Tab navigation works
- [ ] All text is readable (contrast check)
- [ ] Hero section loads correctly
- [ ] Sidebar closes on mobile

---

## 📚 Further Customization Resources

- **CSS Tricks:** https://css-tricks.com
- **Web.dev:** https://web.dev
- **MDN Web Docs:** https://developer.mozilla.org
- **Color Palette Generator:** https://coolors.co
- **Google Fonts:** https://fonts.google.com

---

Created with the **GitHub Pages Generator Skill** ✨
Last Updated: March 2024
