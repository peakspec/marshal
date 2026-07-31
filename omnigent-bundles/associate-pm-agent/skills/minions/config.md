# minions — Lark Configuration

Copy this file to `config.md` in the same directory and fill in your values:
```bash
cp skills/minions/config.example.md skills/minions/config.md
# Then install alongside the skill:
cp skills/minions/config.md ~/.claude/skills/minions/config.md
```

Agents read `~/.claude/skills/minions/config.md` on first use. If not found, they self-discover via `lark-cli` search.

---

## Lark Base

**Base Token:** `YOUR_LARK_BASE_TOKEN`

> Find this in your Lark Base URL: `base.larksuite.com/.../<BASE_TOKEN>/...`

## Table IDs

| Table | ID | Purpose |
|-------|----|---------|
| Pillars | `YOUR_PILLARS_TABLE_ID` | Strategic pillars |
| Modules | `YOUR_MODULES_TABLE_ID` | Product modules |
| Issues | `YOUR_ISSUES_TABLE_ID` | Central issue tracker |
| Subtask | `YOUR_SUBTASK_TABLE_ID` | Subtasks |
| Roadmap | `YOUR_ROADMAP_TABLE_ID` | Timeline milestones |
| Master Sprint | `YOUR_MASTER_SPRINT_TABLE_ID` | Sprint definitions |

> Find table IDs via: `lark-cli base +tables --base YOUR_LARK_BASE_TOKEN`

## Lark Group Chats

| Chat | ID | Purpose |
|------|----|---------|
| User Reports | `YOUR_USER_REPORTS_CHAT_ID` | Customer feedback alerts |

> Find chat IDs via: `lark-cli im +chat-search --query "chat name"`
> Set `USER_REPORTS_CHAT_NAME` below so the Customer Service agent can self-discover the chat ID.

**User Reports Chat Name:** `YOUR_USER_REPORTS_CHAT_NAME`

## PostHog

| Variable | Value |
|----------|-------|
| Project ID | `YOUR_POSTHOG_PROJECT_ID` |
| API Key | `YOUR_POSTHOG_API_KEY` |

> Find these in PostHog → Project Settings → Project API Key
