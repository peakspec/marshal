#!/usr/bin/env bash
set -e

# ── colours ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

ok()   { echo -e "${GREEN}✓${RESET} $1"; }
info() { echo -e "${CYAN}→${RESET} $1"; }
warn() { echo -e "${YELLOW}!${RESET} $1"; }
fail() { echo -e "${RED}✗${RESET} $1"; exit 1; }
header() { echo -e "\n${BOLD}$1${RESET}"; }

# ── banner ─────────────────────────────────────────────────────────────────────
echo -e "${BOLD}"
echo "  minions — AI Subagent Team"
echo "  Installer"
echo -e "${RESET}"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Prerequisites ───────────────────────────────────────────────────────────
header "1/5  Checking prerequisites"

# Claude Code
if command -v claude &>/dev/null; then
  ok "Claude Code found ($(claude --version 2>/dev/null | head -1))"
else
  fail "Claude Code not found. Install it from https://claude.ai/code then re-run this script."
fi

# lark-cli
if command -v lark-cli &>/dev/null; then
  ok "lark-cli found"
else
  warn "lark-cli not found — install with: npm install -g lark-cli"
  warn "Continuing install, but Lark tools won't work until lark-cli is installed and authenticated."
fi

# Node.js / npx (needed for skill packages)
if command -v npx &>/dev/null; then
  ok "npx found (Node $(node --version 2>/dev/null))"
else
  fail "Node.js / npx not found. Install Node.js 18+ from https://nodejs.org then re-run."
fi

# ── 2. Copy agent + skill files ────────────────────────────────────────────────
header "2/5  Installing minions agents and skill"

AGENTS_DIR="$HOME/.claude/agents"
SKILLS_DIR="$HOME/.claude/skills/minions"

mkdir -p "$AGENTS_DIR" "$SKILLS_DIR"

for f in "$REPO_DIR"/agents/minions-*.md; do
  cp "$f" "$AGENTS_DIR/"
  ok "Installed agents/$(basename "$f") → $AGENTS_DIR/"
done

cp "$REPO_DIR/skills/minions/SKILL.md" "$SKILLS_DIR/SKILL.md"
ok "Installed skills/minions/SKILL.md → $SKILLS_DIR/"

# Config — only copy template if config.md doesn't already exist
if [[ ! -f "$SKILLS_DIR/config.md" ]]; then
  cp "$REPO_DIR/skills/minions/config.example.md" "$SKILLS_DIR/config.md"
  echo ""
  warn "Config template copied to: $SKILLS_DIR/config.md"
  warn "Open that file and fill in your Lark base token and table IDs before using /minions."
  echo ""
else
  ok "Config already exists at $SKILLS_DIR/config.md — skipped (not overwritten)"
fi

# ── 3. Install external skill packages ────────────────────────────────────────
header "3/5  Installing skill packages"

SKILLS=(
  "phuryn/pm-execution"
  "phuryn/pm-product-discovery"
  "phuryn/pm-product-strategy"
  "phuryn/pm-data-analytics"
  "phuryn/pm-go-to-market"
  "phuryn/pm-marketing-growth"
  "phuryn/pm-market-research"
  "phuryn/pm-toolkit"
  "coreyhaines31/marketingskills"
)

for skill in "${SKILLS[@]}"; do
  info "Installing $skill ..."
  if npx skills add "$skill" --quiet 2>/dev/null; then
    ok "$skill"
  else
    warn "$skill — install failed or not available, skipping"
  fi
done

# Anthropic skills (installed individually)
ANTHROPIC_SKILLS=("pptx" "docx" "xlsx" "webapp-testing" "internal-comms")
for skill in "${ANTHROPIC_SKILLS[@]}"; do
  info "Installing anthropics/skills --skill $skill ..."
  if npx skills add anthropics/skills --skill "$skill" --quiet 2>/dev/null; then
    ok "anthropics/skills: $skill"
  else
    warn "anthropics/skills: $skill — install failed or not available, skipping"
  fi
done

# ericosiu/ai-marketing-skills — manual git clone (no npx support)
ERICOSIU_SKILLS=(
  "deck-generator" "sales-playbook" "content-ops"
  "growth-engine" "sales-pipeline" "outbound-engine" "seo-ops"
  "finance-ops" "revenue-intelligence" "conversion-ops" "podcast-ops"
  "team-ops" "autoresearch" "yt-competitive-analysis" "x-longform-post"
)
MISSING_ERICOSIU=()
for skill in "${ERICOSIU_SKILLS[@]}"; do
  if [[ ! -f "$HOME/.claude/skills/$skill/SKILL.md" ]]; then
    MISSING_ERICOSIU+=("$skill")
  else
    ok "~/.claude/skills/$skill already present"
  fi
done

if [[ ${#MISSING_ERICOSIU[@]} -gt 0 ]]; then
  info "Cloning ericosiu/ai-marketing-skills for: ${MISSING_ERICOSIU[*]}"
  TMP_DIR=$(mktemp -d)
  if git clone --quiet https://github.com/ericosiu/ai-marketing-skills.git "$TMP_DIR" 2>/dev/null; then
    for skill in "${MISSING_ERICOSIU[@]}"; do
      if [[ -f "$TMP_DIR/$skill/SKILL.md" ]]; then
        mkdir -p "$HOME/.claude/skills/$skill"
        cp "$TMP_DIR/$skill/SKILL.md" "$HOME/.claude/skills/$skill/SKILL.md"
        ok "ericosiu/ai-marketing-skills: $skill"
      else
        warn "ericosiu/ai-marketing-skills: $skill not found in repo, skipping"
      fi
    done
    rm -rf "$TMP_DIR"
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

if command -v lark-cli &>/dev/null; then
  STATUS=$(lark-cli auth status 2>/dev/null | grep -i "tokenStatus" | awk -F'"' '{print $4}')
  if [[ "$STATUS" == "valid" ]]; then
    ok "Lark authenticated"
  else
    warn "Lark not authenticated. Run: lark-cli auth login"
  fi
else
  warn "lark-cli not installed — skipping auth check"
fi

# ── Done ───────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}Installation complete.${RESET}"
echo ""
echo -e "  Next steps:"
echo -e "  1. Fill in your Lark config:  ${CYAN}$SKILLS_DIR/config.md${RESET}"
echo -e "  2. Open Claude Code and type: ${CYAN}/minions${RESET}"
echo ""
