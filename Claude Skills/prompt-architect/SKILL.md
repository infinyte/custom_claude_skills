---
name: prompt-architect
description: >
  Transforms any combination of inputs — text descriptions, uploaded images, uploaded files (PDF, DOCX, code, etc.) — into a high-quality, reusable prompt optimized for a specified target (Claude system prompt, autonomous agent instruction, image generation prompt, or general-purpose LLM task prompt). Use this skill whenever the user wants to generate, engineer, or craft a prompt from scratch, refine an existing prompt, capture intent as a reusable prompt, or convert a description/mockup/document into a structured prompt. Trigger on phrases like "make me a prompt", "generate a prompt for", "turn this into a prompt", "write a system prompt", "create a prompt from this image/file", "prompt for my agent", or any request where the output is a prompt to be used later. Always use this skill even if the user just says "prompt" with a description attached.
---

# Prompt Architect

Transforms any input — text, images, or files — into a polished, reusable prompt optimized for a specified downstream target.

---

## Workflow Overview

```
1. Ingest & Classify Input
2. Infer Prompt Type (or ask if ambiguous)
3. Extract Intent & Constraints
4. Generate Prompt
5. Present Prompt + Design Rationale
6. Offer Refinement Loop
```

---

## Step 1 — Ingest & Classify Input

Accept any combination of the following input modalities:

| Input Type | How to Process |
|---|---|
| **Freeform text** | Parse for intent, constraints, tone, audience, and domain |
| **Uploaded image** | Analyze visually — extract layout, structure, labels, UI elements, content, style |
| **PDF / DOCX** | Extract and summarize key content, structure, and requirements |
| **Code file** | Identify language, purpose, patterns, and what a prompt would need to instruct |
| **Mixed inputs** | Synthesize all inputs; images/files provide concrete grounding for text intent |

> **If no file-reading tool is available**, fall back to asking the user to paste/describe the file contents.

---

## Step 2 — Infer Prompt Type

Determine the intended downstream use from context. If ambiguous, ask **one targeted question** only.

| Prompt Type | Signals in Input |
|---|---|
| **System Prompt** | "assistant", "Claude", "chatbot", "persona", "role", "always respond as" |
| **Agent / Automation Prompt** | "agent", "tool use", "step by step", "task", "workflow", "autonomous" |
| **Image Generation Prompt** | "image", "generate art", "Midjourney", "DALL-E", "Stable Diffusion", visual description |
| **Task / One-Shot Prompt** | Everything else — a reusable instruction for a specific task |

---

## Step 3 — Extract Intent & Constraints

Before generating, identify the following from the input. Missing items can be inferred or prompted:

### Required (always extract)
- **Core task** — What should the prompt cause the model/tool to do?
- **Target audience** — Who or what will use this prompt?
- **Output format** — What should the result look like?

### Optional but important
- **Tone/persona** — Professional, casual, authoritative, concise, verbose?
- **Domain/context** — Industry, product, technical area
- **Constraints** — Things the prompt should explicitly avoid or enforce
- **Examples** — Any provided or inferable few-shot examples
- **Scope boundaries** — What is explicitly out of scope?

### Adaptive Clarification Rule
- If **2 or fewer** of the Required fields are determinable from input → ask **one grouped clarifying question** before proceeding
- If **all 3 Required fields** are determinable → proceed directly to generation

---

## Step 4 — Generate the Prompt

Apply prompt engineering best practices appropriate to the target type. See `references/prompt-engineering-guide.md` for detailed patterns per type.

### Universal Principles (apply to all types)
- Use **clear, imperative language** — direct instructions outperform vague descriptions
- **Lead with role/context** when the output benefits from a persona
- **Separate concerns** — context, instructions, constraints, format as distinct blocks
- Use **XML tags** (`<context>`, `<instructions>`, `<constraints>`, `<format>`) for complex prompts
- Avoid negations-only constraints — pair each "do not" with a "do instead"
- Include **output format specification** unless format is irrelevant
- For multi-step tasks, use **numbered steps** or explicit sequencing language

### Prompt Type Patterns

#### System Prompt
```
You are [role description].

Your responsibilities:
- [primary responsibility]
- [secondary responsibility]

Constraints:
- [hard constraint]
- [soft preference]

When responding, always [behavior]. When asked about [edge case], [how to handle it].
```

#### Agent / Automation Prompt
```
## Task
[Clear description of the task objective]

## Context
[Relevant background the agent needs]

## Instructions
1. [Step one]
2. [Step two]
3. [Step three — include decision points]

## Constraints
- [Constraint 1]
- [Constraint 2]

## Output Format
[Specify structure, length, schema if applicable]
```

#### Image Generation Prompt
```
[Subject], [style/medium], [composition], [lighting], [color palette], [mood/atmosphere], [technical parameters if applicable]
```

#### Task / One-Shot Prompt
```
[Context setup — what the model needs to know]

[Clear instruction — what to do]

[Format specification — how to return the result]
```

---

## Step 5 — Present the Output

Always generate **two variants** for every request. Variants differ in structural approach, not just wording — each should reflect a meaningfully different strategy (e.g., concise vs. explicit, directive vs. contextual, flat vs. XML-sectioned). Both use the same labeled-section format.

### Variant Strategies by Prompt Type

| Prompt Type | Variant A | Variant B |
|---|---|---|
| **System Prompt** | Role-first, behavior-driven (imperative list) | Context-first, XML-sectioned (Claude-optimized) |
| **Agent / Automation** | Step-decomposition (numbered, deterministic) | ReAct / reasoning-first (think → act pattern) |
| **Task / One-Shot** | Minimal + precise (fewest tokens that work) | Scaffolded (context + instruction + format spelled out) |
| **General-purpose** | Infer best two structural strategies from intent | — |

### Output Format Template

````
**Prompt type detected:** [System Prompt / Agent / Task / Image Gen]
**Inputs used:** [Text description / Image analysis / File: filename.ext]

---

## Variant A — [Strategy Label, e.g. "Role-First Directive"]

### System
```
[system-level instruction or persona]
```

### User
```
[the user turn / task instruction the prompt will receive]
```

### Context
```
[background, domain knowledge, or grounding the model needs]
```

### Constraints
```
[explicit do/don't rules — always pair negations with positive replacements]
```

### Output Format
```
[format specification: structure, length, schema, tone]
```

**Rationale:** [1–2 sentence explanation of what this variant optimizes for and when to prefer it]

---

## Variant B — [Strategy Label, e.g. "XML-Sectioned Context-First"]

### System
```
[system-level instruction or persona]
```

### User
```
[the user turn / task instruction]
```

### Context
```
[background or grounding]
```

### Constraints
```
[do/don't rules]
```

### Output Format
```
[format specification]
```

**Rationale:** [1–2 sentence explanation of what this variant optimizes for and when to prefer it]

---

## Design Rationale

| Decision | Applies To | Reason |
|---|---|---|
| [Design choice] | Both / Variant A / Variant B | [Why this choice was made] |
| [Design choice] | Both / Variant A / Variant B | [What it enables or prevents] |
````

> **Section omission rule:** If a section (e.g., `Context` or `User`) is not meaningful for a given prompt type, omit it rather than leaving it empty or placeholder-filled. Always include at minimum: `System`, `Constraints`, and `Output Format`.

---

## Step 6 — Refinement Loop

After presenting both variants, close with a single short offer:

> "Want me to merge the best parts of both, adjust a specific section, add few-shot examples, or generate a third variant with a different approach?"

Support the following refinement commands:
- `"merge"` / `"combine A and B"` → synthesize the strongest elements of both into one canonical prompt
- `"make it stricter"` / `"loosen it up"` → adjust constraint density across both or a named variant
- `"shorter"` / `"more detailed"` → compress or expand; apply to both unless variant is specified
- `"add examples"` → inject 1–3 few-shot examples into the User section of both variants
- `"third variant"` → generate a Variant C with a structurally distinct approach not yet used
- `"add XML tags"` → restructure the named variant using full Claude-optimized XML formatting
- `"explain the difference"` → describe in plain language what each variant prioritizes and the tradeoffs

---

## Edge Cases & Handling

| Situation | Behavior |
|---|---|
| Input is an existing prompt to improve | Analyze weaknesses, rewrite, and explain changes in rationale table |
| Input is vague (1–2 words only) | Ask one grouped clarifying question covering type + goal + audience |
| Input contains multiple conflicting intents | Flag the conflict, propose the most likely resolution, offer alternatives |
| Image input with no text | Analyze image, infer intent (e.g., UI mockup → system prompt for an assistant), confirm interpretation before generating |
| File too large to process in full | Summarize extractable content, flag what was skipped, note any gaps |
| User asks for multiple prompt types from one input | Generate all requested types in sequence, each with its own rationale block |

---

## Reference Files

- `references/prompt-engineering-guide.md` — Detailed pattern library for each prompt type, including advanced techniques (chain-of-thought injection, self-critique loops, tool-use scaffolding, few-shot formatting)

Read this when:
- The target is an agent prompt with complex tool use
- The user asks for advanced techniques (CoT, reflection, ReAct pattern)
- You're generating an image prompt and need style/composition vocabulary

## Bundled Examples

- `examples/mcp-stack-evaluator.md` — Full worked example generated from an image input (handwritten whiteboard). Demonstrates: image ingestion, `{variable}` placeholder pattern, Variant A (minimal lookup), Variant B (walkthrough/evaluation), Merged Canonical, and Variant C (Claude.ai runtime session introspection).

Read this when:
- The user asks about MCP tool availability across their app stack
- You need a reference for how the multi-variant output format should look end-to-end
- The user provides an image with no text and you need a model for how to handle intent inference
