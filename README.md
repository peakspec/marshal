# minions — AI Subagent Team

A team of AI subagents that act as virtual product team members. Each agent is scoped to a specific role and powered by curated skills from open-source repositories.

Built for **Claude Code** (primary) and **OpenCode**.

---

## What is minions?

minions is a team of AI agents, each playing a specific product team role — Associate PM, Data Analyst, GTM Specialist, User Researcher, Customer Service, QA, and UI/UX Designer. You talk to one entry point (PM Ops via `/minions`), and it routes your request to the right specialist agent — or runs multiple agents in parallel for cross-domain tasks. Each agent knows which skills to invoke, which Lark tables to read or write, and how to hand off outputs to the next agent in the chain.

---

## The Team

| Agent | Role | Handles |
|-------|------|---------|
| **PM Ops** | Orchestrator — single entry point | All requests (routes to subagents) |
| **Associate PM** | Document creation & roadmap | PRDs, OKRs, roadmaps, decks, changelogs |
| **Data Analyst** | Business intelligence | SQL, cohort analysis, A/B tests, KPIs, PostHog |
| **GTM Specialist** | Go-to-market | Marketing decks, ICP, positioning, competitive, pricing |
| **User Researcher** | Research & insights | Personas, journey maps, interviews, sentiment |
| **Customer Service** | Customer comms | Help center articles, onboarding emails, feedback triage |
| **QA** | Quality assurance | Test scenarios, QA readiness, bug reproduction |
| **UI/UX Designer** | Interface design | Wireframes, design specs, design audits, accessibility review, on-request UI code |

---

## Skills

Each agent has a curated set of skills it invokes for specific tasks.

### PM Ops
| Skill | Purpose |
|-------|---------|
| `summarize-meeting` | Meeting transcript → decisions + action items |
| `sprint-plan` | Sprint planning with capacity estimation |
| `retro` | Structured sprint retrospective |
| `release-notes` | User-facing release notes from tickets |
| `stakeholder-map` | Power × Interest grid + communication plan |
| `prioritization-frameworks` | ICE, RICE, MoSCoW, Kano reference |
| `user-stories` | User stories with 3 C's + INVEST |
| `job-stories` | JTBD-format job stories |
| `wwas` | Why-What-Acceptance backlog items |
| `pre-mortem` | Risk analysis pre-launch |
| `team-ops` | Performance audits + meeting-to-action extraction |
| `optimize-goal` | Review/enhance a `goal.md` task spec — clarifies ambiguity, then rewrites on approval |

### Associate PM
| Skill | Purpose |
|-------|---------|
| `create-prd` | 8-section PRD template |
| `brainstorm-okrs` | Team OKRs aligned to company objectives |
| `outcome-roadmap` | Feature list → outcome-focused roadmap |
| `prioritize-features` | Backlog prioritization by impact/effort/risk |
| `analyze-feature-requests` | Categorize and triage feature requests |
| `product-strategy` | 9-section Product Strategy Canvas |
| `lean-canvas` | Startup lean canvas |
| `business-model` | Business Model Canvas |
| `pre-mortem` | Launch risk analysis |
| `pptx` | Slide deck generation (.pptx) |

### Data Analyst
| Skill | Purpose |
|-------|---------|
| `sql-queries` | Generate SQL from natural language (BigQuery, PostgreSQL, MySQL) |
| `cohort-analysis` | Retention curves, feature adoption trends |
| `ab-test-analysis` | Statistical significance, sample size, ship/extend/stop |
| `metrics-dashboard` | North Star + input metrics + alert thresholds |
| `north-star-metric` | North Star Metric + business game classification |
| `finance-ops` | Hidden cost discovery, cost estimates, scenario modeling |
| `revenue-intelligence` | Sales call insight pipeline (Gong), revenue attribution, client reports |

### GTM Specialist
| Skill | Purpose |
|-------|---------|
| `gtm-strategy` | Full GTM: channels, messaging, metrics, launch plan |
| `beachhead-segment` | First market segment identification |
| `ideal-customer-profile` | ICP with demographics, JTBD, needs |
| `growth-loops` | Sustainable growth flywheels |
| `gtm-motions` | PLG vs sales-led vs hybrid evaluation |
| `competitive-battlecard` | Sales-ready competitor comparison |
| `marketing-ideas` | Creative, cost-effective marketing ideas |
| `positioning-ideas` | Differentiated positioning from competitors |
| `value-prop-statements` | Value props for sales, marketing, onboarding |
| `product-name` | Product naming aligned to brand |
| `competitor-analysis` | Competitor strengths/weaknesses/differentiation |
| `market-sizing` | TAM, SAM, SOM estimation |
| `pricing-strategy` | Pricing, packaging, monetization |
| `pptx` | Slide deck file generation (.pptx) |
| `growth-engine` | Autonomous marketing experiments — run, measure, optimize (bootstrap CI, Mann-Whitney U) |
| `sales-pipeline` | Anonymous visitor → qualified pipeline (RB2B router, deal resurrector, ICP learner) |
| `outbound-engine` | ICP → automated cold outbound sequences, competitive monitor |
| `seo-ops` | Competitor keyword gaps, content attack briefs, GSC optimizer, trend scout |
| `conversion-ops` | Landing page CRO audit, survey-to-lead-magnet engine |
| `yt-competitive-analysis` | YouTube outlier videos and title-pattern extraction across competitor channels |
| `x-longform-post` | Human-sounding X/Twitter long-form posts + AI slop detector |
| `podcast-ops` | One podcast episode → 20+ content pieces across platforms |
| `autoresearch` | Content variant generation + expert-panel scoring + evolution loop |

### User Researcher
| Skill | Purpose |
|-------|---------|
| `user-personas` | Refined personas from research data |
| `market-segments` | 3–5 segments with demographics + JTBD |
| `user-segmentation` | Behavior/JTBD-based segmentation |
| `customer-journey-map` | End-to-end journey with touchpoints + pain points |
| `interview-script` | Structured interview scripts (Mom Test principles) |
| `summarize-interview` | Transcript → JTBD, satisfaction signals, actions |
| `sentiment-analysis` | Feedback sentiment + theme extraction |

### Customer Service
| Skill | Purpose |
|-------|---------|
| `grammar-check` | Grammar, logic, and flow checking for help articles |
| `emails` | Email sequences, drip campaigns, lifecycle emails |
| `onboarding` | Post-signup activation optimization |
| `churn-prevention` | Cancel flows, save offers, dunning |
| `content-ops` | Content quality scoring, editorial pipeline |

### QA
| Skill | Purpose |
|-------|---------|
| `test-scenarios` | Happy paths, edge cases, error handling |
| `webapp-testing` | Web application testing with Playwright |

### UI/UX Designer
| Skill | Purpose |
|-------|---------|
| `design-taste-frontend` | Generate new UI from scratch |
| `redesign-existing-projects` | Audit and improve an existing UI |
| `image-to-code` | Screenshot/mock → implemented UI code |
| `high-end-visual-design` | "Polished, calm, expensive" visual style |
| `minimalist-ui` | Notion/Linear-style restrained design |
| `industrial-brutalist-ui` | Industrial/Swiss-typography style |
| `stitch-design-taste` | Google Stitch-compatible design rules |
| `full-output-enforcement` | Prevents truncated generation output |

---

## Quick Start

### 1. Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [lark-cli](https://github.com/larksuite/lark-cli) installed and authenticated (`lark-cli auth login`)
- Node.js 18+

### 2. Install

```bash
git clone https://github.com/bahni-m/minions.git
cd minions
./install.sh
```

The script copies all agent files, installs the PM Ops skill, creates your config template, and installs all required skill packages automatically.

### 3. Configure Lark

Open `~/.claude/skills/minions/config.md` (created by the installer) and fill in your Lark base token and table IDs.

### 4. Use it

Open Claude Code in any workspace and type:

```
/minions
```

PM Ops will take your request, route it to the right subagents, and return a consolidated response.

---

## How It Works

```
You
 │
 ▼ /minions
PM Ops  ──────────────────────────────────────────────┐
 │                                                     │
 ├─── Associate PM      (PRDs, OKRs, roadmaps, decks) │
 ├─── Data Analyst      (SQL, KPIs, A/B, PostHog)     │  parallel
 ├─── GTM Specialist    (GTM, ICP, decks, competitive) │  or
 ├─── User Researcher   (personas, journeys, research) │  sequential
 ├─── Customer Service  (help center, emails, triage)  │
 ├─── QA                (test scenarios, QA reports)    │
 └─── UI/UX Designer    (wireframes, design specs, UI) ─┘
```

PM Ops decomposes your request, dispatches independent subtasks in parallel and dependent ones sequentially, then aggregates everything into one response.

---

## Usage

Just tell `/minions` what you need:

```
"Review sprint progress, reprioritize, create report, send to Lark, create demo deck, changelog, update wiki"
→ Data Analyst (velocity + blockers) → QA (readiness check) → Associate PM (report + deck + changelog + wiki) → PM Ops (sends to Lark)

"Prepare a .pptx pitch deck for our target customer segments"
→ User Researcher (extract JTBD from archetypes) → GTM Specialist (build slides) + Associate PM (validate claims)

"Setup North Star metric and KPIs for each pillar"
→ Data Analyst (define metrics) + Associate PM (map to Lark Base structure)

"Generate help center articles from PRDs, create triage issues, monitor feedback"
→ Customer Service (articles + triage + alerts)

"Write test scenarios for the new feature"
→ QA (happy path + edge cases + acceptance criteria check)

"Draft onboarding email sequence for new signups"
→ Customer Service (emails + onboarding skills, Day 0/3/7/14/30 with trigger conditions)
```

---

## File Structure

```
minions/
├── agents/
│   ├── minions-associate-pm.md      ← Associate PM subagent
│   ├── minions-data-analyst.md      ← Data Analyst subagent
│   ├── minions-gtm-specialist.md    ← GTM Specialist subagent
│   ├── minions-user-researcher.md   ← User Researcher subagent
│   ├── minions-customer-service.md  ← Customer Service subagent
│   ├── minions-qa.md                ← QA subagent
│   └── minions-ui-ux-designer.md    ← UI/UX Designer subagent
├── skills/
│   ├── minions/
│   │   ├── SKILL.md                ← PM Ops (entry point via /minions)
│   │   └── config.example.md       ← Lark config template (copy → config.md and fill in)
│   └── optimize-goal/
│       ├── SKILL.md                ← Review/enhance a goal.md task spec
│       └── references/
│           └── best-practices.md   ← Prompt-engineering checklist used for the review
├── install.sh                      ← One-command installer
├── spec.md                         ← Full specification
└── README.md
```

After install, all files live in `~/.claude/agents/`, `~/.claude/skills/minions/`, and
`~/.claude/skills/optimize-goal/`.

---

## Toolchain

| Tool | Purpose |
|------|---------|
| `lark-cli base +...` | Read/write Lark Base (Issues, Pillars, Modules, Roadmap) |
| `lark-cli docs +...` | Read/write Lark Docs (PRDs, OKRs, wiki, changelogs) |
| `lark-cli im +...` | Send Lark messages (feedback alerts) |
| PostHog REST API | Product analytics — agents self-discover credentials from `.env` |

Lark base token and table IDs are stored in `~/.claude/skills/minions/config.md` (filled in during setup). PostHog credentials, Lark group chat IDs, and Lark Doc tokens are self-discovered by agents at runtime.

---

## Configuration

Two remaining open questions before the team is fully operational:

| Item | How to resolve |
|------|----------------|
| Email engine | Tell Customer Service which engine you use (SendGrid, Mailchimp, Customer.io) for correct scheduling spec format |
| PostHog dashboards | Tell Data Analyst whether dashboards are greenfield or existing, to scope setup correctly |

Everything else self-configures on first use.

---

## Contributing

Found a way to improve an agent or skill definition? Have a new use case to add? Open an issue or PR — contributions to agent files, skills, and the install script are welcome.

---

## Full Specification

See [`spec.md`](./spec.md) for the complete design including subagent definitions, orchestration protocol, use case walkthroughs, Lark Base schema, and success metrics.
