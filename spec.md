# minions AI Subagent Team — Specification

> **Version:** 1.1.0
> **Date:** 2026-06-02
> **Status:** Active

---

## 0. Installation

This section is for anyone cloning this repo and setting up the subagent team from scratch.

### 0.1 Prerequisites

| Requirement | Install |
|-------------|---------|
| [Claude Code](https://claude.ai/code) | Download and install the desktop app or CLI |
| [lark-cli](https://github.com/larksuite/lark-cli) | `npm install -g lark-cli` then `lark-cli auth login` |
| Node.js 18+ | Required for skill installation |

### 0.2 Copy Agent Files

```bash
# Copy subagents to global Claude Code agents directory
cp agents/*.md ~/.claude/agents/

# Copy PM Ops entry point skill + config template
mkdir -p ~/.claude/skills/minions
cp skills/minions/SKILL.md ~/.claude/skills/minions/SKILL.md
cp skills/minions/config.example.md ~/.claude/skills/minions/config.md
# Edit config.md and fill in your Lark base token and table IDs

# Copy the optimize-goal skill (review/enhance goal.md task specs)
mkdir -p ~/.claude/skills/optimize-goal/references
cp skills/optimize-goal/SKILL.md ~/.claude/skills/optimize-goal/SKILL.md
cp skills/optimize-goal/references/best-practices.md ~/.claude/skills/optimize-goal/references/best-practices.md
```

After this, type `/minions` in any Claude Code session to invoke PM Ops. `optimize-goal` is
also usable standalone — point Claude at any `goal.md` and ask it to review/enhance it.

### 0.3 Install Required Skills

Most skills come from `phuryn/pm-skills` and are installed via `npx skills add`. Run all commands below:

```bash
# Core PM skills — used by PM Ops, Associate PM, Data Analyst, QA
npx skills add phuryn/pm-execution
npx skills add phuryn/pm-product-discovery
npx skills add phuryn/pm-product-strategy
npx skills add phuryn/pm-data-analytics
npx skills add phuryn/pm-go-to-market
npx skills add phuryn/pm-marketing-growth
npx skills add phuryn/pm-market-research
npx skills add phuryn/pm-toolkit

# Marketing skills — used by GTM Specialist, Customer Service, Data Analyst, User Researcher
npx skills add coreyhaines31/marketingskills

# Document generation — used by Associate PM, QA
npx skills add anthropics/skills --skill pptx
npx skills add anthropics/skills --skill docx
npx skills add anthropics/skills --skill xlsx
npx skills add anthropics/skills --skill webapp-testing
npx skills add anthropics/skills --skill internal-comms

# AI marketing skills — used by GTM Specialist, Customer Service
# (manual copy — this repo uses SKILL.md per category, not individual skills)
git clone https://github.com/ericosiu/ai-marketing-skills.git /tmp/ai-marketing-skills
mkdir -p ~/.claude/skills/deck-generator ~/.claude/skills/sales-playbook ~/.claude/skills/content-ops
cp /tmp/ai-marketing-skills/deck-generator/SKILL.md ~/.claude/skills/deck-generator/
cp /tmp/ai-marketing-skills/sales-playbook/SKILL.md ~/.claude/skills/sales-playbook/
cp /tmp/ai-marketing-skills/content-ops/SKILL.md ~/.claude/skills/content-ops/

# UI/UX skills — used by UI/UX Designer
npx skills add https://github.com/Leonxlnx/taste-skill --skill design-taste-frontend
npx skills add https://github.com/Leonxlnx/taste-skill --skill redesign-existing-projects
npx skills add https://github.com/Leonxlnx/taste-skill --skill image-to-code
npx skills add https://github.com/Leonxlnx/taste-skill --skill high-end-visual-design
npx skills add https://github.com/Leonxlnx/taste-skill --skill minimalist-ui
npx skills add https://github.com/Leonxlnx/taste-skill --skill industrial-brutalist-ui
npx skills add https://github.com/Leonxlnx/taste-skill --skill stitch-design-taste
npx skills add https://github.com/Leonxlnx/taste-skill --skill full-output-enforcement
```

### 0.4 Skill Coverage Status

| Skill | Source | Status |
|-------|--------|--------|
| `summarize-meeting`, `sprint-plan`, `retro`, `release-notes`, `stakeholder-map`, `prioritization-frameworks`, `user-stories`, `job-stories`, `wwas`, `pre-mortem` | phuryn/pm-execution | Installed via `npx skills add phuryn/pm-execution` |
| `create-prd`, `brainstorm-okrs`, `outcome-roadmap` | phuryn/pm-execution | Same |
| `prioritize-features`, `analyze-feature-requests`, `interview-script`, `summarize-interview`, `metrics-dashboard` | phuryn/pm-product-discovery | Installed via `npx skills add phuryn/pm-product-discovery` |
| `product-strategy`, `lean-canvas`, `business-model` | phuryn/pm-product-strategy | Installed via `npx skills add phuryn/pm-product-strategy` |
| `sql-queries`, `cohort-analysis`, `ab-test-analysis` | phuryn/pm-data-analytics | Installed via `npx skills add phuryn/pm-data-analytics` |
| `gtm-strategy`, `beachhead-segment`, `ideal-customer-profile`, `growth-loops`, `gtm-motions`, `competitive-battlecard` | phuryn/pm-go-to-market | Installed via `npx skills add phuryn/pm-go-to-market` |
| `marketing-ideas`, `positioning-ideas`, `value-prop-statements`, `product-name`, `north-star-metric` | phuryn/pm-marketing-growth | Installed via `npx skills add phuryn/pm-marketing-growth` |
| `user-personas`, `market-segments`, `user-segmentation`, `customer-journey-map`, `sentiment-analysis`, `competitor-analysis`, `market-sizing` | phuryn/pm-market-research | Installed via `npx skills add phuryn/pm-market-research` |
| `grammar-check` | phuryn/pm-toolkit | Installed via `npx skills add phuryn/pm-toolkit` |
| `test-scenarios` | phuryn/pm-execution | Installed via `npx skills add phuryn/pm-execution` |
| `emails`, `onboarding`, `churn-prevention`, `customer-research`, `analytics`, `ab-testing`, `launch`, `sales-enablement`, `competitors`, `pricing`, `marketing-plan` | coreyhaines31/marketingskills | Installed via `npx skills add coreyhaines31/marketingskills` |
| `pptx`, `docx`, `xlsx`, `webapp-testing`, `internal-comms` | anthropics/skills | Installed individually (see 0.3) |
| `deck-generator`, `sales-playbook`, `content-ops` | ericosiu/ai-marketing-skills | Manual copy (see 0.3) |
| `design-taste-frontend`, `redesign-existing-projects`, `image-to-code`, `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `stitch-design-taste`, `full-output-enforcement` | leonxlnx/taste-skill | Installed individually (see 0.3) |

### 0.5 PostHog Configuration

There is no PostHog CLI. The Data Analyst agent will automatically search your project `.env` files for `POSTHOG_API_KEY` and `POSTHOG_PROJECT_ID` on first use. If not found, it will ask you.

### 0.6 Lark Configuration

1. Verify auth: `lark-cli auth status`. If expired, run `lark-cli auth login`.
2. Fill in `~/.claude/skills/minions/config.md` with your Lark base token and table IDs (copied from `config.example.md` in step 0.2). Agents read this file at runtime — if missing, they self-discover via `lark-cli` search.
3. The user reports group chat ID is self-discovered by the Customer Service agent via `lark-cli im +chat-search` on first use — no manual setup needed (optionally set `USER_REPORTS_CHAT_NAME` in config.md to help it find the right chat).

---

## 1. Problem Statement

Product teams often lack headcount for specialized roles: Associate PM, Data Analyst (BI), Go-to-Market Specialist, User Researcher, Customer Service, QA, and UI/UX Designer.

**Solution:** AI subagents that act as virtual team members, each scoped to a specific role, powered by curated skills from open-source repositories and integrated with Lark Suite + PostHog toolchain.

---

## 2. Architecture Overview

```
                         ┌──────────────────────────────┐
                         │             YOU               │
                         └──────────────┬───────────────┘
                                        │  single entry point
                                        ▼
                         ┌──────────────────────────────┐
                         │          PM OPS               │
                         │   (orchestrator / router)     │
                         └───┬───┬───┬───┬───┬───┬──────┘
                             │   │   │   │   │   │
                   ┌─────────┘   │   │   │   │   └──────────┐
                   ▼             ▼   ▼   ▼   ▼              ▼
             ┌──────────┐  ┌──────────┐ ┌──────────┐ ┌──────────┐
             │Associate │  │  Data    │ │   GTM    │ │   User   │
             │   PM     │  │ Analyst  │ │Specialist│ │Researcher│
             └──────────┘  └──────────┘ └──────────┘ └──────────┘
                   ┌──────────┐  ┌──────────┐
                   │ Customer │  │    QA    │
                   │ Service  │  │          │
                   └──────────┘  └──────────┘
```

These subagents are **supplementary, ad-hoc roles** invoked on demand. They complement your existing development workflow without replacing it.

---

## 3. Core Documents (Single Source of Truth)

### 3.1 Document Boundary

| Data Type | Storage | Access Via |
|-----------|---------|------------|
| Structured operational data (sprints, issues, backlog, pillars, modules, roadmap, KPIs) | **Lark Base** — separate base per concept | `lark-cli base +...` |
| Narrative documents (PRDs, OKRs, wiki, changelogs, meeting transcripts, user archetypes) | **Lark Docs** | `lark-cli docs +...` |
| Product analytics (events, dashboards, attribution) | **PostHog** | PostHog REST API via `curl` (no CLI available) |

### 3.2 Lark Base

**Base Token:** `YOUR_LARK_BASE_TOKEN`

**Relevant Tables:**

| Table | Table ID | Purpose | Key Fields |
|-------|----------|---------|------------|
| **Pillars** | `YOUR_PILLARS_TABLE_ID` | Strategic pillars with team assignments | `Pillar Name`, `Strategic Goal`, `Description`, `Health`, `PM`, `Designer`, `Engineers`, `Link to PRD`, `Issues` (link), `Roadmap` (link) |
| **Modules** | `YOUR_MODULES_TABLE_ID` | Product modules grouped under pillars | `Module Name`, `Status` (Concept/Alpha/Beta/Active/Sunset), `North Star Metric`, `Description`, `Documentation` (URL), `Launch Date`, `Pillar` (link), `Issues` (link) |
| **Issues** | `YOUR_ISSUES_TABLE_ID` | Central issue tracker (features, bugs, tasks, improvements, tech debt) | `Issue Name`, `Issue Type`, `Priority` (P0/P1/P2), `Product Status` (Discovery→Done pipeline), `Ops Status`, `Active Sprint`, `Initial Sprint`, `Assignee`, `Points`, `Bucket` (Product/Operations), `Pillar` (link), `Module` (link), `Sub Task` (link) |
| **Subtask** | `YOUR_SUBTASK_TABLE_ID` | Subtasks linked to issues | `Subtask Name`, `Status` (To Do/WIP/Ready for QA/Done), `Assignee`, `Story Point`, `Description`, `Parent Task` (link) |
| **Roadmap** | `YOUR_ROADMAP_TABLE_ID` | Timeline milestones with quarterly grouping | `Milestone Item`, `Date`, `Date 2`, `Quarter` (Q1-Q4 2026, 2027), `Pillars` (link), `Parent items` (link) |
| **Master Sprint - New** | `YOUR_MASTER_SPRINT_TABLE_ID` | Sprint definitions with date ranges | *(to be explored on first use)* |

**Data Model Relationships:**
```
Pillar (1) ──< (N) Module ──< (N) Issue ──< (N) Subtask
   │                                    │
   └── (N) Roadmap                      └── (N) Subtask (via "Sub Task" link field)
```

### 3.3 Lark Docs Structure

| Document Type | Location Pattern | Purpose |
|---------------|-----------------|---------|
| PRDs | Lark Docs — searchable by feature name | Feature requirements |
| OKRs | Lark Doc (searched by name) | Quarterly objectives and key results |
| Product Wiki | Lark Wiki space | Living product documentation |
| Changelog | Lark Doc | Per-sprint shipped feature summaries |
| Meeting Transcripts | Lark Minutes (妙记) | AI-generated meeting notes |
| User Archetypes | Lark Doc | JTBD, personas, segments |

---

## 4. Subagent Definitions

### 4.1 PM Ops (Orchestrator)

**Role:** Single entry point. Receives all user requests, decomposes them into subtasks, delegates to subagents in
parallel where possible, aggregates results, and returns consolidated output to the user.

**Delegation Model:**
- Independent subtasks → dispatched in parallel, results merged
- Dependent subtasks (output of A feeds B) → sequential chain
- PM Ops decides per-request

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `summarize-meeting` | phuryn/pm-execution | Meeting transcript → decisions + action items |
| `sprint-plan` | phuryn/pm-execution | Sprint planning with capacity estimation |
| `retro` | phuryn/pm-execution | Structured sprint retrospective |
| `release-notes` | phuryn/pm-execution | User-facing release notes from tickets/changelogs |
| `stakeholder-map` | phuryn/pm-execution | Power × Interest grid + communication plan |
| `prioritization-frameworks` | phuryn/pm-execution | Reference: ICE, RICE, MoSCoW, Kano, etc. |
| `user-stories` | phuryn/pm-execution | User stories with 3 C's + INVEST |
| `job-stories` | phuryn/pm-execution | JTBD-format job stories |
| `wwas` | phuryn/pm-execution | Why-What-Acceptance backlog items |
| `pre-mortem` | phuryn/pm-execution | Risk analysis pre-launch |
| `internal-comms` | anthropics/skills | Internal communication drafting |
| `marketing-plan` | coreyhaines31/marketingskills | AARRR-structured marketing plan |
| `optimize-goal` | this repo | Review/enhance a `goal.md` task spec — clarifies ambiguity via targeted questions, rewrites on approval |

**Tools Access:**
- `lark-cli base +...` — read/write Issues, Pillars, Modules, Subtask, Roadmap, Master Sprint tables
- `lark-cli docs +...` — read/write PRDs, OKRs, wiki, changelogs
- `lark-cli im +...` — send messages to Lark group chats
- `lark-cli wiki +...` — manage wiki structure
- PostHog REST API — read dashboards and analytics data

**Boundaries:**
- Does NOT perform deep data analysis (delegates to Data Analyst)
- Does NOT write marketing copy or decks (delegates to GTM Specialist)
- Does NOT conduct user research (delegates to User Researcher)
- Does NOT handle customer communications directly (delegates to Customer Service)
- Does NOT generate test plans (delegates to QA)

---

### 4.2 Associate PM

**Role:** PRD authoring, OKR drafting, feature prioritization, document generation (pptx, docx, xlsx), roadmap
management, pre-mortems on launch plans.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `create-prd` | phuryn/pm-execution | 8-section PRD template |
| `brainstorm-okrs` | phuryn/pm-execution | Team-level OKRs aligned to company objectives |
| `outcome-roadmap` | phuryn/pm-execution | Feature list → outcome-focused roadmap |
| `prioritize-features` | phuryn/pm-product-discovery | Backlog prioritization by impact/effort/risk |
| `analyze-feature-requests` | phuryn/pm-product-discovery | Categorize and triage feature requests |
| `product-strategy` | phuryn/pm-product-strategy | 9-section Product Strategy Canvas |
| `lean-canvas` | phuryn/pm-product-strategy | Startup lean canvas |
| `business-model` | phuryn/pm-product-strategy | Business Model Canvas |
| `pre-mortem` | phuryn/pm-execution | Launch risk analysis |
| `pptx` | anthropics/skills | Slide deck generation (.pptx) |
| `docx` | anthropics/skills | Word document generation |
| `xlsx` | anthropics/skills | Spreadsheet generation |

**Tools Access:**
- `lark-cli base +...` — read/write Pillars, Modules, Issues, Roadmap tables
- `lark-cli docs +...` — create/update PRDs, OKRs, changelog documents
- `lark-cli wiki +...` — update product wiki

**Key Outputs:**
- PRDs in standard 8-section format
- OKR documents aligned to pillars
- Sprint demo decks (.pptx)
- Changelog documents
- Updated product wiki (compound after each sprint)

---

### 4.3 Data Analyst (Business Intelligence)

**Role:** SQL query generation, cohort analysis, A/B test analysis, North Star metric definition, metrics dashboard
design, KPI tracking setup.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `sql-queries` | phuryn/pm-data-analytics | Generate SQL from natural language (BigQuery, PostgreSQL, MySQL) |
| `cohort-analysis` | phuryn/pm-data-analytics | Retention curves, feature adoption trends |
| `ab-test-analysis` | phuryn/pm-data-analytics | Statistical significance, sample size, ship/extend/stop |
| `metrics-dashboard` | phuryn/pm-product-discovery | North Star + input metrics + alert thresholds |
| `north-star-metric` | phuryn/pm-marketing-growth | North Star Metric + business game classification |
| `analytics` | coreyhaines31/marketingskills | Event tracking setup, audit |
| `ab-testing` | coreyhaines31/marketingskills | Experiment design |

**Tools Access:**
- PostHog REST API — read event analytics, dashboards
- `lark-cli base +...` — read Issues, Modules, Pillars tables for KPI context
- SQL databases (via `sql-queries` skill)

**Key Outputs:**
- KPI definitions per pillar and module
- Cohort retention reports
- A/B test analysis with statistical confidence
- Metrics dashboard designs
- Sprint progress analytics (for sprint planning)

---

### 4.4 GTM Specialist (Go-to-Market)

**Role:** Marketing deck preparation, beachhead segment analysis, ICP definition, growth loop design, GTM strategy,
competitive analysis, positioning, sales enablement decks.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `gtm-strategy` | phuryn/pm-go-to-market | Full GTM: channels, messaging, metrics, launch plan |
| `beachhead-segment` | phuryn/pm-go-to-market | First market segment identification |
| `ideal-customer-profile` | phuryn/pm-go-to-market | ICP with demographics, JTBD, needs |
| `growth-loops` | phuryn/pm-go-to-market | Sustainable growth flywheels |
| `gtm-motions` | phuryn/pm-go-to-market | Evaluate PLG vs sales-led vs hybrid |
| `competitive-battlecard` | phuryn/pm-go-to-market | Sales-ready competitor comparison |
| `marketing-ideas` | phuryn/pm-marketing-growth | Creative, cost-effective marketing ideas |
| `positioning-ideas` | phuryn/pm-marketing-growth | Differentiated positioning from competitors |
| `value-prop-statements` | phuryn/pm-marketing-growth | Value props for sales, marketing, onboarding |
| `product-name` | phuryn/pm-marketing-growth | Product naming aligned to brand |
| `competitor-analysis` | phuryn/pm-market-research | Competitor strengths/weaknesses/differentiation |
| `market-sizing` | phuryn/pm-market-research | TAM, SAM, SOM estimation |
| `launch` | coreyhaines31/marketingskills | Product launch planning |
| `sales-enablement` | coreyhaines31/marketingskills | Sales decks, one-pagers, objection docs, demo scripts |
| `competitors` | coreyhaines31/marketingskills | Competitor comparison pages |
| `pricing` | coreyhaines31/marketingskills | Pricing, packaging, monetization |
| `deck-generator` | ericosiu/ai-marketing-skills | AI-generated slide decks with consistent styles |
| `sales-playbook` | ericosiu/ai-marketing-skills | Value-based pricing framework |
| `pptx` | anthropics/skills | Slide deck file generation |

**Tools Access:**
- `lark-cli docs +...` — read User Archetypes, PRDs, wiki for product context
- `lark-cli base +...` — read Pillars, Modules for feature context
- File system — generate .pptx files

**Key Outputs:**
- Marketing pitch decks (.pptx)
- Competitive battlecards
- GTM strategy documents
- Launch plans
- Positioning statements

---

### 4.5 User Researcher

**Role:** Persona creation, user segmentation, journey mapping, interview script preparation, interview summarization,
sentiment analysis, customer research synthesis.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `user-personas` | phuryn/pm-market-research | Refined personas from research data |
| `market-segments` | phuryn/pm-market-research | 3-5 segments with demographics + JTBD |
| `user-segmentation` | phuryn/pm-market-research | Behavior/JTBD-based segmentation |
| `customer-journey-map` | phuryn/pm-market-research | End-to-end journey with touchpoints + pain points |
| `interview-script` | phuryn/pm-product-discovery | Structured interview scripts (Mom Test principles) |
| `summarize-interview` | phuryn/pm-product-discovery | Transcript → JTBD, satisfaction signals, actions |
| `sentiment-analysis` | phuryn/pm-market-research | Feedback sentiment + theme extraction |
| `customer-research` | coreyhaines31/marketingskills | Customer research synthesis |

**Tools Access:**
- `lark-cli docs +...` — read meeting transcripts (妙记), user archetype documents; write research outputs
- `lark-cli base +...` — read Feedback table for user-submitted issues

**Key Outputs:**
- User archetype documents (JTBD-based)
- Customer journey maps
- Interview scripts and summaries
- Sentiment analysis reports
- User segmentation reports

---

### 4.6 Customer Service

**Role:** Help center article generation from PRDs/wiki, triage issue creation for help center integrations, feedback
monitoring and alerting, onboarding email sequences, churn prevention analysis.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `emails` | coreyhaines31/marketingskills | Email sequences, drip campaigns, lifecycle emails |
| `onboarding` | coreyhaines31/marketingskills | Post-signup activation optimization |
| `churn-prevention` | coreyhaines31/marketingskills | Cancel flows, save offers, dunning |
| `grammar-check` | phuryn/pm-toolkit | Grammar, logic, flow checking |
| `content-ops` | ericosiu/ai-marketing-skills | Content quality scoring, editorial pipeline |
| `lark-im` | existing lark skill | Send messages to Lark group chats |
| `lark-task` | existing lark skill | Create/manage Lark tasks for triage |

**Tools Access:**
- `lark-cli docs +...` — read PRDs, wiki for help article generation
- `lark-cli base +...` — create triage issues in Issues table; read Feedback table
- `lark-cli im +...` — send alerts to the configured user reports group chat
- Lark Minutes (妙记) — for meeting-based support context

**Key Outputs:**
- Help center articles (generated from PRDs/wiki)
- Triage issues (auto-created from help center updates and user feedback)
- Onboarding email sequences (content + scheduling spec)
- User feedback alerts to Lark group chat
- Changelog-triggered user communications

---

### 4.7 QA

**Role:** Test scenario generation from user stories, web application testing guidance, quality gate during sprint
planning.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `test-scenarios` | phuryn/pm-execution | Happy paths, edge cases, error handling |
| `webapp-testing` | anthropics/skills | Web application testing with Playwright |

**Tools Access:**
- `lark-cli base +...` — read Issues table for feature specifications and acceptance criteria
- `lark-cli docs +...` — read PRDs for testable requirements

**Key Outputs:**
- Test scenarios for features (from user stories/PRDs)
- QA reports for sprint planning (which issues are ready for QA)
- Bug reproduction steps

---

### 4.8 UI/UX Designer

**Role:** Wireframe/design spec production, design system audits, accessibility review.
On explicit request, generates or redesigns real UI code (React/Vue/Svelte) via
taste-skill rather than just describing the design.

**Core Skills:**

| Skill | Source | Purpose |
|-------|--------|---------|
| `design-taste-frontend` | leonxlnx/taste-skill | Generate new UI from scratch |
| `redesign-existing-projects` | leonxlnx/taste-skill | Audit and improve an existing UI |
| `image-to-code` | leonxlnx/taste-skill | Screenshot/mock → implemented UI code |
| `high-end-visual-design` | leonxlnx/taste-skill | "Polished, calm, expensive" visual style |
| `minimalist-ui` | leonxlnx/taste-skill | Notion/Linear-style restrained design |
| `industrial-brutalist-ui` | leonxlnx/taste-skill | Industrial/Swiss-typography style |
| `stitch-design-taste` | leonxlnx/taste-skill | Google Stitch-compatible design rules |
| `full-output-enforcement` | leonxlnx/taste-skill | Prevents truncated generation output |

**Tools Access:**
- `lark-cli base +...` — read Issues table for feature specifications and acceptance criteria (read-only)
- `lark-cli docs +...` — read PRDs for design context

**Key Outputs:**
- Wireframe / design spec descriptions per feature
- Design system audits
- Accessibility review
- Generated or redesigned UI code (only when implementation is explicitly requested)

---

## 5. PM Ops Orchestration Protocol

### 5.1 Request Flow

```
1. User → PM Ops: natural language request
2. PM Ops decomposes into subtask(s):
   a. Identifies which subagents are needed
   b. Determines dependencies (parallel vs sequential)
   c. Extracts parameters (dates, sprint names, feature names, etc.)
3. PM Ops dispatches:
   a. Parallel subtasks → dispatched simultaneously
   b. Sequential subtasks → dispatched in order, feeding output
4. PM Ops aggregates results into a single response
5. PM Ops → User: consolidated output
```

### 5.2 Routing Heuristics

| Request Signals | Route To |
|-----------------|----------|
| PRD, OKR, roadmap, sprint planning, deck creation, changelog | Associate PM |
| KPIs, metrics, analytics, A/B test, cohort, SQL, dashboard | Data Analyst |
| Marketing deck, GTM, launch, pricing, competitors, positioning | GTM Specialist |
| Personas, interviews, journey maps, segmentation, feedback analysis | User Researcher |
| Help center, emails, onboarding, churn, feedback alerts | Customer Service |
| Test scenarios, QA reports, bug reproduction | QA |
| Wireframes, mockups, UI/UX design, design system, redesign existing UI, accessibility review | UI/UX Designer |
| Cross-domain (e.g., sprint report + marketing deck) | Multiple subagents (parallel) |

### 5.3 Core Document Access Protocol

All subagents read/write core documents through their tools. When writing:
1. **Lark Base writes:** Use `lark-cli base +...` against your configured Lark base (token: `YOUR_LARK_BASE_TOKEN`)
2. **Lark Doc writes:** Use `lark-cli docs +...` with appropriate workspace/wiki context
3. **No direct file writes** unless generating .pptx/.xlsx/.docx output files

When reading:
1. Always fetch latest state before acting (no stale assumptions)
2. Cross-reference: an issue's Module/Pillar context requires reading the linked tables

---

## 6. Use Case Walkthroughs

### USE CASE 1: Setup KPI Per Pillar & Product

**User request:** "Setup North Star metric & KPIs for each pillar and product. Add them to Lark base, make them visible,
enforce ownership, ensure tracking."

**PM Ops orchestration:**

1. **Parallel dispatch:**
   - **Associate PM:** Read Pillars and Modules tables to understand current structure. Identify where KPI fields should
     be added (Modules table already has `North Star Metric` text field). Propose field additions or a dedicated KPI
     tracking approach.
   - **Data Analyst:** Use `north-star-metric` and `metrics-dashboard` skills to define the right North Star + input
     metrics for each pillar/module based on business game classification. Use `sql-queries` to validate data
     availability. Recommend PostHog dashboard configurations.

2. **PM Ops aggregates:**
   - KPI definitions per pillar/module
   - "Where to add them" proposal (field additions to Lark Base tables)
   - "How to make visible" recommendations (Lark Base dashboard views + PostHog dashboards)
   - "How to enforce ownership" recommendations (PM assignment per Pillar linked to KPI accountability)
   - "How to track" recommendations (automated PostHog reporting + sprint review checkpoints)

---

### USE CASE 2: Marketing Deck Preparation

**User request:** "Given User Archetypes and JTBD, prepare a pitch deck in .pptx for our target customer segments."

**PM Ops orchestration:**

1. **Sequential dispatch:**
   - **User Researcher:** Read User Archetype documents, extract JTBD per customer segment persona.
   - **GTM Specialist** (receives User Researcher output): Map JTBD to product features. Use `pptx` + `deck-generator`
     skills to create segment-specific slides. Generate .pptx file.
   - **Associate PM** (parallel with GTM): Validate feature claims against current PRDs/wiki to ensure accuracy.

2. **PM Ops aggregates:** Deliver .pptx file + summary of which features map to which segment's JTBD.

---

### USE CASE 3: Onboarding Email Sequence

**User request:** "Draft onboarding email sequence content and scheduling for new signups."

**PM Ops orchestration:**

1. **Single dispatch → Customer Service:**
   - Read PRDs, wiki, and User Archetypes to understand product value props.
   - Use `emails` skill to draft sequence (welcome → first value → advanced features → advocacy).
   - Use `onboarding` skill to align content with activation milestones.
   - Output: email content drafts + scheduling spec (Day 0, Day 3, Day 7, Day 14, Day 30) with trigger conditions.

2. **PM Ops:** Present content + schedule. User plugs into email engine.

---

### USE CASE 4: Sprint Planning (End-to-End)

**User request:** "Review current sprint progress, reprioritize, move carryover, create sprint report, send to Lark
group, create demo deck, create changelog, compound wiki."

**PM Ops orchestration:**

1. **Sequential — Phase 1 (Assessment):**
   - **Data Analyst:** Read Issues table for current sprint. Use `sql-queries` to compute: completion %, velocity,
     blocked items, carryover count. Identify items needing attention.
   - **QA:** Cross-reference Issues with `Product Status = Ready for QA` to flag testing bottlenecks.

2. **Sequential — Phase 2 (Reprioritization, receives Phase 1 output):**
   - **Associate PM:** Use `prioritize-features` to suggest reprioritization. Move carryover items to next sprint in
     Issues table (update `Active Sprint` field). Create sprint report in Lark Doc. Create demo deck (.pptx) highlighting
     shipped features.

3. **Parallel — Phase 3 (Communication):**
   - **PM Ops:** Send sprint report to specified Lark group chat via `lark-cli im`.
   - **Associate PM:** Create changelog document (Lark Doc) covering shipped features.
   - **Associate PM:** Compound product wiki — update relevant PRDs with confirmed shipped features.

---

### USE CASE 5: Help Center

**User request:** "Generate help center articles from PRDs/wiki, create triage issues for integration, monitor user
feedback."

**PM Ops orchestration:**

1. **Sequential — Phase 1 (Article generation):**
   - **Customer Service:** Read all PRDs and product wiki. Use `content-ops` + `grammar-check` to generate help center
     article drafts. Output article list.

2. **Sequential — Phase 2 (Integration issues):**
   - **Customer Service:** For each new article, create a triage issue in the Issues table (`Issue Type = Task`,
     `Bucket = Product`, assigned to appropriate developer) for help center integration.

3. **Ongoing — Phase 3 (Monitoring, triggered periodically or by PM Ops):**
   - **Customer Service:** Poll Feedback table for new user submissions. For each new item, send message to the
     configured user reports Lark group chat, then create triage issue in Issues table.

---

## 7. Assumptions & Open Questions

### Assumptions

| # | Assumption | Status | Rationale |
|---|-----------|--------|-----------|
| A1 | KPI tracking lives in the existing Modules table (`North Star Metric` field) + PostHog dashboards. No separate KPI table needed. | Confirmed | Modules already has the field; PostHog handles quantitative tracking. |
| A2 | PostHog has no CLI. Agents use the PostHog REST API via `curl`. | Resolved | No `posthog` CLI found. Agents self-discover credentials from project `.env` files. |
| A3 | Lark Docs for PRDs, OKRs, wiki, and user archetypes are discoverable via `lark-cli docs +search`. | Confirmed | Agents self-discover doc tokens on first use — no manual registry needed. |
| A4 | The email engine is external. Subagents produce content + scheduling specs; a human or separate system executes the sends. | Confirmed | Subagents output Day 0/3/7/14/30 sequences with trigger conditions for your email engine. |
| A5 | QA test environment URLs are provided by the user. Agents ask for the environment URL at runtime. | Confirmed | Avoids hardcoding project-specific ports and staging URLs. |
| A6 | A user reports Lark group chat exists and the Lark bot has send permission. | Pending verification | Customer Service agent self-discovers the chat ID via `lark-cli im +chat-search` on first use. |
| A7 | Skills are installed to `~/.claude/skills/` for Claude Code, equivalent path for OpenCode. | Resolved | Install commands in Section 0.3. |
| A8 | This spec targets both Claude Code and OpenCode. Claude Code is the primary implementation. Agent files use Claude Code format (markdown frontmatter). | Resolved | Single `.md` file per agent, stored globally in `~/.claude/agents/`. Same files used by both platforms. |

### Open Questions

| # | Question | Status | Impact |
|---|----------|--------|--------|
| Q1 | What is the PostHog project ID / API key? | Self-resolving | Data Analyst searches project `.env` files on first use; falls back to asking the user. |
| Q2 | What is the Lark group chat name/ID for user reports? | Self-resolving | Customer Service runs `lark-cli im +chat-search` on first use. Set `USER_REPORTS_CHAT_NAME` in config.md to help it. |
| Q3 | What are the exact Lark Doc tokens for User Archetypes, OKRs, Product Wiki, PRDs? | Self-resolving | All agents run `lark-cli docs +search` on first use to discover doc IDs dynamically. |
| Q4 | Which email engine does the team use (SendGrid, Mailchimp, Customer.io)? | Open | Customer Service needs this to format scheduling specs correctly. |
| Q5 | What are the local and staging environment URLs for QA testing? | Open | QA agent will ask the user at runtime. |
| Q6 | Are existing PostHog dashboards in place, or is everything greenfield? | Open | Determines Data Analyst scope: configure from scratch vs. extend existing dashboards. |

---

## 8. Implementation Notes

### 8.1 Agent Contract

Each subagent must implement:

1. **Persona:** Role description, domain expertise, boundaries
2. **Skills:** Curated list from Section 4 — loaded on demand by reading `~/.claude/skills/<name>/SKILL.md`
3. **Tools:** Exact CLI commands and APIs available
4. **Input contract:** What parameters/data it needs to operate
5. **Output contract:** What format its results must follow

### 8.2 PM Ops Contract

PM Ops must implement:

1. **Intent classification:** Parse user request → identify required subagent(s)
2. **Dependency graph:** Determine parallel vs sequential execution
3. **Parameter extraction:** Pull sprint names, dates, feature slugs, etc. from natural language
4. **Skill routing:** Name the specific skill to invoke in the delegation prompt (hybrid model — see 8.5)
5. **Aggregation:** Merge subagent outputs into coherent user-facing response
6. **Error handling:** If a subagent fails, report which subagent failed and why, continue with others

### 8.3 Framework Mapping

| Spec Concept | Claude Code Implementation | OpenCode Implementation |
|-------------|---------------------------|------------------------|
| PM Ops entry point | `/minions` skill — `~/.claude/skills/minions/SKILL.md` | Same skill file, loaded via OpenCode skill path |
| PM Ops delegation | `Agent` tool — spawns `minions-*` agents by name | `@minions-*` mention or `task` tool |
| Associate PM | `~/.claude/agents/minions-associate-pm.md` | Same file |
| Data Analyst | `~/.claude/agents/minions-data-analyst.md` | Same file |
| GTM Specialist | `~/.claude/agents/minions-gtm-specialist.md` | Same file |
| User Researcher | `~/.claude/agents/minions-user-researcher.md` | Same file |
| Customer Service | `~/.claude/agents/minions-customer-service.md` | Same file |
| QA | `~/.claude/agents/minions-qa.md` | Same file |
| Core Documents | `lark-cli` (configured via `lark-cli auth login`) | Same |

Agent files use Claude Code markdown frontmatter format. A single file serves both platforms.

### 8.4 Claude Code Implementation Details

**Entry point:** User types `/minions` in any Claude Code session. The skill at `~/.claude/skills/minions/SKILL.md` activates PM Ops for that turn.

**Agent naming convention:** All subagents are prefixed `minions-` (e.g., `minions-associate-pm`) to avoid collisions with other global agents.

**Skill loading model (hybrid):**
- PM Ops names the specific skill to invoke in its delegation prompt: `"Use the 'create-prd' skill — read ~/.claude/skills/create-prd/SKILL.md and follow it."`
- Each subagent's file also lists its full skills inventory as a reference and fallback when PM Ops does not name a skill.

**Config self-discovery:** No hardcoded tokens beyond the Lark base token (already public within the team). Agents discover PostHog credentials, Lark group chat IDs, and Lark Doc tokens at runtime using their available CLI tools.

**File locations (after install):**

```
~/.claude/
├── skills/
│   └── minions/
│       └── SKILL.md          ← PM Ops (entry point via /minions)
└── agents/
    ├── minions-associate-pm.md
    ├── minions-data-analyst.md
    ├── minions-gtm-specialist.md
    ├── minions-user-researcher.md
    ├── minions-customer-service.md
    └── minions-qa.md
```

### 8.5 Skill Installation

See Section 0.3 for the full install commands. Summary by agent:

| Agent | Skill sources required |
|-------|----------------------|
| PM Ops | phuryn/pm-execution |
| Associate PM | phuryn/pm-execution, phuryn/pm-product-discovery, phuryn/pm-product-strategy, anthropics/skills (pptx, docx, xlsx) |
| Data Analyst | phuryn/pm-data-analytics, phuryn/pm-marketing-growth, phuryn/pm-product-discovery, coreyhaines31/marketingskills |
| GTM Specialist | phuryn/pm-go-to-market, phuryn/pm-marketing-growth, phuryn/pm-market-research, coreyhaines31/marketingskills, ericosiu/ai-marketing-skills, anthropics/skills (pptx) |
| User Researcher | phuryn/pm-market-research, phuryn/pm-product-discovery, coreyhaines31/marketingskills |
| Customer Service | phuryn/pm-toolkit, coreyhaines31/marketingskills, ericosiu/ai-marketing-skills |
| QA | phuryn/pm-execution, anthropics/skills (webapp-testing) |

---

## 9. Success Metrics

| Metric | Target | Measured By |
|--------|--------|-------------|
| Time from sprint end to sprint report sent | < 2 hours | Lark message timestamp |
| Time from PRD completion to help center article published | < 1 day | Triage issue creation date |
| Time from user feedback submission to triage issue created | < 1 hour | Feedback table → Issues table latency |
| Marketing deck turnaround | < 4 hours | File creation timestamp |
| KPI definitions per pillar | 100% of pillars have defined KPIs | Pillars table audit |
| Onboarding email sequence completeness | 5-email sequence drafted | Email content artifacts |

---

## Appendix A: Lark Base Table Schema Reference

### A.1 — Pillars (`YOUR_PILLARS_TABLE_ID`)

| Field | Type | Description |
|-------|------|-------------|
| `Pillar Name` | text | Strategic pillar name |
| `Strategic Goal` | text | Goal statement for the pillar |
| `Description` | text | Detailed description |
| `Health` | select | 🟢 On Track / 🟡 At Risk / 🔴 Off Track |
| `PM` | user | Product Manager owner |
| `Designer` | user (multi) | Designer(s) assigned |
| `Engineers` | user (multi) | Engineer(s) assigned |
| `Link to PRD` | URL | Link to pillar PRD |
| `Issues` | link → Issues | Linked issues |
| `Roadmap` | link → Roadmap | Linked roadmap items |
| `Parent items` | link → Pillars | Self-referencing hierarchy |

### A.2 — Modules (`YOUR_MODULES_TABLE_ID`)

| Field | Type | Description |
|-------|------|-------------|
| `Module Name` | text | Product module name |
| `Status` | select | Concept / Alpha / Beta / Active / Sunset |
| `North Star Metric` | text | Key metric for this module |
| `Description` | text | Module description |
| `Documentation` | URL | Link to module docs |
| `Launch Date` | datetime | Planned or actual launch date |
| `Pillar` | link → Pillars | Parent pillar |
| `Issues` | link → Issues | Linked issues |

### A.3 — Issues (`YOUR_ISSUES_TABLE_ID`)

| Field | Type | Description |
|-------|------|-------------|
| `Issue Name` | text | Issue title |
| `Issue Type` | select | Feature / Bug / Task / Improvement / Tech Debt |
| `Priority` | select | P0 HIGH / P1 Medium / P2 Low |
| `Product Status` | select | Discovery → Ready for Design → In Design → Ready for Dev → Dev WIP → Dev Review → Ready for QA → In QA → Done / BLOCKED |
| `Ops Status` | select | Ops - To do / In Progress / To Review / In Review / Done / Rejected / BLOCKED |
| `Active Sprint` | select | Current or future sprint assignment |
| `Initial Sprint` | select | Original sprint assignment |
| `Assignee` | user (multi) | Assigned team members |
| `Points` | number | Story points |
| `Bucket` | select | Product / Operations |
| `Pillar` | link → Pillars | Parent pillar |
| `Module` | link → Modules | Parent module |
| `Sub Task` | link → Subtask | Linked subtasks |
| `Start Date` | datetime | Planned start |
| `End Date` | datetime | Planned end |
| `Initial Effort` | select | Easy / Medium / Hard / Super Hard |
| `Description` | text | Issue description |
| `Definition of Done` | text | Acceptance criteria |
| `Attachment` | attachment | File attachments |
| `Record Link` | URL | External reference link |

### A.4 — Subtask (`YOUR_SUBTASK_TABLE_ID`)

| Field | Type | Description |
|-------|------|-------------|
| `Subtask Name` | text | Subtask title |
| `Status` | select | To Do / WIP / Ready for QA / Done |
| `Assignee` | user | Assigned person |
| `Story Point` | number | Effort estimate |
| `Description` | text | Subtask description |
| `Parent Task` | link → Issues | Parent issue |
| `Attachment` | attachment | File attachments |

### A.5 — Roadmap (`YOUR_ROADMAP_TABLE_ID`)

| Field | Type | Description |
|-------|------|-------------|
| `Milestone Item` | text | Milestone description |
| `Date` | datetime | Start or single date |
| `Date 2` | datetime | End date (if range) |
| `Quarter` | select (multi) | Q1-Q4 2026 / 2027 |
| `Pillars` | link → Pillars | Linked pillars |
| `Parent items` | link → Roadmap | Self-referencing hierarchy |
