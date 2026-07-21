# UI/UX Designer Role Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a 7th minions subagent role, `minions-ui-ux-designer`, that produces design specs/wireframes/audits by default and generates or redesigns real UI code via `leonxlnx/taste-skill` only when explicitly asked, then wire it into every place the other 6 roles are documented and routed.

**Architecture:** This is a documentation/config change to a Claude Code subagent-team repo — no application code, no test framework. Each "task" edits one artifact (new agent file, orchestrator routing table, README, spec.md, install.sh) and is verified with `grep`/`bash -n` checks instead of unit tests, since correctness here means "the new role is defined consistently everywhere it needs to appear."

**Tech Stack:** Markdown (agent/skill definitions), Bash (`install.sh`), `npx skills add` for external skill packages.

## Global Constraints

- New agent name: `minions-ui-ux-designer` (file `agents/minions-ui-ux-designer.md`).
- Model: `claude-sonnet-4-6` (matches every other agent file).
- Skill set (exactly these 8, in this order, everywhere they're listed):
  `design-taste-frontend`, `redesign-existing-projects`, `image-to-code`,
  `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`,
  `stitch-design-taste`, `full-output-enforcement`. All installed from
  `https://github.com/Leonxlnx/taste-skill` via `--skill <name>`.
- Lark access: read-only Issues table only (`YOUR_ISSUES_TABLE_ID`), same pattern as
  `minions-qa`. No writes, no new Lark table.
- Boundaries text (verbatim, reused in the agent file and referenced in spec.md):
  - Does NOT write PRDs/acceptance criteria → `minions-associate-pm`
  - Does NOT do user research, personas, or journey maps → `minions-user-researcher`
  - Does NOT write test scenarios → `minions-qa`
  - Does NOT implement backend/business logic — UI layer only
- Hybrid behavior rule (verbatim, must appear in the agent file): default to a text
  design spec; only invoke the code-writing skills (`design-taste-frontend`,
  `redesign-existing-projects`, `image-to-code`) when the user explicitly asks for
  implementation (e.g. "build this", "redesign the actual component", "generate the
  code"), not just a design opinion.
- Source spec: `docs/superpowers/specs/2026-07-21-ui-ux-designer-design.md`.

---

### Task 1: Create the new agent file

**Files:**
- Create: `agents/minions-ui-ux-designer.md`

**Interfaces:**
- Produces: agent name `minions-ui-ux-designer`, the 8-skill table (skill name →
  `~/.claude/skills/<skill-name>/SKILL.md` path), used verbatim by Tasks 2 and 4 when
  they reference this agent's skill list.

- [ ] **Step 1: Write the agent file**

Create `agents/minions-ui-ux-designer.md` with this exact content:

```markdown
---
name: minions-ui-ux-designer
description: UI/UX Designer — wireframe specs, design system audits, accessibility review; generates or redesigns UI code via taste-skill only when explicitly requested
model: claude-sonnet-4-6
---

You are the **minions UI/UX Designer** agent — a virtual UI/UX Designer. You produce wireframe descriptions, design specs, design system audits, and accessibility reviews. When the user explicitly asks for implementation (not just a design opinion), you generate or redesign real UI code using the taste-skill skills below.

## LARK BASE (read-only)

> Read token and table IDs from `~/.claude/skills/minions/config.md`. If not present, self-discover via `lark-cli`.

- **Base token:** `YOUR_LARK_BASE_TOKEN`
- **Tables you read:**
  - Issues: `YOUR_ISSUES_TABLE_ID` — feature specifications and acceptance criteria

## SKILLS

When PM Ops names a skill, read the skill file fully before executing.

| Skill | Path | Purpose |
|-------|------|---------|
| `design-taste-frontend` | `~/.claude/skills/design-taste-frontend/SKILL.md` | Generate new UI from scratch (React/Vue/Svelte, design inference, variance/motion/density dials) |
| `redesign-existing-projects` | `~/.claude/skills/redesign-existing-projects/SKILL.md` | Audit and improve an existing UI |
| `image-to-code` | `~/.claude/skills/image-to-code/SKILL.md` | Screenshot/mock → implemented UI code |
| `high-end-visual-design` | `~/.claude/skills/high-end-visual-design/SKILL.md` | "Polished, calm, expensive" visual style |
| `minimalist-ui` | `~/.claude/skills/minimalist-ui/SKILL.md` | Notion/Linear-style restrained design |
| `industrial-brutalist-ui` | `~/.claude/skills/industrial-brutalist-ui/SKILL.md` | Industrial/Swiss-typography style |
| `stitch-design-taste` | `~/.claude/skills/stitch-design-taste/SKILL.md` | Google Stitch-compatible design rules |
| `full-output-enforcement` | `~/.claude/skills/full-output-enforcement/SKILL.md` | Prevents truncated generation output |

## WHEN TO GENERATE CODE VS SPEC ONLY

Default to a text design spec or wireframe description — do not write or modify code
unless asked. Only invoke `design-taste-frontend`, `redesign-existing-projects`, or
`image-to-code` to actually write/modify UI code when the user explicitly asks for
implementation (e.g. "build this", "redesign the actual component", "generate the
code"), not just a design opinion or critique.

## TOOLS

```bash
# Read Issues for feature spec and acceptance criteria
lark-cli base +read --base YOUR_LARK_BASE_TOKEN --table YOUR_ISSUES_TABLE_ID

# Read PRDs for design context
lark-cli docs +search --query "<feature>"
```

## KEY OUTPUTS

- Wireframe / design spec descriptions per feature (layout, hierarchy, states, interaction notes)
- Design system audits (consistency, spacing/typography rules, component reuse)
- Accessibility review (contrast, focus order, ARIA, keyboard navigation)
- Generated or redesigned UI code — only when implementation is explicitly requested

## BOUNDARIES

- Does NOT write PRDs or acceptance criteria → `minions-associate-pm`
- Does NOT do user research, personas, or journey maps → `minions-user-researcher`
- Does NOT write test scenarios → `minions-qa`
- Does NOT implement backend or business logic — UI layer only
```

- [ ] **Step 2: Verify the file was created correctly**

Run: `test -f "agents/minions-ui-ux-designer.md" && head -5 "agents/minions-ui-ux-designer.md"`
Expected: prints the YAML frontmatter starting with `---` / `name: minions-ui-ux-designer`.

- [ ] **Step 3: Commit**

```bash
git add agents/minions-ui-ux-designer.md
git commit -m "Add minions-ui-ux-designer agent definition"
```

---

### Task 2: Wire the new agent into the PM Ops orchestrator

**Files:**
- Modify: `skills/minions/SKILL.md`

**Interfaces:**
- Consumes: agent name `minions-ui-ux-designer` and the 8-skill list from Task 1.

- [ ] **Step 1: Add a routing table row**

In `skills/minions/SKILL.md`, find this line in the `## ROUTING TABLE` section:

```
| Test scenarios, QA reports, bug reproduction | `minions-qa` | `test-scenarios` |
```

Insert this new row directly after it (before the `| Cross-domain request |` row):

```
| Wireframes, mockups, UI/UX design, design system, redesign existing UI, design critique, accessibility review | `minions-ui-ux-designer` | `design-taste-frontend`, `redesign-existing-projects`, `image-to-code`, `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `stitch-design-taste`, `full-output-enforcement` |
```

- [ ] **Step 2: Add a boundaries line**

Find this line in the `## BOUNDARIES` section:

```
- Test plans → `minions-qa`
```

Insert this line directly after it:

```
- UI/UX design, wireframes, design specs → `minions-ui-ux-designer`
```

- [ ] **Step 3: Verify both edits landed**

Run: `grep -n "minions-ui-ux-designer" skills/minions/SKILL.md`
Expected: two matches — one in the routing table, one in the boundaries list.

- [ ] **Step 4: Commit**

```bash
git add skills/minions/SKILL.md
git commit -m "Route UI/UX design requests to minions-ui-ux-designer"
```

---

### Task 3: Update README.md

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: agent name and 8-skill list from Task 1.

- [ ] **Step 1: Add a row to "The Team" table**

Find this line:

```
| **QA** | Quality assurance | Test scenarios, QA readiness, bug reproduction |
```

Insert this row directly after it:

```
| **UI/UX Designer** | Interface design | Wireframes, design specs, design audits, accessibility review, on-request UI code |
```

- [ ] **Step 2: Add a skills subsection**

Find the end of the `### QA` subsection — the table row:

```
| `webapp-testing` | Web application testing with Playwright |
```

which is followed by a blank line and then `---`. Insert this new subsection between that table and the `---`:

```markdown

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
```

- [ ] **Step 3: Update the "How It Works" diagram**

Find:

```
 ├─── Customer Service  (help center, emails, triage)  │
 └─── QA                (test scenarios, QA reports)  ─┘
```

Replace with:

```
 ├─── Customer Service  (help center, emails, triage)  │
 ├─── QA                (test scenarios, QA reports)    │
 └─── UI/UX Designer    (wireframes, design specs, UI) ─┘
```

- [ ] **Step 4: Update the File Structure tree**

Find:

```
│   └── minions-qa.md                ← QA subagent
```

Replace with:

```
│   ├── minions-qa.md                ← QA subagent
│   └── minions-ui-ux-designer.md    ← UI/UX Designer subagent
```

- [ ] **Step 5: Verify all four edits landed**

Run: `grep -n "UI/UX Designer" README.md`
Expected: at least 4 matches (Team table, subsection header, diagram, file structure).

- [ ] **Step 6: Commit**

```bash
git add README.md
git commit -m "Document UI/UX Designer role in README"
```

---

### Task 4: Update spec.md

**Files:**
- Modify: `spec.md`

**Interfaces:**
- Consumes: agent name and 8-skill list from Task 1.

- [ ] **Step 1: Add subagent definition section 4.8**

Find the end of section 4.7 (the QA subagent definition) — this exact block:

```
**Key Outputs:**
- Test scenarios for features (from user stories/PRDs)
- QA reports for sprint planning (which issues are ready for QA)
- Bug reproduction steps

---

## 5. PM Ops Orchestration Protocol
```

Replace with:

```
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
```

- [ ] **Step 2: Add a routing heuristics row**

Find:

```
| Test scenarios, QA reports, bug reproduction | QA |
| Cross-domain (e.g., sprint report + marketing deck) | Multiple subagents (parallel) |
```

Replace with:

```
| Test scenarios, QA reports, bug reproduction | QA |
| Wireframes, mockups, UI/UX design, design system, redesign existing UI, accessibility review | UI/UX Designer |
| Cross-domain (e.g., sprint report + marketing deck) | Multiple subagents (parallel) |
```

- [ ] **Step 3: Add taste-skill install commands to section 0.3**

Find:

```
# AI marketing skills — used by GTM Specialist, Customer Service
# (manual copy — this repo uses SKILL.md per category, not individual skills)
git clone https://github.com/ericosiu/ai-marketing-skills.git /tmp/ai-marketing-skills
mkdir -p ~/.claude/skills/deck-generator ~/.claude/skills/sales-playbook ~/.claude/skills/content-ops
cp /tmp/ai-marketing-skills/deck-generator/SKILL.md ~/.claude/skills/deck-generator/
cp /tmp/ai-marketing-skills/sales-playbook/SKILL.md ~/.claude/skills/sales-playbook/
cp /tmp/ai-marketing-skills/content-ops/SKILL.md ~/.claude/skills/content-ops/
```
```

Replace with (note: adds a fenced block close plus new fenced block, keeping the
surrounding ` ```bash ` / ` ``` ` structure intact):

```
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
```

- [ ] **Step 4: Add a skill coverage status row**

Find:

```
| `deck-generator`, `sales-playbook`, `content-ops` | ericosiu/ai-marketing-skills | Manual copy (see 0.3) |
```

Insert this row directly after it:

```
| `design-taste-frontend`, `redesign-existing-projects`, `image-to-code`, `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `stitch-design-taste`, `full-output-enforcement` | leonxlnx/taste-skill | Installed individually (see 0.3) |
```

- [ ] **Step 5: Verify all four edits landed**

Run: `grep -n "4.8 UI/UX Designer\|UI/UX Designer\|taste-skill" spec.md | wc -l`
Expected: a positive count (well above 0) confirming the section, routing row, install
commands, and coverage row are all present.

- [ ] **Step 6: Commit**

```bash
git add spec.md
git commit -m "Document UI/UX Designer subagent in spec.md"
```

---

### Task 5: Update install.sh

**Files:**
- Modify: `install.sh`

**Interfaces:**
- Consumes: the 8 taste-skill install names from Task 1's Global Constraints.

- [ ] **Step 1: Renumber the existing step headers from x/4 to x/5**

In `install.sh`, make these four replacements (each `header()` call currently reads
`x/4`, must become `x/5`):

```
header "1/4  Checking prerequisites"
```
→
```
header "1/5  Checking prerequisites"
```

```
header "2/4  Installing minions agents and skill"
```
→
```
header "2/5  Installing minions agents and skill"
```

```
header "3/4  Installing skill packages"
```
→
```
header "3/5  Installing skill packages"
```

```
header "4/4  Checking Lark authentication"
```
→
```
header "5/5  Checking Lark authentication"
```

- [ ] **Step 2: Insert the new taste-skill install step**

Find this block (the end of the ericosiu manual-clone step, right before the Lark
auth check header you just renumbered to `5/5`):

```bash
  else
    warn "Could not clone ericosiu/ai-marketing-skills — install manually:"
    for skill in "${MISSING_ERICOSIU[@]}"; do
      echo "    mkdir -p ~/.claude/skills/$skill && cp <path>/$skill/SKILL.md ~/.claude/skills/$skill/"
    done
  fi
fi

# ── 4. Lark auth check ─────────────────────────────────────────────────────────
header "5/5  Checking Lark authentication"
```

Replace with:

```bash
  else
    warn "Could not clone ericosiu/ai-marketing-skills — install manually:"
    for skill in "${MISSING_ERICOSIU[@]}"; do
      echo "    mkdir -p ~/.claude/skills/$skill && cp <path>/$skill/SKILL.md ~/.claude/skills/$skill/"
    done
  fi
fi

# ── 4. Install taste-skill (UI/UX Designer) ───────────────────────────────────
header "4/5  Installing taste-skill (UI/UX Designer)"

TASTE_SKILLS=(
  "design-taste-frontend" "redesign-existing-projects" "image-to-code"
  "high-end-visual-design" "minimalist-ui" "industrial-brutalist-ui"
  "stitch-design-taste" "full-output-enforcement"
)
for skill in "${TASTE_SKILLS[@]}"; do
  info "Installing taste-skill: $skill ..."
  if npx skills add https://github.com/Leonxlnx/taste-skill --skill "$skill" --quiet 2>/dev/null; then
    ok "taste-skill: $skill"
  else
    warn "taste-skill: $skill — install failed or not available, skipping"
  fi
done

# ── 5. Lark auth check ─────────────────────────────────────────────────────────
header "5/5  Checking Lark authentication"
```

- [ ] **Step 3: Syntax-check the script**

Run: `bash -n install.sh`
Expected: no output, exit code 0.

- [ ] **Step 4: Verify the renumbering and new step are both present**

Run: `grep -n 'header "' install.sh`
Expected: five lines, numbered `1/5` through `5/5` in order, with `4/5` reading
`Installing taste-skill (UI/UX Designer)`.

- [ ] **Step 5: Commit**

```bash
git add install.sh
git commit -m "Install taste-skill packages for UI/UX Designer in install.sh"
```

---

### Task 6: Cross-file consistency check

**Files:**
- None modified — verification only, reading: `agents/minions-ui-ux-designer.md`,
  `skills/minions/SKILL.md`, `README.md`, `spec.md`, `install.sh`.

**Interfaces:**
- Consumes: everything produced in Tasks 1–5.

- [ ] **Step 1: Confirm the agent name is identical everywhere it's referenced**

Run: `grep -rn "minions-ui-ux-designer" agents/ skills/ README.md spec.md`
Expected: matches in `agents/minions-ui-ux-designer.md` (frontmatter `name:`),
`skills/minions/SKILL.md` (routing table + boundaries), and no typos/variants like
`minions-uiux-designer` or `minions-ui-designer` anywhere.

- [ ] **Step 2: Confirm the 8 skill names match exactly across all 4 files**

Run:
```bash
for f in agents/minions-ui-ux-designer.md skills/minions/SKILL.md README.md spec.md; do
  echo "=== $f ==="
  grep -o "design-taste-frontend\|redesign-existing-projects\|image-to-code\|high-end-visual-design\|minimalist-ui\|industrial-brutalist-ui\|stitch-design-taste\|full-output-enforcement" "$f" | sort -u
done
```
Expected: each of the 4 files lists all 8 skill names (order may differ by file, but
no file is missing one and none introduces a 9th name).

- [ ] **Step 3: Confirm install.sh references the same 8 skill names**

Run: `grep -A10 "TASTE_SKILLS=" install.sh`
Expected: the array literally contains the same 8 strings used in Step 2.

- [ ] **Step 4: Final review — no placeholders left behind**

Run: `grep -rn "TBD\|TODO\|FIXME" agents/minions-ui-ux-designer.md skills/minions/SKILL.md README.md spec.md install.sh`
Expected: no output (or only pre-existing matches unrelated to this change — compare
against `git log -p` if any show up to confirm they predate this plan).

- [ ] **Step 5: No commit needed** — this task is read-only verification. If any
check in Steps 1–4 fails, go back to the relevant task, fix the file, re-run that
task's own verification step, commit the fix, then re-run this task's checks.
