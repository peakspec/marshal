# UI/UX Designer role — design spec

Date: 2026-07-21

## Problem

minions currently has 6 subagent roles (Associate PM, Data Analyst, GTM Specialist, User
Researcher, Customer Service, QA), all non-coding — they produce docs, decks, analysis, and
test plans, and integrate with Lark Base/Docs. There is no role that owns UI/UX: wireframes,
design specs, design system audits, accessibility review, or (when explicitly asked) generating
or redesigning actual frontend UI code.

Separately, the user found `leonxlnx/taste-skill`, a skill package for anti-slop frontend
generation (React/Vue/Svelte, GSAP, configurable style dials), and wants its skills wired into
the new role.

## Decisions

1. **Scope: hybrid.** The new `minions-ui-ux-designer` agent primarily produces design
   specs/wireframe descriptions and design critiques (text output, like the other agents), but
   can also generate or redesign actual UI code by invoking taste-skill skills when the user
   explicitly asks for implementation, not just a spec.
2. **Skill set: core set** from taste-skill, skipping `taste-skill-v1` (superseded by v2) and
   `gpt-tasteskill` (GPT/Codex-specific, not applicable to Claude):
   - `design-taste-frontend` — generate new UI from scratch
   - `redesign-existing-projects` — audit + improve existing UI
   - `image-to-code` — screenshot/mock → code
   - `high-end-visual-design` — "polished, calm, expensive" style
   - `minimalist-ui` — Notion/Linear-style restrained design
   - `industrial-brutalist-ui` — industrial/Swiss-style design
   - `stitch-design-taste` — Google Stitch-compatible rules
   - `full-output-enforcement` — prevents truncated generation output

   Image-generation-only skills (`imagegen-frontend-web`, `imagegen-frontend-mobile`,
   `brandkit`) are excluded — out of scope for a text/code-output agent.
3. **Lark access: read-only Issues table**, same pattern as `minions-qa` — reads feature
   context/acceptance criteria, does not write back to Lark Base. No new Lark table is added.
4. **Boundaries** (to avoid overlap with existing roles):
   - Does NOT write PRDs/acceptance criteria → `minions-associate-pm`
   - Does NOT do user research, personas, or journey maps → `minions-user-researcher`
   - Does NOT write test scenarios → `minions-qa`
   - Does NOT implement backend/business logic — UI layer only

## Components

### 1. `agents/minions-ui-ux-designer.md` (new)

Follows the existing agent template (see `agents/minions-qa.md` for the pattern):
frontmatter (`name`, `description`, `model: claude-sonnet-4-6`), `LARK BASE` (read-only Issues),
`SKILLS` table (the 8 skills above, with install paths under
`~/.claude/skills/<skill-name>/SKILL.md`), `TOOLS` (lark-cli read commands), `KEY OUTPUTS`
(wireframe/design specs, design system audits, accessibility reports, generated/redesigned UI
code on request), and `BOUNDARIES` (as above).

No new install.sh logic is needed to deploy this file — `install.sh` already globs
`agents/minions-*.md` into `~/.claude/agents/`.

### 2. `skills/minions/SKILL.md` (PM Ops orchestrator)

Add one row to the `ROUTING TABLE`:

| Request signals | Subagent | Skills to invoke |
|---|---|---|
| Wireframes, mockups, UI/UX design, design system, redesign existing UI, design critique, accessibility review | `minions-ui-ux-designer` | `design-taste-frontend`, `redesign-existing-projects`, `image-to-code`, `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `stitch-design-taste`, `full-output-enforcement` |

### 3. `README.md`

- Add a row to "The Team" table.
- Add a new "### UI/UX Designer" subsection to the "Skills" section, listing the 8 skills.
- Add the new agent to the "How It Works" ASCII diagram.
- Add `minions-ui-ux-designer.md` to the "File Structure" tree.

### 4. `spec.md`

- Add "### 4.8 UI/UX Designer" subagent definition, matching the format of the existing
  "### 4.7 QA" section (Role, Core Skills table, Tools Access, Key Outputs).
- Add a row to "5.2 Routing Heuristics".
- Update "0.3 Install Required Skills" to include the taste-skill install commands.
- Update "0.4 Skill Coverage Status" to reflect the new skills.

### 5. `install.sh`

Add a new install step (pattern similar to the existing `ericosiu/ai-marketing-skills` manual
loop, but using `npx skills add <repo> --skill <name>` since taste-skill is one repo containing
multiple individually-selectable skills):

```bash
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
```

## Testing / verification

This is a documentation/template change (agent definitions + routing tables are markdown, no
executable app logic besides `install.sh`). Verification:

- `bash -n install.sh` — syntax-check the modified installer.
- Manual read-through: confirm the new agent file matches the structural pattern of the other
  5 non-orchestrator agent files (frontmatter fields, section headers, table formats).
- Cross-check consistency: the skill list and role name must match exactly across
  `agents/minions-ui-ux-designer.md`, `skills/minions/SKILL.md`, `README.md`, and `spec.md` — no
  optional dry-run of `install.sh` against a real `~/.claude` install as part of this change,
  since that would install skills the user hasn't approved running the full installer for.

## Out of scope

- Actually running `install.sh` / installing the taste-skill packages into `~/.claude` — this
  spec covers only the repo-side changes so the next `./install.sh` run picks them up.
- A new Lark Base table for designs (explicitly deferred per decision #3).
- Image-generation-only skills from taste-skill (`imagegen-*`, `brandkit`).
