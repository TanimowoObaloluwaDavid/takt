# Takt — product thesis and evidence

**The scheduler that tells you why you’re late.**

This document separates what was verified from public sources during this build
from the assumptions behind the product. It is not a market-size claim and it is
not a substitute for customer discovery.

Research date: **20 October 2026**. Sources are public vendor pages; no
competitor was hands-on tested.

## 1. The problem

High-mix, low-volume job shops make a different product, routing, and mix every
week. Their scheduling problem is not “put this task on a calendar.” It is:

- Every job is a chain of operations that must run in order.
- Machines are finite and work centers have one or several parallel machines.
- Changing from one job to another consumes setup/changeover time.
- Due dates, release dates, and customer priorities collide.
- A late job is usually late because it queued somewhere, not because one
  operation was slow.
- The person making the promise to the customer needs a defensible answer
  quickly, not a black-box optimization score.

Traditional ERP and MES suites can hold this data, and several schedule work.
But their public positioning is broad: quoting, inventory, purchasing, costing,
quality, shipping, reporting. Takt’s premise is that there is room for a narrow,
fast, **diagnosis-first** capacity tool that sits beside those systems and
answers the “why” question directly.

## 1.1 Why Nigeria is the first pilot market

Takt is a horizontal product, but the first design-partner market is specific:
Nigeria's make-to-order manufacturing cluster. The working list is precision
machining and fabrication in the Lagos–Ogun corridor, auto components in Nnewi,
plastics and light manufacturing in Aba, and agro-equipment in Kano. This is a
focus for learning, not a market-size claim.

The constraints are unusually legible in these shops:

- High mix and low volume make every week a different routing problem.
- Much of the machine tool, tooling, and spare-parts base is imported, so
  capacity additions are FX-denominated and slow.
- The person who quotes the date is often the owner or a production manager,
  not a dedicated scheduler.
- A single constrained cell can hold up jobs for several other customers, so
  the cost of a vague answer is not confined to one order.
- A full ERP/MES rollout is a large commitment for a shop that needs a useful
  answer this week.

That is why the demo is not a US shop with a currency label swapped. The
workspace is **Ajao Precision Works** in Lagos, the currency is **NGN**, and the
customers are fictional Nigerian manufacturers. The product decisions stay the
same: diagnose the queue, test one capacity change, and enforce authority on the
server.

The proposed next step is a design-partner pilot with 3–5 shops in one cluster:
one bottleneck, one week of real jobs, a baseline run, and one capacity
what-if. The measures are whether the owner can explain the delay without a
report, whether the what-if changes a capacity decision, and which real
constraint the shop wants modeled next.

**Boundary:** no Nigerian customer was interviewed, no pilot was run, and no
Nigerian logo, testimonial, revenue, or market-size figure is claimed. The
Nigeria focus is a stated product bet, not traction.

## 2. What was verified in the market scan

These are public, dated descriptions — not independent benchmarks. A vendor’s
marketing claim is evidence of positioning, not proof of performance.

| Product | Publicly described capability | Source |
| --- | --- | --- |
| **ECI JobBOSS²** | Job-shop ERP with finite or infinite scheduling, a drag-and-drop Planning Board and Whiteboard Scheduler, bottleneck visibility, and what-if scenarios. The vendor’s product FAQ states a 3–6 month implementation. | [Scheduling feature page](https://www.ecisolutions.com/products/jobboss2/features/scheduling/), [product page and FAQ](https://www.ecisolutions.com/products/jobboss2), accessed 20 Oct 2026 |
| **Fulcrum** | Cloud manufacturing software whose Autoschedule “parses your production data” and updates as live job progress changes; real-time job costing; connected job tracking. | [Production scheduling](https://fulcrumpro.com/manufacturing-software/production-scheduling), [homepage](https://fulcrumpro.com/), accessed 20 Oct 2026 |
| **Autodesk Fusion Operations (formerly Prodsmart)** | MES with a visual drag-and-drop scheduler, real-time production data, capacity/load visibility, and bottleneck identification. | [Autodesk production scheduling article, 24 Oct 2022](https://www.autodesk.com/products/fusion-360/blog/production-scheduling-tools-prodsmart), accessed 20 Oct 2026 |
| **Rockwell Automation Finite Scheduler** | Finite-capacity scheduling positioned as going beyond MRP by considering additional production constraints. Public launch described in March 2024. | [Rockwell press release, 1 Mar 2024](https://www.rockwellautomation.com/en-cz/company/news/press-releases/launch-of-finite-scheduler.html) |

### What this evidence supports

1. Finite-capacity scheduling is an established category, not a novel concept.
   Takt must earn its place through the decision experience, not by claiming to
   invent scheduling.
2. Incumbents are broad, connected systems. Breadth is valuable to a shop that
   wants one system of record, but it also means onboarding and configuration
   are substantial. The JobBOSS² product FAQ’s stated 3–6 month implementation
   is one public signal of that weight.
3. Bottleneck visibility and what-if analysis are already marketed by
   established vendors. Takt cannot differentiate on those labels alone.
4. Public descriptions emphasize schedules, status, bottlenecks, and scenarios.
   They do not describe, in the material reviewed, a per-job causal chain that
   attributes a late job to queue minutes at a named work center and converts
   that attribution into a concrete capacity test. That is the specific gap
   Takt is designed around.

**Boundary:** the absence of a feature on a public page is not proof that the
product lacks it internally. The defensible claim is about positioning and the
experience Takt chose to build, not a claim of competitor inferiority.

## 3. Assumptions — not verified facts

These are product bets to test with real shops. They are written as assumptions
so they are not mistaken for research findings.

- **A1.** In a high-mix shop, the person who promises a due date can act on a
  clear causal explanation faster than on a raw Gantt chart or an optimization
  score.
- **A2.** Naming the work center and the queue minutes is more useful than a
  generic “capacity constrained” warning.
- **A3.** A narrow tool can earn adoption before a shop replaces its ERP,
  especially when it accepts data through a lightweight setup flow.
- **A4.** Owners will share a scoped viewer key with customers or supervisors if
  the permission model is visibly safe.
- **A5.** A seeded, repeatable what-if is more trustworthy than a single
  “optimized” answer, because the comparison isolates the capacity change.
- **A6.** Small shops will tolerate deterministic processing times and no shift
  calendars for an early planning tool; complex shops will not.
- **A7.** Nigerian make-to-order shops will adopt a narrow diagnosis tool before
  replacing an ERP, because implementation time and cash are both constrained.
- **A8.** When a machine is imported and paid for in FX, a like-for-like what-if
  is more persuasive than an optimizer score.

The app does not claim product-market fit. No customer interviews, pricing
tests, or usage analytics were conducted for this build. The Nigeria focus is a
pilot thesis, not a verified finding.

## 4. Target users and jobs

### Primary persona — owner / production manager

Runs a 10–80 person make-to-order shop. Knows the floor, quotes work, promises
dates, and is tired of rebuilding a spreadsheet when a machine goes down or a
rush job arrives.

**Job to be done:** “When I’m about to miss a date, help me see what is really
causing it and tell me whether adding capacity here would fix it — before I call
the customer.”

The first design partners are Nigerian make-to-order shops in the Lagos–Ogun
corridor, Nnewi, Aba, or Kano. The persona and job are unchanged; the demo uses
NGN and local customer names so the workflow is legible without translation.

### Secondary persona — scheduler / lead

Owns the sequence and has to explain it to the floor.

**Job to be done:** “Give me a feasible sequence I can defend, and let me compare
a change without losing the baseline.”

### Secondary persona — viewer / customer-facing colleague

Needs visibility, not edit rights.

**Job to be done:** “Let me check the plan and the reason for a delay without
being able to change the shop.”

## 5. Product principles

1. **Explain before optimize.** A schedule is only useful if the shop can trust
   the reason behind it. The diagnosis is the product.
2. **One decision, one comparison.** What-if keeps the seed and changes one
   capacity lever, so the delta means something.
3. **The server owns authority.** Hiding a button is UX; rejecting the write is
   security. Roles are enforced on every data call.
4. **The interface is a drafting sheet, not a dashboard.** It should feel like a
   working document: labels, annotations, ruled lines, revision stamps, and
   restrained color. Dense but calm.
5. **No simulated success.** Sample data is real persisted data run through the
   real solver and endpoints. Empty, loading, error, offline, and permission
   states are part of the flow.
6. **Say what is not modeled.** Continuous time, flat changeovers, and no shifts
   are limitations, not footnotes to hide.

## 6. The core workflow

1. **Set up the shop** — name, currency, work centers, machines, changeovers.
2. **Enter the work** — jobs, quantities, due/release dates, priority, ordered
   routing steps.
3. **Run the solver** — finite-capacity sequence with parallel machines and
   changeovers.
4. **Read the diagnosis** — late jobs first; queue attribution; bottleneck
   utilization; per-operation chain.
5. **Test a capacity decision** — add machines to one work center; compare
   tardiness and jobs saved with the same seed.
6. **Share the plan safely** — invite an editor or viewer; use scoped keys;
   keep the owner key private.

## 7. Positioning

| Dimension | Broad ERP / MES | Takt |
| --- | --- | --- |
| Primary job | Run the business system of record | Explain and test a capacity decision |
| Time to first useful schedule | Configuration-heavy | Enter a shop or load sample data and solve |
| Output | Orders, costs, status, schedules, reports | Schedule plus causal diagnosis and capacity delta |
| Collaboration | Role-based ERP access | Workspace roles with scoped keys and guest viewing |
| Scope | Quoting through shipping | Scheduling, diagnosis, what-if, team access |

**Positioning statement:** For high-mix job shops — starting with Nigeria's
make-to-order cluster — Takt is a diagnosis-first scheduling surface that shows
why a job is late and what capacity change recovers the time, without replacing
the shop’s ERP.

Takt is not:
- an ERP, quoting, purchasing, inventory, or accounting system;
- an AI chatbot wrapper;
- a generic project-management board;
- an optimizer that claims optimality;
- a shop-floor data-collection/MES product.

## 8. Functional scope of this build

### Real and persisted

- Accounts, sessions, workspaces, membership roles, invitations, removal,
  password change.
- Scoped workspace keys, guest access, owner-key compatibility.
- Work center CRUD, job/routing CRUD, sample data load.
- Solve, diagnosis, schedule snapshot, history, what-if.
- Search/filter and CSV-to-clipboard for visible jobs.
- Responsive Flutter UI with role-aware controls.
- A Nigerian demo workspace, **Ajao Precision Works** (Lagos, NGN), with
  fictional local customers and the owner/editor/viewer role story.
- NGN in the workspace currency selector; the picker starts on NGN.

### Deliberately absent

- Email delivery, verification, password reset.
- Invitations to unregistered emails.
- Key rotation UI.
- Billing, plans, tenant administration.
- Shift calendars, operators, materials, batching, downtime, preemption.
- Import from ERP/CSV files; the only bulk data path is the sample loader.
- Notifications and integrations.

## 9. Success criteria for the next stage

These are proposed measures, not results.

- A new user can create a workspace, load the sample, solve, and explain a late
  job in under five minutes without help.
- At least 80% of test users can correctly identify the binding work center
  from the diagnosis without opening a separate report.
- A what-if result is understood as a comparison, not a guarantee.
- An owner can invite a viewer and demonstrate that the viewer cannot write,
  without reading server code.
- The explanation is judged more actionable than a Gantt bar alone in a
  side-by-side task.
- A shop can describe which real constraints are missing and rank the next two
  to model.
- A design partner can state the binding work center and the capacity decision
  in one sentence after the demo, without reading a report.

## 10. Visual and interaction direction

**Concept:** an engineer’s drafting sheet crossed with a dispatch board.

- **Type:** Space Grotesk for UI and display; IBM Plex Mono for data, timestamps,
  keys, and annotations.
- **Palette:** warm paper, graphite ink, teal for live/positive, oxide for loss,
  amber for caution/read-only.
- **Geometry:** square-ish corners, hairline rules, panel headers with section
  labels, revision-stamp metadata, tabular numerals.
- **Motion:** restrained; progress and state changes, not decorative loops.
- **Voice:** direct, specific, never cute about a late order. “42% of the 2h 40m
  delay is queue time at CNC Mill 2” beats “Optimize your workflow.”

The design is intentionally different from generic SaaS dashboards: the board
reads like a document that happens to be interactive. Authentication uses the
same language rather than dropping into a stock Material form.

## 11. Trust, safety, and auth decisions

- Accounts are optional to **try** a workspace; guest keys open a shop directly.
- Accounts are required to **manage** a workspace, people, and persistent
  discovery.
- Every data call resolves a scoped key to a shop and a role. Writes require
  owner or editor. The UI mirrors that authority but is not the enforcement.
- Owner keys are full-access and bypass roles. The product states this clearly
  in Setup and does not use the owner key as a viewer share link.
- Member keys are redacted from other members; owners can retrieve them to
  invite/share.
- Removing a member invalidates their key immediately.
- Password change revokes other sessions, not workspace keys.

The security tradeoffs and remaining work are listed in
[README.md](README.md#security-and-operational-limits).

## 12. Roadmap

Near term:
1. Design-partner pilot kit: one-week job template, guided baseline/what-if,
   and feedback capture for Nigerian shops.
2. Key rotation and a proper invitation flow for unregistered emails.
3. Shift calendars and operator/resource constraints.
4. CSV/ERP import and export.
5. Audit log for membership and solver runs.
6. Durable rate limiting and secure session storage.

Later:
7. Localized onboarding: NGN/WAT presets, local job templates, and a
   pilot-friendly import path.
8. Scenario library with named comparisons.
9. Machine downtime and maintenance windows.
10. Multi-site planning and ownership transfer.
11. Customer-facing share links scoped to a single job, not the whole shop.

## 13. Research limitations

- The competitor scan used public marketing and documentation pages on
  20 October 2026. It did not include trials, pricing negotiations, or hands-on
  evaluation.
- No customer interviews or time-and-motion studies were run for this build.
- The Nigeria framing is a product hypothesis; no Nigerian shop was interviewed
  for this build, and the demo workspace and its people and customers are
  fictional.
- No market-size or willingness-to-pay claim is made.
- Vendor feature labels may hide deeper capabilities; Takt’s differentiation is
  a product choice, not a verified claim that competitors cannot explain delay.
- The sample shop is fictional and intended to exercise routing, parallel
  machines, changeovers, priorities, and tardiness; it is not a benchmark.
