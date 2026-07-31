# minions-qa — Omnigent Agent Bundle (PoC)

This is an Omnigent port (`spec_version: 1`) of the Claude Code `minions-qa` subagent
defined in `agents/minions-qa.md` at the repo root. The agent's prompt body was carried
over verbatim into `config.yaml` `instructions`, with two translations: the Lark config
path `~/.claude/skills/minions/config.md` was replaced by `params.lark_config` (which
points at the vendored `skills/minions/config.md`), and the `test-scenarios` SKILL path
in the SKILLS table was rewritten to the relative bundle path `skills/test-scenarios/SKILL.md`.
The `executor` uses the `omnigent`/`claude-sdk` harness (model omitted, harness-defaulted),
with a caller-process `os_env` and a bash `terminals.shell`. The Lark config template
(`config.example.md` → `skills/minions/config.md`) is vendored so the bundle is self-contained.

What remains external: (1) the `lark-cli` tool — referenced throughout the prompt but not
bundled; the runtime must provide it on PATH. (2) Both of the QA agent's skills are
**placeholders**, not vendored — `test-scenarios` was not found in the repo or in
`~/.claude/skills/` (distributed externally as an `npx skills` package), and `webapp-testing`
was never installed at all (the source agent marks it "Skill not yet installed"). Each
placeholder documents its expected purpose and how to vendor the real skill.

## Launch

```python
sys_session_create(config_path="omnigent-bundles/qa-agent")
```
