---
name: github-pages-generator
description: Transform GitHub repositories into production-ready portfolio websites. Auto-detects project type, guides interactive customization, generates multi-page responsive sites with GitHub Actions deployment. Triggers on any GitHub URL + portfolio/website/showcase intent. Generates complete HTML/CSS/JS, deployment guides, and customization instructions—no partial deliverables.
---

# GitHub Pages Site Generator

A specialized skill for transforming GitHub repositories into polished, interactive portfolio showcase websites with interactive customization, intelligent repo-type detection, and multiple design aesthetics.

## Core Purpose

Turn a GitHub repo URL into a production-ready, deployable GitHub Pages site in an interactive workflow. Auto-detect project type, guide customization via targeted questions, then generate complete site files ready to deploy.

## When to Use This Skill

Use this skill when the user:
- Provides a GitHub repository URL and wants a portfolio/showcase website
- Requests "create a Pages site for my repo"
- Wants to showcase a project with a professional website
- Needs GitHub Pages files + deployment structure
- Mentions generating a portfolio site, project showcase, or documentation site from a GitHub repo

**Triggers**: "portfolio site", "GitHub Pages", "showcase website", "create a site for my repo", "generate Pages", "make a website from my GitHub project"

## Workflow Overview

```
User provides repo URL
    ↓
Auto-detect repo type
    ↓
Ask design preference (modern/portfolio/docs)
    ↓
Interactive customization (sections, content, focus areas)
    ↓
Generate complete site structure
    ↓
Deliver deployment-ready files + guide
```

## Step 1: Repository Analysis & Type Detection

When the user provides a GitHub repo URL:

### Auto-Detection Logic

Analyze the repository to determine type:

```
**Primary Project Types** (auto-detected):

├── TypeScript/Node.js Projects
│   ├── Files: package.json, tsconfig.json, .ts files
│   ├── Frameworks: Express, Next.js, NestJS, React
│   └── Highlight: API design, performance, scalability
│
├── .NET/C# Projects
│   ├── Files: *.csproj, *.sln, appsettings.json
│   ├── Frameworks: .NET Core, ASP.NET, Entity Framework
│   └── Highlight: Architecture patterns (DDD, CQRS), enterprise patterns
│
├── Python/ML/Computer Vision
│   ├── Files: requirements.txt, setup.py, *.ipynb, Dockerfile
│   ├── Frameworks: PyTorch, TensorFlow, scikit-learn, OpenCV
│   └── Highlight: Model architecture, training pipeline, metrics
│
└── Full-Stack Web Apps
    ├── Indicators: Frontend + Backend + Database
    ├── Files: package.json + *.csproj OR requirements.txt + node modules
    └── Highlight: Architecture, feature walkthrough, deployment
```

### Detection Process

```bash
# Analyze repository structure
find {repo} -maxdepth 2 -type f \( -name "*.csproj" -o -name "package.json" \
  -o -name "requirements.txt" -o -name "Cargo.toml" -o -name "go.mod" \)

# Check for documentation
find {repo} -name "*.md" | grep -i "readme\|architecture\|design\|docs"

# Identify tech stack
cat {repo}/package.json | jq .dependencies
cat {repo}/*.csproj 2>/dev/null | grep -o "TargetFramework.*"
```

## Step 2: Design Style Selection

Present the user with three design options:

### Option 1: Modern Minimal
- **Aesthetic**: Clean, typography-focused, high whitespace
- **Color**: Neutral palette (grays, one accent color)
- **Layout**: Single-column or two-column, prose-heavy
- **Best for**: Libraries, APIs, documentation-heavy projects
- **Tech**: Plain HTML/CSS, fast loading, accessible
- **Example vibe**: HubSpot docs, Stripe documentation

### Option 2: Portfolio Heavy
- **Aesthetic**: Visually rich, showcase-focused, metrics-prominent
- **Color**: Brand-forward, dynamic gradients
- **Layout**: Multi-section, image galleries, stat cards
- **Best for**: Full-stack apps, ML projects, anything you're proud of
- **Tech**: CSS animations, image assets, modern design patterns
- **Example vibe**: Vercel product pages, Figma's case studies

### Option 3: Documentation Style
- **Aesthetic**: Official docs vibe, navigation-focused, scannable
- **Color**: Professional (blue/dark theme options)
- **Layout**: Sidebar navigation, multi-page, code-centric
- **Best for**: Tools, CLIs, frameworks, data engineering
- **Tech**: Code syntax highlighting, table of contents, search-ready
- **Example vibe**: Official React/Next.js docs, GitHub documentation

**Defaults by Project Type**:
- ML/Data Engineering → Portfolio Heavy (showcase results, metrics)
- Libraries/SDKs → Documentation Style (API-focused)
- Full-Stack Web → Portfolio Heavy (feature showcase)
- Systems (Go/Rust) → Modern Minimal (performance-focused)
- .NET/Enterprise → Documentation Style or Portfolio Heavy (your choice)

## Step 2b: Hybrid Content Gathering

The skill uses a **hybrid approach**:

1. **Auto-extract** from repository (first pass)
   - Project description, README
   - Tech stack from dependency files
   - Architecture docs if present
   - Code examples and quick-start guides
   - Existing metrics or benchmarks

2. **Ask refinement questions** (second pass)
   - Clarify/enhance what was auto-detected
   - Fill gaps not found in repo
   - Prioritize what to emphasize
   - Provide qualitative context (problems solved, decisions made)

This minimizes user input while capturing rich context from existing repo content.

## Step 3: Interactive Customization Questions

Based on detected project type, ask targeted questions:

### For ML/Computer Vision Projects

```
1. What's the primary use case? (e.g., image classification, NLP, object detection)
2. Do you have:
   - [ ] Performance metrics (accuracy, F1, inference time)?
   - [ ] Training data samples or visualizations?
   - [ ] Model architecture diagrams?
   - [ ] Demo/inference examples?
3. Should we include:
   - [ ] Live model demo (iframe to Hugging Face Space, etc.)?
   - [ ] Training pipeline visualization?
   - [ ] Results gallery/comparison charts?
4. Key achievements to highlight?
5. Want a "Quick Start" section for running inference?
```

### For .NET/C# Projects

```
1. Project type: [ ] Web API [ ] Web App [ ] Library [ ] Enterprise Service [ ] Other?
2. Architectural patterns used?
   - [ ] DDD [ ] CQRS [ ] Microservices [ ] Clean Architecture [ ] Event-Driven
3. Most interesting technical aspect to showcase?
4. Do you have:
   - [ ] Architecture diagrams?
   - [ ] Performance benchmarks?
   - [ ] Security/compliance highlights?
5. Target audience: [ ] Recruiters [ ] Architects [ ] Engineering Teams [ ] Other?
6. Include deployment details (Azure, Docker, etc.)?
```

### For TypeScript/Node.js Projects

```
1. Project category: [ ] API [ ] Web Framework [ ] CLI [ ] SDK [ ] Full-Stack App [ ] Other?
2. Key technical achievements:
   - [ ] Performance optimization [ ] Scalability [ ] DX improvement [ ] Novel architecture
3. Do you have:
   - [ ] Benchmark numbers?
   - [ ] Architecture diagrams?
   - [ ] Example usage code?
   - [ ] Performance comparisons?
4. Should we include:
   - [ ] Installation/setup guide?
   - [ ] API reference?
   - [ ] Example projects?
5. Does it integrate with other services? Which ones?
```

### For Full-Stack Web Apps

```
1. Frontend stack: __________ (React, Vue, Svelte, etc.)
2. Backend stack: __________ (.NET, Node, Python, Go, etc.)
3. Database(s): __________
4. Most impressive feature/achievement?
5. Do you have:
   - [ ] Screenshot/video walkthrough?
   - [ ] Architecture diagram (frontend/backend/DB)?
   - [ ] Performance metrics?
   - [ ] User/usage statistics?
6. Include live demo link or screenshots?
```

### Universal Questions

```
Always ask:
1. Primary goal for this site:
   - [ ] Get hired/showcase skills
   - [ ] Attract contributors
   - [ ] Document the project
   - [ ] Demonstrate impact
   
2. Include sections:
   - [ ] Quick Start / Installation
   - [ ] Architecture/Technical Deep-Dive
   - [ ] Features showcase
   - [ ] Live demo / Examples
   - [ ] Contributing guide
   - [ ] Metrics / Impact
   
3. Call-to-action: What do you want visitors to do?
   (Star the repo / Use the project / Contact you / Other?)
```

## Step 4: Content Gathering

### Auto-Extraction from Repository

For content already in the repo, automatically extract:

```
✓ Project description (from README)
✓ Tech stack (from package.json, *.csproj, requirements.txt)
✓ Installation/quick-start (from README or CONTRIBUTING)
✓ Architecture docs (from docs/, architecture/, or ADR files)
✓ Examples (from examples/ or demo/)
✓ Contributing guidelines (from CONTRIBUTING.md)
✓ License (from LICENSE file)
```

### User-Provided Content

For content not in repo, ask user to provide:
- Key achievements / metrics
- Project motivation / problem statement
- Architecture diagrams (if not in repo)
- Screenshots / demo links
- Performance/metrics data
- Target audience focus

## Step 5: Site Generation

### Complete GitHub Pages Repository Package

The skill generates a **complete, ready-to-deploy** GitHub Pages repository with **multi-page structure and sidebar navigation**:

```
{project}-portfolio/
├── index.html                 # Homepage with hero + sidebar nav
├── architecture.html          # Architecture & tech stack
├── features.html              # Feature showcase with images & diagrams
├── quick-start.html           # Installation & getting started guide
├── demo.html                  # Live demo/examples (if applicable)
├── css/
│   ├── style.css             # Main stylesheet (design-specific)
│   ├── variables.css          # Design system (colors, fonts, spacing)
│   └── responsive.css         # Mobile & breakpoint optimizations
├── js/
│   ├── main.js               # Navigation, sidebar toggle, smooth scroll
│   ├── diagrams.js           # Mermaid diagram initialization
│   └── syntax-highlight.js   # Code snippet syntax highlighting
├── images/
│   ├── screenshots/          # Feature/demo screenshots with annotations
│   ├── diagrams/             # Exported architecture diagrams (PNG/SVG)
│   └── assets/               # Icons, logos, project assets
├── assets/
│   └── sample-metrics.json   # Sample metrics dashboard data
├── _config.yml               # Jekyll/GitHub Pages configuration
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions auto-deploy workflow
├── .gitignore                # Standard git ignore
├── README.md                 # **Deployment & setup instructions**
├── STYLE_GUIDE.md           # **Design system documentation**
└── CUSTOMIZATION_GUIDE.md   # **Post-generation modification guide**
```

### Multi-Page Navigation Structure

All generated sites use a **sidebar navigation layout** for easy browsing:

```
┌─────────────────────────────────┐
│ Header / Logo                   │
├──────────────┬──────────────────┤
│              │                  │
│  SIDEBAR NAV │   MAIN CONTENT   │
│              │                  │
│ • Home       │                  │
│ • Arch       │  Current Page    │
│ • Features   │  (HTML Content)  │
│ • Quick Start│                  │
│ • Demo       │                  │
│              │                  │
└──────────────┴──────────────────┘

Mobile: Sidebar collapses to hamburger menu
```

### Page Templates by Design Style

**Note**: All designs use the same **multi-page sidebar navigation structure**. The difference is in colors, spacing, animations, and visual hierarchy. The sidebar markup is shared; design changes come through CSS variables.

#### Modern Minimal - Example Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{Project Name}</title>
  <link rel="stylesheet" href="css/variables.css">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <div class="page-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <a href="index.html" class="logo">{Project Name}</a>
      </div>
      <nav class="sidebar-nav">
        <a href="index.html" class="nav-item">Home</a>
        <a href="architecture.html" class="nav-item">Architecture</a>
        <a href="features.html" class="nav-item">Features</a>
        <a href="quick-start.html" class="nav-item">Quick Start</a>
        <a href="demo.html" class="nav-item">Demo</a>
        <a href="https://github.com/{repo}" class="nav-item nav-external" target="_blank">GitHub →</a>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
      <header class="page-header">
        <button class="sidebar-toggle" id="sidebarToggle">☰</button>
        <h1>{Page Title}</h1>
      </header>

      <article class="content">
        <section id="hero">
          <h2>{Section Title}</h2>
          <p>{Content}</p>
        </section>

        <section id="features">
          <h2>Key Features</h2>
          <ul>
            <li>{Feature 1}</li>
            <li>{Feature 2}</li>
            <li>{Feature 3}</li>
          </ul>
        </section>

        <section id="architecture">
          <h2>Architecture</h2>
          <p>{Architecture overview}</p>
          <div id="diagram">{Mermaid diagram}</div>
        </section>

        <section id="getting-started">
          <h2>Getting Started</h2>
          <pre><code>{Installation steps}</code></pre>
        </section>

        <section id="metrics">
          <h2>Impact Metrics</h2>
          <div class="metrics">
            <div class="metric">
              <span class="value">{Metric 1}</span>
              <span class="label">{Label 1}</span>
            </div>
            <!-- More metrics -->
          </div>
        </section>
      </article>

      <footer class="page-footer">
        <p>&copy; {Year}. <a href="https://github.com/{repo}">View on GitHub</a></p>
      </footer>
    </main>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <script src="js/main.js"></script>
  <script src="js/diagrams.js"></script>
</body>
</html>
```

#### Portfolio Heavy - Example Structure

```html
<!-- Hero with background gradient or image -->
<section id="hero" class="hero-gradient">
  <div class="hero-content">
    <h1 class="hero-title">{Project Name}</h1>
    <p class="hero-subtitle">{Compelling tagline}</p>
    <div class="hero-cta">
      <a href="#features" class="btn btn-primary">Explore</a>
      <a href="https://github.com/{repo}" class="btn btn-secondary">GitHub</a>
    </div>
  </div>
  <div class="hero-visual">
    {Screenshot or demo video}
  </div>
</section>

<!-- Stats/metrics section -->
<section id="impact" class="impact-cards">
  <h2>Impact</h2>
  <div class="cards-grid">
    <div class="card">
      <div class="stat">{Number}</div>
      <div class="stat-label">{Achievement}</div>
    </div>
    <!-- More cards -->
  </div>
</section>

<!-- Features with images -->
<section id="features" class="features-showcase">
  <h2>Features</h2>
  <div class="feature-grid">
    <div class="feature-item">
      <img src="images/feature1.png" alt="Feature 1">
      <h3>Feature Name</h3>
      <p>Description</p>
    </div>
    <!-- More features -->
  </div>
</section>

<!-- Technical deep dive -->
<section id="architecture" class="architecture">
  <h2>Architecture</h2>
  <div class="architecture-content">
    <div class="diagram-container">
      {Mermaid diagrams}
    </div>
    <div class="architecture-text">
      {Technical explanation}
    </div>
  </div>
</section>
```

#### Documentation Style - Example Structure

```html
<div class="doc-container">
  <aside class="sidebar">
    <nav class="doc-nav">
      <h3>Navigation</h3>
      <ul>
        <li><a href="#overview">Overview</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#usage">Usage</a>
          <ul>
            <li><a href="#api">API Reference</a></li>
            <li><a href="#examples">Examples</a></li>
          </ul>
        </li>
        <li><a href="#architecture">Architecture</a></li>
        <li><a href="#contributing">Contributing</a></li>
      </ul>
    </nav>
  </aside>

  <main class="doc-content">
    <section id="overview">
      <h1>{Project Name}</h1>
      <p>{Overview paragraph}</p>
    </section>

    <section id="installation">
      <h2>Installation</h2>
      <pre><code>{Installation command}</code></pre>
    </section>

    <section id="usage">
      <h2>Usage</h2>
      <!-- API docs with code examples -->
    </section>

    <section id="architecture">
      <h2>Architecture</h2>
      {Diagrams and explanations}
    </section>
  </main>
</div>
```

### Content Sections Generated

Based on user preferences and detected project type, generate:

#### Standard for All

- **Homepage**: Project intro, value proposition, quick stats, CTA
- **Architecture**: Tech stack, design decisions, system diagram
- **Quick Start**: Installation, first example, "hello world"

#### Conditional by Type

**Python/ML/Computer Vision**:
- Model Architecture section
- Results/Metrics gallery
- Demo/Inference guide
- Training pipeline overview

**.NET/C#**:
- Design Patterns Used (DDD, CQRS, etc.)
- Enterprise Features (security, scalability, monitoring)
- Deployment Guide (Azure, Docker, etc.)
- Performance Benchmarks

**TypeScript/Node.js**:
- API Reference (auto-generated from docs)
- Performance Metrics and benchmarks
- Integration Guide
- Example Projects or code samples

**Full-Stack Web Apps**:
- Feature Walkthrough with screenshots
- Architecture Diagram (frontend/backend/DB)
- Demo or Screenshots gallery
- Deployment Instructions

### Styling by Design Choice

#### Modern Minimal CSS Variables

```css
/* variables.css */
:root {
  --color-bg: #ffffff;
  --color-text: #1a1a1a;
  --color-border: #e0e0e0;
  --color-accent: #0066cc;
  --color-accent-light: #f0f7ff;
  
  --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  --font-mono: "Courier New", monospace;
  
  --spacing-xs: 0.5rem;
  --spacing-sm: 1rem;
  --spacing-md: 1.5rem;
  --spacing-lg: 2rem;
  --spacing-xl: 3rem;
  
  --max-width: 900px;
  --border-radius: 4px;
  --transition: 0.2s ease;
}

/* style.css - minimalist with sidebar */

/* Layout: Sidebar + Main Content */
body {
  font-family: var(--font-sans);
  line-height: 1.6;
  color: var(--color-text);
  background: var(--color-bg);
  margin: 0;
  padding: 0;
}

.page-wrapper {
  display: grid;
  grid-template-columns: 250px 1fr;
  min-height: 100vh;
  gap: 0;
}

.sidebar {
  background: var(--color-bg);
  border-right: 1px solid var(--color-border);
  padding: var(--spacing-lg);
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
}

.sidebar-header {
  margin-bottom: var(--spacing-lg);
}

.logo {
  display: block;
  font-size: 1.25rem;
  font-weight: 600;
  text-decoration: none;
  color: var(--color-text);
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.nav-item {
  display: block;
  padding: var(--spacing-sm) var(--spacing-md);
  text-decoration: none;
  color: var(--color-text);
  border-radius: var(--border-radius);
  transition: var(--transition);
}

.nav-item:hover {
  background: var(--color-accent-light);
  color: var(--color-accent);
}

.main-content {
  padding: var(--spacing-lg);
  overflow-y: auto;
}

.page-header {
  margin-bottom: var(--spacing-xl);
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.sidebar-toggle {
  display: none;
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
}

.content {
  max-width: 900px;
  margin: 0 auto;
}

section {
  margin-bottom: var(--spacing-xl);
  padding-bottom: var(--spacing-xl);
  border-bottom: 1px solid var(--color-border);
}

h1, h2, h3 {
  line-height: 1.2;
  margin-top: var(--spacing-lg);
  margin-bottom: var(--spacing-md);
}

code {
  background: var(--color-accent-light);
  padding: 0.2em 0.4em;
  border-radius: var(--border-radius);
  font-family: var(--font-mono);
  font-size: 0.9em;
}

pre {
  background: var(--color-accent-light);
  padding: var(--spacing-md);
  border-radius: var(--border-radius);
  overflow-x: auto;
  font-family: var(--font-mono);
}

.btn {
  display: inline-block;
  padding: var(--spacing-sm) var(--spacing-md);
  text-decoration: none;
  border-radius: var(--border-radius);
  transition: var(--transition);
}

.btn-primary {
  background: var(--color-accent);
  color: white;
}

.btn-primary:hover {
  opacity: 0.9;
}

/* Mobile: Sidebar becomes hamburger */
@media (max-width: 768px) {
  .page-wrapper {
    grid-template-columns: 1fr;
  }

  .sidebar {
    position: fixed;
    left: 0;
    top: 0;
    width: 250px;
    height: 100vh;
    z-index: 1000;
    transform: translateX(-100%);
    transition: transform var(--transition);
  }

  .sidebar.active {
    transform: translateX(0);
  }

  .sidebar-toggle {
    display: block;
  }

  .main-content {
    padding: var(--spacing-md);
  }
}

```

#### Portfolio Heavy CSS

```css
/* Rich colors, animations, gradients */
:root {
  --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 30px rgba(0,0,0,0.2);
}

.hero-gradient {
  background: var(--gradient-primary);
  color: white;
  padding: 6rem 2rem;
  text-align: center;
  animation: fadeInDown 0.6s ease;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: var(--shadow-lg);
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 40px rgba(0,0,0,0.15);
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

#### Documentation Style CSS

```css
/* Official docs look */
.doc-container {
  display: grid;
  grid-template-columns: 250px 1fr;
  gap: 2rem;
  max-width: 1400px;
  margin: 0 auto;
}

.sidebar {
  position: sticky;
  top: 20px;
  height: fit-content;
  border-right: 1px solid #e0e0e0;
  padding-right: 2rem;
}

.doc-nav ul {
  list-style: none;
  padding: 0;
}

.doc-nav a {
  display: block;
  padding: 0.5rem 0;
  color: #666;
  text-decoration: none;
  border-left: 3px solid transparent;
  padding-left: 1rem;
  transition: 0.2s;
}

.doc-nav a:hover, 
.doc-nav a.active {
  color: #0066cc;
  border-left-color: #0066cc;
}

.doc-content {
  padding: 0 2rem;
}

@media (max-width: 768px) {
  .doc-container {
    grid-template-columns: 1fr;
  }
  .sidebar {
    position: static;
    border-right: none;
    border-bottom: 1px solid #e0e0e0;
    margin-bottom: 2rem;
    padding-right: 0;
    padding-bottom: 2rem;
  }
}
```

## Step 6: Deliverables

### Generated Files Structure

```
Complete deployment package includes:

1. HTML Pages (styled, ready to render)
   ├── index.html
   ├── architecture.html
   ├── features.html (if applicable)
   ├── quick-start.html
   └── demo.html (if applicable)

2. Styling
   ├── css/variables.css (design system)
   ├── css/style.css (main styles - 500-1500 lines depending on design)
   └── css/responsive.css (mobile optimizations)

3. JavaScript
   ├── js/main.js (navigation, interactivity)
   ├── js/diagrams.js (Mermaid initialization)
   └── js/theme.js (optional: dark mode)

4. Assets
   ├── images/screenshots/ (user-provided or extracted)
   ├── images/diagrams/ (exported architecture diagrams as PNG/SVG)
   └── images/assets/ (icons, logos, etc.)

5. Configuration
   ├── _config.yml (Jekyll config for GitHub Pages)
   ├── .github/workflows/deploy.yml (auto-deploy workflow)
   └── .gitignore

6. Documentation
   ├── README.md (Deployment instructions)
   └── STYLE_GUIDE.md (Design system documentation)
```

### Package Contents

When delivering, provide:

1. **Complete Site Files** - All HTML, CSS, JS, images organized and ready to deploy
2. **GitHub Pages Repository Structure** - Ready to push to GitHub (no additional setup needed)
3. **GitHub Actions Workflow** - Automatic deployment on push to main branch
4. **Deployment Instructions** - Step-by-step guide for enabling GitHub Pages
5. **Customization Guide** - Post-generation modification instructions
6. **Design System Documentation** - Colors, fonts, spacing, variables used
7. **Asset Inventory** - List of images/diagrams needing screenshots or additional content

### Included Visual & Interactive Elements

All generated sites include:

- ✅ **Embedded Mermaid Diagrams** - Architecture, dataflow, system diagrams
- ✅ **Screenshot Gallery with Annotations** - Feature walkthroughs with labeled images
- ✅ **Live Code Snippets with Syntax Highlighting** - Installation, usage, examples
- ✅ **Embedded Live Demo** - Links to working demos, Hugging Face Spaces, or interactive sections
- ✅ **Metrics Dashboard** - Performance stats, benchmarks, usage metrics (styled cards/grid)
- ✅ **Link to Original GitHub Repository** - Prominent "View on GitHub" link throughout
- ✅ **Installation/Quick-Start Section** - Installation methods, first example, common usage patterns

## Quality Checklist

Before delivery:

- [ ] All pages render correctly and are mobile-responsive
- [ ] Navigation works across all pages
- [ ] Mermaid diagrams render properly
- [ ] Code snippets have proper syntax highlighting
- [ ] All links (internal and external) work
- [ ] Images are optimized and properly paths
- [ ] Accessibility: headings hierarchy, alt text, color contrast
- [ ] No broken references or missing assets
- [ ] Deployment instructions are clear
- [ ] Design matches chosen style (modern/portfolio/docs)
- [ ] Content is accurate and reflects repo accurately
- [ ] Call-to-action is clear and prominent

## Responsive Design Guidelines

All generated sites must be mobile-responsive:

```css
/* Breakpoints */
@media (max-width: 768px) {
  main { max-width: 100%; }
  nav { display: block; }
  .grid { grid-template-columns: 1fr; }
  h1 { font-size: 1.5rem; } /* smaller on mobile */
}

@media (max-width: 480px) {
  padding: 1rem; /* tighter spacing */
  font-size: 0.95rem;
}
```

## Diagram Generation

For architecture diagrams, generate Mermaid code and provide:

1. **Embedded Mermaid** - Direct in HTML with CDN
2. **PNG Export** - For offline viewing or embedding
3. **Source Code** - User can edit/regenerate later

Example embedded:

```html
<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
<script>
  mermaid.initialize({ startOnLoad: true, theme: 'default' });
</script>

<div class="mermaid">
  graph TB
    Client[Client] --> API[API Gateway]
    API --> Service[Service]
    Service --> DB[(Database)]
</div>
```

## Deployment Instructions

Generate clear deployment guide:

```markdown
# Deployment Guide

## Option 1: GitHub Pages (Recommended)

1. Create a new repository: `{username}.github.io` or `{project}-portfolio`
2. Copy all files from `dist/` to repository root
3. Commit and push: `git push origin main`
4. Site will be live at: `https://{username}.github.io`

## Option 2: Custom Domain

1. Add `CNAME` file with your domain
2. Configure DNS records to point to GitHub Pages
3. Update repository settings → Pages → Custom domain

## Option 3: Deploy with GitHub Actions

1. Workflow file included in `.github/workflows/deploy.yml`
2. Push to trigger automatic deployment
3. Check Actions tab for build status
```

## Examples & Templates

For each design style, keep 1-2 quick reference examples:

**Modern Minimal**: Simple, fast, scannable. Good for: libraries, CLIs, technical projects
**Portfolio Heavy**: Rich visuals, showcase-focused. Good for: apps you built, full-stack projects
**Documentation**: Official docs vibe. Good for: tools, frameworks, complex systems

## Tips for Best Results

1. **Provide repo access**: Cloning allows extraction of more context
2. **Include metrics**: Performance numbers, download stats, adoption metrics
3. **Supply screenshots**: Visual assets make huge difference (5-10 good screenshots)
4. **Describe the "why"**: Problem statement resonates more than just feature list
5. **Clarify target audience**: Different people care about different aspects
6. **Mention what's hard**: Challenges overcome often more interesting than easy parts

## Common Customizations

After generation, users may want to:

- **Change colors**: Edit `css/variables.css` color values
- **Add/remove sections**: Modify HTML, keep CSS structure
- **Add more pages**: Duplicate page template, update nav
- **Optimize images**: Compress and replace files in `images/`
- **Update content**: Edit text directly in HTML
- **Change font**: Update `--font-sans` in CSS variables

Include guidance for each in the customization guide.
