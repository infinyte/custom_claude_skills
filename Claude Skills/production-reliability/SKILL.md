---
name: production-reliability
description: >
  Applies Michael Nygard's Release It! discipline when building or reviewing services, APIs,
  jobs, or queues that must survive production failure: put explicit timeouts on outbound
  calls, retry only when safe and bounded, isolate failures with circuit breakers and
  bulkheads, design overload behavior with backpressure and load shedding, and build in
  observability at every boundary. Use whenever the user is building a production service,
  reviewing something before it ships, adding a dependency call, queue, or background job, or
  investigating a production incident. Trigger on phrases like "is this production ready",
  "what happens if this dependency is slow", "add a retry", or "this needs to survive an
  outage". Distilled from Nygard's book via the agent-rules-books project (MIT licensed);
  references/full-reference.md carries the complete rule set for deep audits.
metadata:
  version: 1.0.0
---

# Production Reliability

## Purpose

This skill applies the discipline of Michael T. Nygard's *Release It!*: design and implement
software that survives production reality — failures, overload, latency, partial outages, bad
data, hostile traffic, and operational mistakes — instead of discovering those failure modes
after release. It governs any service, API, job, queue, deployment path, or control tooling
that has to keep working when a dependency, network, or caller behaves badly, which is a
different concern from `refactoring-pass` (structural cleanup) or `software-design-simplicity`
(interface and module shape) — this skill is specifically about surviving what production
actually does to a system.

The rule set below is a compressed, decision-oriented distillation of the book — not the book
itself, not a substitute for it, and not officially affiliated with Nygard or his publisher.
It was adapted from the `release-it.mini.md` rule set in
[agent-rules-books](https://github.com/ciembor/agent-rules-books) (MIT licensed, © Maciej
Ciemborowicz), itself a distillation of the book's content, reshaped here into skill form.
See `references/full-reference.md` for the fuller rule set this was compressed from, and
`references/nano-quick-reference.md` for an even tighter fallback when context budget is very
tight.

**When this doesn't fit:** internal-only tooling, local scripts, or a throwaway prototype with
no path to production doesn't need this discipline — nothing here is exposed to production
failure modes until it's actually deployed somewhere those modes exist. Apply it once the code
in question is heading toward, or already living in, a production environment.

---

## Primary bias to correct

A passing happy path is not production readiness. The failure mode this skill guards against
is designing only for the case where every dependency responds quickly and correctly, then
letting production define the failure semantics, demand limits, isolation boundaries, and
diagnosis surface after the fact — usually during an incident, which is the most expensive
possible time to discover them.

---

## Proportionality

Apply this discipline in proportion to how exposed the code actually is to production failure
modes — not identically on every task.

- **Throwaway / spike / local-only tooling:** skip most of this. Nothing here touches
  production traffic, dependencies, or failure modes, so timeouts, circuit breakers, and
  backpressure design aren't earning their cost yet.
- **Greenfield / pre-production service:** apply the full discipline now, while contracts are
  cheap to change — timeouts, retry policy, and failure-mode boundaries are far cheaper to
  design in from the start than to retrofit onto a service already handling real traffic.
- **Production / actively-evolving service with real traffic:** apply the full discipline as
  non-negotiable — every outbound call needs an explicit timeout, every queue needs a bound,
  every failure needs a visible path.
- **Mature / long-lived production system:** apply the full discipline, and give extra
  scrutiny to operational debt that has survived by luck rather than design — an unbounded
  queue or a missing timeout that hasn't caused an incident yet is not evidence it's safe, it's
  evidence the right conditions haven't happened yet.

When in doubt about which band applies, ask rather than guessing — the cost of asking is one
sentence; the cost of guessing wrong is either wasted resilience engineering on code that will
never see production, or a production system with a failure mode nobody designed for.

---

## Decision rules

- Assume every dependency, queue, cache, timeout, caller retry, and degraded state can fail in
  slow, partial, or prolonged ways; code must assume production mess instead of merely
  tolerating it by accident.
- Prefer designs that fail visibly, limit blast radius, shed load, preserve core service, and
  make diagnosis possible over designs that maximize coupling or ideal-path elegance.
- Treat deployment, operations, security, observability, rollback, build and runtime state,
  dependency state, and configuration validation as part of the system, not after-release
  chores.
- Put explicit, intentional time limits on outbound calls and waits. Don't rely on library
  defaults or allow infinite waits where finite response matters.
- Retry only when the operation is safe for the caller and provider; bound count and total
  time, use backoff or jitter, and don't retry validation errors or permanent failures.
- Isolate dependency and workload failures with circuit breakers, fast failure, bulkheads,
  separate resource pools, and slow-work isolation so one outage cannot consume all threads,
  connections, or workers.
- Design overload behavior explicitly with back pressure, finite queues, demand limits,
  capacity reserved for critical traffic, and load shedding of lower-value work before core
  functions collapse.
- Use stability patterns by failure mode: steady state for routine cleanup and bounded growth,
  fail fast when continuing hides unrecoverable trouble or holds scarce resources, let-it-crash
  only with supervision and isolation, handshaking for readiness, decoupling middleware with
  monitoring, and governors for expensive behavior.
- Make runtime state, external responses, automation progress, migrations, operational
  assumptions, and boundary data visible and validated before trusted; keep rollback or
  roll-forward paths for partial operational changes.
- Budget scarce resources explicitly, release them deterministically, avoid holding locks or
  expensive connections across slow remote calls, and stream or paginate large payloads instead
  of defaulting to huge in-memory batches.
- Treat external input and external responses as untrusted: validate syntax, shape, business
  plausibility, status, content type, and semantics; prevent malformed data from poisoning
  caches, queues, or downstream systems.
- Build observability into boundaries and failure points with structured context, correlation
  identifiers, latency, throughput, error, saturation, queue, retry, breaker, dependency,
  version, configuration, health, and runtime signals while avoiding secrets and retry-storm
  log spam.
- Make startup, health checks, migrations, one-time jobs, administrative controls, process
  code, and delivery tooling fail safely, auditable, authorized, observable, stoppable, and
  recoverable.
- Make interconnects, routing, API contracts, caches, scheduled work, and background work
  production-aware: avoid concentrated demand, hidden single points of failure, uncontrolled
  fan-out, fragile chattiness, cache dogpiles, stale data surprises, and synchronized job
  retries.
- Include security and hostile traffic in production readiness, and use production tests,
  launch checks, capacity tests, game days, chaos, or disaster simulations only with limited
  blast radius, observability, stop conditions, and feedback into design.

## Trigger rules

- When adding an outbound call, dependency operation, resource checkout, queue consume, or
  thread wait, define timeout, retry eligibility, retry bounds, fallback or degraded mode,
  validation, and caller-survival behavior.
- When adding a queue, buffer, resource pool, cache, log stream, background job, scheduled job,
  or collection-returning API, define capacity, full behavior, cleanup, miss/stampede/staleness
  behavior, pacing, pagination or streaming, and saturation monitoring.
- When a change touches deployment, configuration, startup, migrations, one-time jobs, scripts,
  or operational automation, make it idempotent or restartable where practical and give it
  durable state, auditability, verification, and rollback or roll-forward.
- When adding health checks, load balancing, service discovery, routing, or inter-service
  handshakes, ensure traffic reaches only ready components and health signals reflect real
  ability to serve.
- When designing API or integration contracts, make material failure modes explicit,
  distinguish retryable from non-retryable outcomes, prefer coarse-grained resilient
  interactions, and document timeout, retry, version, and compatibility expectations.
- When reviewing an incident, performance failure, or capacity issue, identify the failure
  chain, missing defenses, detection gaps, demand, saturation, latency distribution, queue age,
  dependency behavior, traffic concentration, and design changes.
- When adding administrative controls, control planes, delivery tooling, hostile-traffic
  handling, or chaos/disaster work, require authorization, auditability, safe defaults, clear
  stop mechanisms, bounded blast radius, and recovery paths.

## Final checklist

Before calling a service production-ready, verify:

- Explicit timeouts and no infinite waits?
- Retries safe, bounded, backed off or jittered, and not duplicated across layers?
- Queues, buffers, pools, caches, logs, payloads, jobs, and result sets bounded?
- Failure isolated with breakers, bulkheads, fast failure, degradation, or load shedding?
- External input and dependency responses validated before they affect state, caches, queues,
  or downstream systems?
- Diagnostics cover logs, metrics, health, correlation, runtime, version, configuration,
  dependencies, saturation, queue depth, retries, and breaker state?
- Startup, deployment, migration, automation, and operational controls restartable,
  observable, authorized, auditable, and recoverable where practical?
- Interconnects, APIs, caches, scheduled work, security, and chaos tests have explicit
  production failure behavior?
- Was the rigor applied proportionate to how exposed this code actually is to production
  (see Proportionality)?

---

## Output Expectations

When finishing production-facing work, state plainly:

- What failure modes were explicitly designed for (timeouts, retries, isolation, backpressure),
  and what the fallback or degraded behavior is.
- What's observable at the boundaries touched — what a diagnosis would actually have to work
  with during an incident.
- Any unresolved risk — a dependency without a timeout, a queue without a bound, a failure mode
  deliberately left unhandled because it's out of scope for this change.
- If a requested approach conflicts with this discipline (e.g., skipping a timeout to move
  faster), follow the user's request but say so explicitly rather than silently shipping the
  gap.

---

## Changelog

Maintained by Kurt Mitchell. Versioning is MAJOR.MINOR.PATCH — MINOR for new capabilities that
don't change existing behavior, PATCH for clarifications and fixes. The top entry here must
match the `version` field in the frontmatter.

### 1.0.0 — 2026-07-23
- Initial release. Adapted from the `release-it.mini.md` rule set in the
  [agent-rules-books](https://github.com/ciembor/agent-rules-books) project (MIT licensed),
  itself distilled from Michael T. Nygard's *Release It!*. Built directly to the collection's
  normalized skeleton (Purpose → Primary bias to correct → Proportionality → Decision/Trigger
  rules → Final checklist → Output Expectations → Changelog), matching `refactoring-pass`,
  `legacy-code-safety`, `pragmatic-engineering`, and `software-design-simplicity`. Added a
  Proportionality section calibrated to how exposed the code actually is to production traffic
  and failure modes, since this discipline's cost isn't justified for code that never reaches
  production.
  `references/full-reference.md` and `references/nano-quick-reference.md` carry the source
  project's `full` and `nano` tiers respectively, for sessions that need more depth or a
  tighter always-on budget than this skill body provides.
