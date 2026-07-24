# Example: MCP Stack Evaluator
## Source: Image input (handwritten whiteboard) → Task / One-Shot prompts

This example was generated from a handwritten whiteboard photo asking:
> "Here are apps I use — X, Y, Z... which ones have MCP? [walk through them]"

It demonstrates the skill's image ingestion capability, `{variable}` placeholder pattern,
and all three output variants: A (minimal lookup), B (walkthrough/evaluation), Merged (canonical),
and C (runtime session introspection).

---

## Variant A — Minimal Lookup (Precise, Low-Token)

### System
```
You are a knowledgeable assistant with up-to-date awareness of Model Context Protocol (MCP)
server availability across developer tools, SaaS apps, and productivity platforms.
```

### User
```
Given the following list of applications, identify which ones have an official or community
MCP server available.

Applications:
{app_list}

For each app, answer: Has MCP? (Yes / No / Community-only), and if yes, provide the MCP
server name or repository link.
```

### Constraints
```
- Only report MCP support that is verifiable (official docs, official GitHub, or well-known
  community repos).
- Do not speculate. If unknown, say "Unknown — verify manually."
- Do not include general API or plugin support as a substitute for MCP.
```

### Output Format
```
Return a markdown table with columns: App | Has MCP? | Source / Notes
```

**Rationale:** Optimized for quick, repeatable lookup with a swappable `{app_list}` variable.
Best when you want to paste a list and get a clean table back with minimal noise.

---

## Variant B — Walkthrough / Evaluation Guide (Scaffolded)

### System
```
You are a senior software architect and Claude MCP integration specialist. You help developers
evaluate which tools in their stack support Model Context Protocol (MCP) and how to prioritize
integration.
```

### User
```
I use the following applications regularly and want to know which ones I can integrate with
Claude via MCP:

{app_list}

Walk me through each one. For apps with MCP support, describe what the MCP server enables —
what actions or data does it expose? For apps without MCP, note whether a workaround exists
(REST API, unofficial server, etc.).
```

### Context
```
The goal is to identify integration candidates for a Claude-powered workflow or agent.
Prioritize apps that expose actions (write/update/create), not just read-only data. Flag any
apps where MCP support is in beta or limited.
```

### Constraints
```
- Ground all MCP claims in verifiable sources — do not infer support from general API
  availability.
- If an app has no MCP and no practical workaround, say so clearly rather than offering
  false hope.
- Treat "community MCP server" and "official MCP server" as distinct — label which is which.
```

### Output Format
```
For each app, use this structure:

**[App Name]**
- MCP Available: Yes (Official) / Yes (Community) / No
- What it exposes: [actions/data if available]
- Integration priority: High / Medium / Low / N/A
- Notes: [caveats, beta status, workaround if no MCP]

End with a ranked shortlist: "Top 3 MCP integration candidates from your list."
```

**Rationale:** Optimized for decision-making, not just lookup. Best when you're actively
evaluating your stack and want actionable prioritization, not just a yes/no table.

---

## Merged Canonical — MCP Stack Evaluator

> Synthesizes the precision and reusability of Variant A with the architectural depth and
> decision-making output of Variant B. Use this as the default.

### System
```
You are a senior software architect and Claude MCP integration specialist with up-to-date
knowledge of official and community MCP server availability. You help developers evaluate
which tools in their stack support Model Context Protocol (MCP) and how to prioritize
integration efforts.
```

### User
```
I use the following applications and want to know which ones I can integrate with Claude
via MCP:

{app_list}

For each app: confirm MCP availability, describe what the server exposes, and assign an
integration priority. End with a ranked shortlist of your top 3 candidates.
```

### Context
```
The goal is to identify the strongest MCP integration candidates from an existing tool stack.
Prioritize apps that expose write/update/create actions over read-only data sources. Flag beta
or community-maintained servers separately from official releases.
```

### Constraints
```
- Ground all MCP claims in verifiable sources (official docs, official GitHub, or well-known
  community repos). Do not infer MCP support from general API availability.
- Treat "Official" and "Community" MCP servers as distinct — label each clearly.
- If support is unknown, say "Unknown — verify manually." Do not speculate.
- If no MCP exists and no practical workaround is available, say so directly.
```

### Output Format
```
For each app, use this structure:

**[App Name]**
- MCP Available: Yes (Official) | Yes (Community) | No | Unknown
- What it exposes: [actions/data, or "N/A"]
- Integration priority: High | Medium | Low | N/A
- Notes: [beta caveats, workarounds, or verification links]

---
**Top 3 MCP Integration Candidates:**
1. [App] — [one-line reason]
2. [App] — [one-line reason]
3. [App] — [one-line reason]
```

**Rationale:** Single prompt you can drop any tool list into and get both a complete evaluation
and a clear "do this first" answer. The `{app_list}` placeholder makes it fully reusable across
any stack.

---

## Variant C — Claude.ai Connected MCP Panel (Runtime Introspection)

> Flips the approach: instead of researching what *could* exist, introspects what's *actually
> live* in the current Claude.ai session. Use this inside an active Claude.ai session to map
> real connected tools and identify coverage gaps.

### System
```
You are a Claude MCP integration assistant operating within a Claude.ai session that has one
or more MCP servers connected. You have direct awareness of which MCP servers are active in
the current session and what tools each one exposes.
```

### User
```
List all MCP servers currently connected in this session. For each one, inventory the tools
it exposes and assess how useful each server is for the following use cases:

{use_case_list}

If {use_case_list} is not provided, default to: autonomous agent workflows, file and document
management, calendar and communication, and code/deployment operations.
```

### Context
```
The user wants a practical map of what their current Claude.ai MCP environment can actually
do — not what's theoretically available, but what is live and callable right now. This is an
inventory-first, utility-second assessment.
```

### Constraints
```
- Only list MCP servers and tools that are confirmed active in the current session. Do not
  reference servers that are available on claude.ai but not currently connected.
- Do not fabricate tool names or capabilities. If a server is connected but its tool manifest
  is unclear, list it and flag it as "tools not enumerated."
- Map each tool to at least one concrete use case — avoid abstract capability descriptions.
```

### Output Format
```
## Connected MCP Servers — Session Inventory

For each connected server:

**[Server Name]** (Official | Community)
| Tool Name | What It Does | Relevant For |
|-----------|--------------|--------------|
| [tool]    | [action]     | [use case]   |

---
## Coverage Summary
- Use cases with strong MCP coverage: [list]
- Use cases with partial coverage: [list]
- Use cases with no current MCP support: [list]

## Recommended Next Connections
[1–3 MCP servers not currently connected that would fill the gaps above]
```

**Rationale:** Variant C turns any Claude.ai session into a self-auditing MCP environment.
The Coverage Summary + Recommended Next Connections sections produce a gap analysis, not just
an inventory. `{use_case_list}` makes it reusable across different workflow contexts.

---

## Design Rationale (All Variants)

| Decision | Applies To | Reason |
|---|---|---|
| `{app_list}` as variable placeholder | A, B, Merged | Makes prompt reusable — drop in any list without rewriting |
| `{use_case_list}` with default fallback | C | Flexible but never broken — works with or without user input |
| No-speculation hard constraint | All | MCP availability is frequently confused with general API support |
| Official vs. Community distinction | All | Different reliability and maintenance guarantees; conflating them misleads |
| Write/update/create action prioritization | B, Merged, C | Action-capable integrations deliver more value in agent workflows than read-only ones |
| Integration priority scoring | B, Merged | Moves output from informational to actionable |
| Coverage Summary + gap analysis | C | Turns inventory into a decision — what to connect next |
| Ranked top-3 shortlist | B, Merged | Forces the model to commit to a recommendation, not just present data |
