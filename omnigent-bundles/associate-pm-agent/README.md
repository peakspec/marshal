# Omnigent Bundle: minions-associate-pm

Omnigent port of the Claude Code subagent defined in `agents/minions-associate-pm.md`.

## What was translated

- Bundle format: `config.yaml` + `skills/<name>/SKILL.md` for Omnigent (`spec_version: 1`).
- Frontmatter `name`/`description` lifted directly from the Claude Code agent.
- Full prompt body ported into `config.yaml` under `prompt:`.
- Path substitutions:
  - `~/.claude/skills/minions/config.md` → `{{params.lark_config}}`
  - `~/.claude/skills/<skill>/SKILL.md` → `skills/<skill>/SKILL.md`
- `params.lark_config` points to `skills/minions/config.md`.
- `executor`, `os_env`, and `terminals` configured per Omnigent spec (`harness: claude-sdk`, `sandbox: { type: none }`).
- `skills/minions/config.md` vendored from `skills/minions/config.example.md`.

## Vendored vs placeholder skills

| Skill | Status | Source used |
|-------|--------|-------------|
| `create-prd` | placeholder | not found in repo or `~/.claude/skills/` |
| `brainstorm-okrs` | placeholder | not found in repo or `~/.claude/skills/` |
| `outcome-roadmap` | placeholder | not found in repo or `~/.claude/skills/` |
| `prioritize-features` | placeholder | not found in repo or `~/.claude/skills/` |
| `analyze-feature-requests` | placeholder | not found in repo or `~/.claude/skills/` |
| `product-strategy` | placeholder | not found in repo or `~/.claude/skills/` |
| `lean-canvas` | placeholder | not found in repo or `~/.claude/skills/` |
| `business-model` | placeholder | not found in repo or `~/.claude/skills/` |
| `pre-mortem` | placeholder | not found in repo or `~/.claude/skills/` |
| `pptx` | placeholder | not found in repo or `~/.claude/skills/` |
| `user-stories` | placeholder | not found in repo or `~/.claude/skills/` |
| `wwas` | placeholder | not found in repo or `~/.claude/skills/` |
| `release-notes` | placeholder | not found in repo or `~/.claude/skills/` |

All 13 external skills are stubbed. Before production use, replace each placeholder `skills/<name>/SKILL.md` with real content from its upstream repository (e.g. `phuryn/pm-execution`, `pm-product-discovery`, `pm-product-strategy`, or `anthropics/skills`).

## External dependencies still needed

- `lark-cli` must be installed and available in the caller process PATH.
- Lark base token and table IDs must be filled into `skills/minions/config.md`.

## Launch

```python
sys_session_create(config_path='omnigent-bundles/associate-pm-agent')
```

## Co-author

Co-authored-by: omnigent <noreply@omnigent.ai>
