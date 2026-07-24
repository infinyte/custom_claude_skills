# Prompt Engineering Reference Guide

Advanced techniques and pattern library for the prompt-architect skill.
Read this file when generating complex prompts or when the user requests specific techniques.

---

## Table of Contents

1. [System Prompt Patterns](#1-system-prompt-patterns)
2. [Agent / Automation Patterns](#2-agent--automation-patterns)
3. [Image Generation Patterns](#3-image-generation-patterns)
4. [Advanced Techniques](#4-advanced-techniques)
5. [Few-Shot Example Formatting](#5-few-shot-example-formatting)
6. [Anti-Patterns to Avoid](#6-anti-patterns-to-avoid)

---

## 1. System Prompt Patterns

### Basic Persona System Prompt
Best for: chatbots, assistants, customer-facing agents

```
You are [Name], a [role] for [company/product].

Your primary goal is to [core objective].

Tone: [adjective], [adjective], [adjective]

When asked about [topic], always [specific behavior].
When you don't know something, [fallback behavior].
Never [hard constraint].
```

### Capability-Scoped System Prompt
Best for: narrow-purpose assistants (code review bot, support agent, etc.)

```
You are a [role]. You help users with [scope].

You are NOT designed to help with [out-of-scope list]. If asked about these, politely redirect to [resource].

Core behaviors:
1. [Behavior 1]
2. [Behavior 2]
3. [Behavior 3]

Response format: [specification]
Response length: [guideline]
```

### Structured XML System Prompt (Claude-optimized)
Best for: complex assistants with multiple operational modes

```xml
<system>
  <role>[role description]</role>
  <objective>[primary objective]</objective>
  
  <behaviors>
    <behavior name="[name]">[description]</behavior>
    <behavior name="[name]">[description]</behavior>
  </behaviors>
  
  <constraints>
    <hard>[constraint that cannot be broken]</hard>
    <soft>[preference that can be overridden with context]</soft>
  </constraints>
  
  <output_format>[format specification]</output_format>
</system>
```

---

## 2. Agent / Automation Patterns

### ReAct Pattern (Reason + Act)
Best for: agents that need to reason before taking actions

```
You are an agent that solves tasks using available tools.

For each task, follow this pattern:
Thought: [reason about what to do next]
Action: [tool name]
Action Input: [input to the tool]
Observation: [result of the action]
... (repeat as needed)
Thought: I have enough information to answer.
Final Answer: [your response]

Available tools:
- [tool_name]: [description of what it does and when to use it]
- [tool_name]: [description]

Task: {task}
```

### Step-Decomposition Agent Prompt
Best for: multi-step workflows where the steps are known

```
## Objective
[What the agent must accomplish]

## Available Tools
| Tool | When to Use |
|------|-------------|
| [tool] | [condition] |
| [tool] | [condition] |

## Process
Execute the following steps in order. Do not skip steps.

1. **[Step Name]** — [what to do] → Output: [what to produce]
2. **[Step Name]** — [what to do] → Output: [what to produce]
3. **[Step Name]** — [what to do] → Output: [what to produce]

## Completion Criteria
The task is complete when: [condition]

## Error Handling
If [error condition], then [recovery action].
```

### Tool-Use Scaffolded Prompt
Best for: agents with specific tool call requirements

```
You have access to the following tools: [list tools]

Rules for tool use:
- Always call [tool] before [action] to verify [condition]
- Never call [tool] and [tool] in the same turn
- If a tool returns an error, [recovery behavior]

Format all tool calls as:
<tool_call>
  <name>[tool_name]</name>
  <parameters>[JSON parameters]</parameters>
</tool_call>
```

---

## 3. Image Generation Patterns

### Structure for Image Gen Prompts
```
[Subject/focal point], [action or state], [setting/environment], [artistic style or medium], [lighting description], [color palette or mood], [composition notes], [quality/technical modifiers]
```

### Style Vocabulary Reference

**Art Styles:**
`photorealistic`, `hyperrealistic`, `oil painting`, `watercolor`, `digital art`, `concept art`, `illustration`, `anime`, `Studio Ghibli style`, `cinematic`, `editorial photography`, `architectural rendering`

**Lighting:**
`golden hour lighting`, `soft diffused light`, `dramatic side lighting`, `neon-lit`, `candlelit`, `overcast natural light`, `studio lighting`, `volumetric light rays`

**Composition:**
`close-up portrait`, `wide establishing shot`, `bird's eye view`, `low angle`, `rule of thirds`, `symmetrical composition`, `bokeh background`, `shallow depth of field`

**Quality Modifiers (Midjourney / DALL-E):**
`highly detailed`, `8k resolution`, `sharp focus`, `award-winning photography`, `trending on ArtStation`, `--ar 16:9`, `--style raw`, `--v 6`

### Negative Prompt Pattern (Stable Diffusion / some models)
```
Prompt: [positive description]
Negative: [things to exclude: blurry, deformed, extra limbs, watermark, text, low quality]
```

---

## 4. Advanced Techniques

### Chain-of-Thought (CoT) Injection
Force step-by-step reasoning before the final answer.

```
Before answering, think through the problem step by step inside <thinking> tags. 
Then provide your final answer inside <answer> tags.

<thinking>
[model reasons here]
</thinking>

<answer>
[final response]
</answer>
```

### Self-Critique / Reflection Loop
Prompts the model to review its own output before finalizing.

```
After generating your initial response, review it using these criteria:
1. Does it fully address the request?
2. Are there any factual errors or gaps?
3. Is the format correct?

If any criterion fails, revise your response. Output only the final revised version.
```

### Persona Chaining (for role-play or expert simulation)
```
You will take on the perspective of [Expert Role].

As [Expert Role], you have [years] of experience in [domain]. 
You think about problems by [characteristic reasoning style].
Your communication style is [tone/format].

When answering, cite [relevant frameworks/methodologies] where applicable.
```

### Constrained Output Format (JSON/Structured Data)
```
Respond ONLY with a valid JSON object. Do not include preamble, explanation, or markdown fences.

Schema:
{
  "[field]": "[type] — [description]",
  "[field]": "[type] — [description]"
}
```

### Few-Shot with Rationale
Provides examples with explicit reasoning to shape behavior.

```
Here are examples of the task. Each includes the input, the reasoning, and the expected output.

Example 1:
Input: [example input]
Reasoning: [why the output takes this form]
Output: [example output]

Example 2:
Input: [example input]
Reasoning: [why the output takes this form]
Output: [example output]

Now complete:
Input: {input}
Reasoning:
Output:
```

---

## 5. Few-Shot Example Formatting

### When to include few-shot examples
- The task has a non-obvious output format
- Tone or style needs precise calibration
- The task is complex and benefits from worked examples
- The model has shown inconsistency without examples

### Formatting rules
- Use **2–5 examples** (1 is often insufficient; more than 5 can dominate the context)
- Keep examples **representative but not exhaustive**
- Include at least **one edge case** in the example set
- Separate examples clearly with `---` or numbered headers
- Place examples **before** the actual task instruction

---

## 6. Anti-Patterns to Avoid

| Anti-Pattern | Problem | Fix |
|---|---|---|
| "Be helpful and accurate" | Too vague — every model already tries this | Specify *how* to be helpful in this context |
| Negation-only constraints ("Don't be rude") | Models respond poorly to pure negation | Pair with positive replacement ("Be courteous and professional") |
| Overcrowded single paragraph | Hard for the model to parse priorities | Use numbered lists, headers, or XML sections |
| Asking the model to "try its best" | Adds noise without changing behavior | Remove; just give the instruction |
| Ambiguous pronouns ("it", "this", "they") | Creates ambiguity in multi-entity prompts | Be explicit with noun references |
| Role labels without behaviors ("You are an expert") | Title without instruction doesn't constrain output | Add specific behaviors that characterize the expert |
| Conflicting instructions | Model may arbitrarily satisfy one and ignore the other | Explicitly prioritize: "If X and Y conflict, prefer X" |
