---
name: optimize-goal
description: Use when the user wants to review, critique, tighten, or enhance an existing goal.md file (a written spec/prompt authored for a /goal command instead of typed into chat) before it gets executed — including requests like "review this goal.md", "enhance my goal.md", "optimize this goal", or sharing a goal.md file and asking for feedback before running it.
---

# Optimize Goal

## Overview

A `goal.md` is a long-form instruction the user writes to a file instead of typing into
chat, meant to be executed as a `/goal` command. Whatever is ambiguous, unmeasurable, or
missing in that file passes straight through into whatever executes it — there's no chat
back-and-forth to catch it later. This skill reviews an existing `goal.md` against
prompt-engineering best practice, clarifies the gaps with the user, and only then rewrites
the file.

**Not for:** helping someone compose a goal.md from scratch when no draft exists yet —
that's `superpowers:brainstorming` territory. This skill starts from a file that already
exists.

## Workflow

1. **Read the goal.md** the user points to.
2. **Silently audit it** against the checklist in `references/best-practices.md`. Judge
   relevance to *this* goal.md — don't force a fixed template onto it. A one-paragraph
   goal doesn't need a Prerequisites section; a multi-repo goal probably does.
3. **Ask clarifying questions one at a time**, ordered by impact (biggest ambiguity or
   highest blast-radius gap first — e.g. missing success criteria before missing
   formatting preferences). Prefer multiple-choice phrasing when the gap has a natural
   small set of answers.
4. **Draft the enhanced version** once questions are answered. Preserve the user's own
   structure, section names, and voice — tighten and fill gaps, don't impose a rewrite
   they didn't ask for.
5. **Show the draft (or a diff against the original) and get explicit approval.**
6. **Only after approval, overwrite goal.md in place.** Never write the file before the
   user has signed off on the content.

## Checklist quick reference

Full detail with examples in `references/best-practices.md`. Categories to scan for on
every goal.md, applied contextually:

| Category | What's being checked |
|---|---|
| Task clarity | Would a colleague with no context execute this correctly on the first read? |
| Context / why | Is the motivation behind non-obvious constraints stated? |
| Success criteria | Is "done" defined in a way that's checkable, not just descriptive? |
| Non-goals / scope | Is what's explicitly *out* of scope stated, to prevent scope creep? |
| Resources | Are the inputs, docs, or repos the task depends on named and locatable? |
| Guardrails | Are irreversible/high-blast-radius actions flagged for confirmation? |
| Execution order | Are steps that must happen in sequence actually ordered? |
| Prerequisites | Is setup/access needed before starting called out? |
| Output format | Is the shape of the deliverable (file, PR, report, message) explicit? |
| Ambiguity scan | Any line readable two different ways? |

## Common mistakes

- **Asking everything at once.** Dumping five clarifying questions in one message gets
  shallow answers. One at a time, highest-impact gap first.
- **Rewriting before approval.** Draft, show, wait for sign-off, then write the file.
- **Enforcing a rigid template.** The checklist is a lens, not a form to fill in — a
  short goal.md that's already clear doesn't need every category addressed explicitly.
- **Treating "no file yet" as in scope.** If the user has only an idea and no draft,
  point them to `superpowers:brainstorming` instead of improvising a first draft here.
