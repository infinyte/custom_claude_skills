# Report Template

The shareable report reproduces a review that already happened — it's a formatting pass, not a
re-analysis. Don't re-derive findings while building it; pull them from the conversation and lay
them out according to this spec so reports stay consistent from one review to the next, whoever's
running the skill.

This file covers, in order: the section spec, the issues-table schema, the styling tokens, how to
build the HTML, how to get a PDF out of it, the single-lens and Devil's-Advocate-only variations,
and the branding hook.

---

## 1. Section spec

Build the report with these sections, in this order. Each maps directly to a pass that already
ran — don't add content that wasn't part of the conversation.

1. **Header** — artifact name/URL, review date, calibration band chosen (throwaway / greenfield /
   production / mature — see Proportionality in SKILL.md), and which mode produced the report
   (full four-pass review, or single-lens — see §5).
2. **Summary** — 3-5 sentences: what was reviewed, the overall verdict, and a one-line guide to
   the sections below ("Jump to the issues table for the short version").
3. **Feynman Check** — the plain-language explanation and the list of comprehension
   gaps/design murk, exactly as delivered in the conversation.
4. **Architect Lens** — findings as delivered, with their blast-radius/reversibility framing
   intact. This section is allowed to look different from the Engineer section — don't normalize
   the voices in the report; that would defeat the point of running four lenses.
5. **Engineer Lens** — findings as delivered, `will break` / `will bite` / `will annoy` tags
   visible.
6. **Devil's Advocate** — the full teardown, **labeled as uncalibrated** (a short note at the top
   of this section: "Deliberately overstated — see Synthesis for the calibrated version"). Never
   quietly soften this section's tone when transcribing it; the recalibration belongs in Synthesis,
   not here.
7. **Synthesis** — the reconciled, ranked view: agreements, collisions (with both sides named),
   and the recalibrated Devil's Advocate findings. This is "what's actually true," and it's what
   most readers will act on.
8. **Issues Table** — see §2. This is the scannable version of the Synthesis ranking.
9. **Footer** — calibration note, generation timestamp, and the branding hook (§6) if configured.

## 2. Issues-table schema

One row per finding that survived Synthesis (i.e., every item in the final ranked list — dropped
Devil's-Advocate theater doesn't get a row). Exactly these four columns, in this order:

| Column | Content |
|---|---|
| **#** | Rank, matching the Synthesis order (highest Impact × lowest Effort first) |
| **Severity** | The translated Impact band — `High` / `Medium` / `Low` — as a colored badge, not raw lens language |
| **Issue summary** | One sentence, specific (file/function/section named where applicable) |
| **Suggested fix** | One sentence, actionable — what "done right" looks like |

Keep it to four columns. It's tempting to add Effort, Confidence, or "raised by" as extra columns
— resist it in the table itself; that detail lives in the Synthesis prose directly above the
table, which readers hit first. A table that's trying to show six variables stops being scannable,
which defeats the reason it exists.

Sort order: Impact (High → Low) first, Effort (Low → High) second, matching Synthesis Job 3.

## 3. Styling tokens

If the `frontend-design` skill (or an equivalent design-system skill) is available in the current
environment, prefer its tokens and typography for brand consistency with the rest of the user's
output. Otherwise — and this is the common case, since this skill should produce a good report
with nothing else installed — use these self-contained defaults. They're deliberately plain:
readable, accessible, and unopinionated enough to not clash with a company brand pasted on top via
the branding hook (§6).

```css
:root {
  /* Neutrals */
  --fpr-bg: #ffffff;
  --fpr-bg-subtle: #f6f7f9;
  --fpr-border: #e2e5ea;
  --fpr-text: #1a1d23;
  --fpr-text-muted: #5b6270;

  /* Severity — pick for contrast, not decoration; each pairs with a dark text color at ≥4.5:1 */
  --fpr-high-bg: #fdecec;
  --fpr-high-border: #e0393e;
  --fpr-high-text: #8a1c1f;

  --fpr-medium-bg: #fef6e7;
  --fpr-medium-border: #d99a1b;
  --fpr-medium-text: #7a5108;

  --fpr-low-bg: #eef6ee;
  --fpr-low-border: #4f9a5b;
  --fpr-low-text: #275a30;

  /* Lens accent colors — used only as thin left-border accents on each section, not backgrounds */
  --fpr-feynman: #6b5bd6;
  --fpr-architect: #1f6f9c;
  --fpr-engineer: #2f7d5a;
  --fpr-devil: #b23a3a;

  /* Type */
  --fpr-font-body: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  --fpr-font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace;
  --fpr-size-base: 16px;
  --fpr-size-h1: 1.75rem;
  --fpr-size-h2: 1.35rem;
  --fpr-size-h3: 1.1rem;
  --fpr-line-height: 1.55;

  /* Spacing */
  --fpr-space-sm: 0.5rem;
  --fpr-space-md: 1rem;
  --fpr-space-lg: 2rem;
  --fpr-radius: 6px;
}
```

Severity badges use the `--fpr-{band}-bg` / `-border` / `-text` triads. Lens section headers get a
4px left border in their accent color so the eye can jump between lenses without re-reading
labels. Don't use the lens accent colors for body text — accent-on-white body copy fails contrast
at small sizes; reserve them for borders, badges, and headings only.

## 4. Building the HTML

Produce a single self-contained file — no external stylesheets, no CDN fonts, no separate JS
file. Structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Feynman Peer Review — {{ARTIFACT_NAME}}</title>
  <style>
    /* tokens from §3, plus layout rules below */
    body { font-family: var(--fpr-font-body); font-size: var(--fpr-size-base);
           line-height: var(--fpr-line-height); color: var(--fpr-text);
           background: var(--fpr-bg); max-width: 860px; margin: 0 auto;
           padding: var(--fpr-space-lg) var(--fpr-space-md); }
    section { margin-bottom: var(--fpr-space-lg); }
    section.lens { border-left: 4px solid var(--fpr-border); padding-left: var(--fpr-space-md); }
    section.lens.feynman   { border-color: var(--fpr-feynman); }
    section.lens.architect { border-color: var(--fpr-architect); }
    section.lens.engineer  { border-color: var(--fpr-engineer); }
    section.lens.devil     { border-color: var(--fpr-devil); }
    .badge { display: inline-block; padding: 0.15em 0.6em; border-radius: 999px;
             font-size: 0.85em; font-weight: 600; border: 1px solid; }
    .badge.high   { background: var(--fpr-high-bg);   border-color: var(--fpr-high-border);   color: var(--fpr-high-text); }
    .badge.medium { background: var(--fpr-medium-bg); border-color: var(--fpr-medium-border); color: var(--fpr-medium-text); }
    .badge.low    { background: var(--fpr-low-bg);    border-color: var(--fpr-low-border);    color: var(--fpr-low-text); }
    table.issues { width: 100%; border-collapse: collapse; }
    table.issues th, table.issues td { text-align: left; padding: var(--fpr-space-sm);
                                        border-bottom: 1px solid var(--fpr-border); vertical-align: top; }
    table.issues th { background: var(--fpr-bg-subtle); }
    .devil-notice { background: var(--fpr-bg-subtle); border: 1px dashed var(--fpr-border);
                    padding: var(--fpr-space-sm) var(--fpr-space-md); border-radius: var(--fpr-radius);
                    font-size: 0.9em; margin-bottom: var(--fpr-space-md); }
    @media print {
      body { max-width: none; }
      section { page-break-inside: avoid; }
      a[href]::after { content: " (" attr(href) ")"; font-size: 0.8em; color: var(--fpr-text-muted); }
    }
  </style>
</head>
<body>
  <!-- Header, Summary, four lens sections (each section.lens.{name}), Synthesis, Issues table, Footer -->
</body>
</html>
```

Keep the DOM plain — headings, paragraphs, a definition list or table for the Severity Bridge
translations if you want to show them, and the one issues table. No JS is needed; this is a
document, not an app. The `@media print` block above is what makes the PDF step (§5) trivial: the
same file *is* the print layout, just triggered differently.

## 5. Getting a PDF

Two acceptable paths, in order of preference:

1. **If a PDF-generation skill or tool is available** (e.g. a `pdf` skill, a headless-Chromium
   print-to-PDF utility, or an equivalent already in the environment), render the HTML file from
   §4 straight through it. The `@media print` rules already handle pagination and link visibility
   — no separate PDF-specific markup needed.
2. **If nothing like that is available**, deliver the HTML file and tell the person plainly: open
   it in a browser and use its native "Print → Save as PDF," which will pick up the same
   `@media print` styling. This is a completely normal fallback, not a degraded one — say so
   rather than apologizing for it.

Never hand-roll a second, separate PDF template — one HTML source, two output paths.

## 6. Single-lens and Devil's-Advocate-only report variations

When the report is built from a Single-Lens Mode run (see SKILL.md), it's shorter, not
lower-effort — apply the same care to formatting.

**Architect-only or Engineer-only report:**
- Header + Summary, sized to the single lens actually run.
- The one lens section, in full.
- A short "Impact × Effort" list (from the Severity Bridge translation the skill already produced)
  in place of a full Synthesis — no ranked-against-other-lenses framing, since there's nothing to
  rank it against.
- The four-column issues table still applies, but drop the word "Synthesis" from any heading —
  use "Findings" instead, since nothing was synthesized across lenses.

**Devil's-Advocate-only report:**
- A prominent banner at the very top of the document (not just the section header) stating this is
  an uncalibrated stress test: *"This report reflects the Devil's Advocate pass only. Severities
  are intentionally overstated and have not been cross-checked against a fair lens. Treat this as
  a worst-case scan, not a prioritized action list."*
- Reuse the `devil-notice` style from §4 for this banner, but larger and above the header.
- **No issues table.** The four-column table implies a calibrated, ranked list — building one here
  would misrepresent uncalibrated findings as prioritized ones. List the findings as prose or a
  simple bulleted teardown instead, exactly as delivered.
- Close with a one-line offer: adding an Architect or Engineer pass would allow a calibrated,
  ranked version of this report.

## 7. Branding hook

Reports often go to another developer, a PR, or leadership — sometimes under a company's visual
identity. Before generating the HTML, check whether a brand-guidelines or brand-spec skill is
present in the environment (for example, one that defines a company's colors, fonts, and logo
usage). If one is found and the person hasn't said otherwise, apply it: swap the `--fpr-*` color
and font tokens in §3 for the brand's equivalents, and place the brand's logo in the header
section defined in §1. Keep the severity-badge colors (`--fpr-high-*` / `-medium-*` / `-low-*`)
functional even under a brand override — contrast and immediate recognizability matter more here
than palette purity, so don't force severity badges into brand colors that don't clearly separate
High from Medium from Low at a glance.

If no branding skill is present and the person hasn't specified a brand, use the plain defaults
from §3 as-is — don't invent a color scheme.
