# Worked Examples

Two fully populated session packages, from different domains, to show the template holds up
outside a software-engineering context. The first also shows the session-open and
session-close narration in practice.

---

## Example 1 — Technical: pre-migration dependency audit

**Context:** A senior engineer at a fictional logistics company, Northwind Logistics, is
mapping which parts of an aging monolith touch payment processing before a planned cloud
migration. Multi-week effort, reports to a CTO, blocked repeatedly on access.

### The package, at the start of session 4

```xml
<session_package>

  <engagement>
    <investigator>Priya Nandan — Staff Engineer, Northwind Logistics</investigator>
    <reports_to>Sam Okafor, CTO</reports_to>
    <session_number>Session 4</session_number>
    <date>2026-07-20</date>
    <last_session_summary>
      Confirmed the legacy billing service still owns the settlement job; ruled out the
      newer payments-api as a dependency. Blocked on read access to the ops-infra repo,
      which likely contains the cron definitions for settlement scheduling.
    </last_session_summary>
  </engagement>

  <access_status>
    <system name="monolith GitHub repo" status="GRANTED"/>
    <system name="ops-infra GitHub repo" status="BLOCKED" note="Requested from Sam, no response yet"/>
    <system name="staging Postgres (read replica)" status="GRANTED"/>
    <system name="Datadog (billing service dashboards)" status="UNKNOWN" note="Never asked"/>
  </access_status>

  <findings_record>
    <question id="Q1" label="Which service owns settlement scheduling" status="CONFIRMED">
      <evidence>billing-service/cron/settlement.rb confirmed as the entry point; payments-api has no cron jobs defined.</evidence>
      <answered_date>2026-07-13</answered_date>
    </question>
    <question id="Q2" label="Where is the cron trigger actually defined" status="INFERRED">
      <evidence>settlement.rb is invoked by something outside the monolith repo -- no crontab or scheduler config found in it. Likely lives in ops-infra.</evidence>
      <next_step>Get ops-infra access from Sam; search for settlement.rb invocation.</next_step>
    </question>
    <question id="Q3" label="Downstream systems notified on settlement" status="UNKNOWN">
      <evidence></evidence>
      <next_step>Check Datadog for outbound calls from settlement.rb during a run; ask Sam if there's a events/webhooks system.</next_step>
    </question>
  </findings_record>

  <priority_next_steps>
    <step priority="1">Escalate ops-infra access request directly to Sam in person -- async request has sat 4 days.</step>
    <step priority="2">Once granted, grep ops-infra for "settlement.rb" or "settlement_job".</step>
    <step priority="3">Get Datadog access to trace outbound calls during a live settlement run.</step>
  </priority_next_steps>

  <open_issues_count>
    <count category="Blocking" open="1"/>
    <count category="Open question" open="2"/>
  </open_issues_count>

</session_package>
```

### Session open (what the assistant says, per the Session Open Protocol)

> "Loaded — settlement scheduling confirmed as owned by the legacy billing service, not
> payments-api. Still blocked on ops-infra access, which is likely where the actual cron
> trigger lives. Want to try escalating that request now, or work the Datadog angle on Q3
> while it's pending?"

### Session close (what gets produced at the end of session 4, per the Session Close Protocol)

**Step 1 — spoken-register summary:**

> "Today we got ops-infra access and found the cron trigger — it's a Terraform-managed
> EventBridge rule, not a crontab, which is why it wasn't in the monolith repo. Confirmed it
> fires settlement.rb every night at 2am UTC. Still don't know what downstream systems get
> notified when settlement completes — that's next."

**Step 2 — updated package:** (Q2 moves to `CONFIRMED` with an `answered_date`, `access_status`
for ops-infra flips to `GRANTED`, `priority_next_steps` re-ordered to put the Datadog work
first since it's now the only open thread.)

**Step 3 — companion document prompt:** skipped in this example — Northwind doesn't maintain
a separate living-document skill for this audit, so the step is simply omitted rather than
forced.

---

## Example 2 — Non-technical: investigative-journalism source tracking

**Context:** A freelance investigative journalist is tracking a multi-source story about
irregular municipal contract awards, across several weeks and a handful of sources with
varying reliability. No engineering involved at all — this is the same skill applied to a
completely different kind of investigation.

```xml
<session_package>

  <engagement>
    <investigator>Marcus Webb — Freelance investigative reporter</investigator>
    <reports_to>Dana Liu, Editor, Riverside Chronicle</reports_to>
    <session_number>Session 6</session_number>
    <date>2026-07-19</date>
    <last_session_summary>
      Confirmed via public records that the winning contractor's registered agent shares an
      address with a former city councilmember's law firm. Source B (anonymous city hall
      staffer) corroborated but has gone quiet since last contact.
    </last_session_summary>
  </engagement>

  <access_status>
    <system name="County clerk public records portal" status="GRANTED"/>
    <system name="Source B (anonymous city hall staffer)" status="UNKNOWN" note="No response to last 2 messages"/>
    <system name="City procurement office (public records request)" status="BLOCKED" note="Filed, 10-day statutory window not yet elapsed"/>
  </access_status>

  <findings_record>
    <question id="Q1" label="Shared address between contractor and ex-councilmember" status="CONFIRMED">
      <evidence>County clerk filing (LLC-2019-04471) lists the same registered-agent address as the ex-councilmember's law firm's filing (LLC-2015-00892).</evidence>
      <answered_date>2026-07-18</answered_date>
    </question>
    <question id="Q2" label="Did ex-councilmember vote on this contract" status="INFERRED">
      <evidence>Council minutes show they were in office during the bid approval, but the vote record itself hasn't been pulled yet -- only the roster is confirmed.</evidence>
      <next_step>Pull the actual roll-call vote from the council meeting minutes for that date.</next_step>
    </question>
    <question id="Q3" label="Was the bid process itself irregular" status="UNKNOWN">
      <evidence></evidence>
      <next_step>Depends on the procurement office records request clearing its 10-day window.</next_step>
    </question>
  </findings_record>

  <priority_next_steps>
    <step priority="1">Pull the roll-call vote record for Q2 -- available now, no blocker.</step>
    <step priority="2">Re-attempt contact with Source B through the agreed secondary channel.</step>
    <step priority="3">Follow up on the procurement records request once the statutory window closes.</step>
  </priority_next_steps>

</session_package>
```

Note what's different from Example 1: no `open_issues_count` block at all (a severity tally
doesn't mean anything for a single narrative investigation, so it's simply left out rather
than forced into an ill-fitting shape), `access_status` tracks a human source and a records
request instead of software systems, and `reports_to` is an editor rather than a CTO. The
skill's mechanics — evidence classification, the Q-numbered findings record, session open/close
protocol — carry over unchanged.
