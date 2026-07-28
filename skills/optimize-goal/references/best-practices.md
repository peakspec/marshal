# goal.md review checklist

Condensed from Anthropic's [prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
and adapted for reviewing a `goal.md`-style task spec — a written instruction meant to be
executed by an agent with no further back-and-forth, rather than a conversational prompt.

Use this as a lens to find gaps, not a form every goal.md must fill in. A short, already-clear
goal.md may only need two or three of these checked; a large multi-repo goal may need all of
them plus examples.

---

## 1. Task clarity — the colleague test

**Check:** Read the Task statement as if you were a colleague with minimal context. Could
you execute it correctly on the first read, or does it require guessing?

**Why:** Claude (like a new employee) responds to precision, not vague intent. Ambiguity that
a human would silently resolve with common sense gets resolved arbitrarily by an agent.

**Common gap:** Verbs without objects ("improve the page", "fix the flow") — improve *what
metric*, fix *which* flow, *how*.

**Fix pattern:** Replace vague verbs with specific, checkable actions. Instead of "Create an
analytics dashboard," write "Create an analytics dashboard with [specific charts]. Include
[specific interactions]. Go beyond the basics — fully-featured, not a skeleton."

## 2. Context / why

**Check:** Does the goal.md explain *why* behind any non-obvious constraint or guardrail,
not just state the constraint?

**Why:** Explaining motivation lets the executing agent generalize correctly to cases the
spec didn't anticipate, instead of pattern-matching the letter of the rule.

**Fix pattern:** Instead of "Never touch the `legacy/` folder," write "Never touch the
`legacy/` folder — it's frozen pending a migration sign-off from the infra team, and edits
there get silently reverted by a sync job."

## 3. Success criteria (End State / Output)

**Check:** Is "done" defined in terms that are checkable — a test that passes, a file that
exists with certain content, a metric that crosses a threshold — rather than only described?

**Why:** Descriptive success criteria ("the page should look better") leave the executing
agent to invent its own definition of done, which rarely matches what the author had in mind.

**Fix pattern:** Pair every qualitative goal with a concrete check. "The page should convert
better" → "The signup form should be reachable in ≤2 clicks from the hero, and the CTA above
the fold."

## 4. Non-goals / explicit scope boundary

**Check:** Does the goal.md say what's explicitly *out* of scope, not only what's in scope?

**Why:** Absent an explicit boundary, agents tend to over-deliver — extra features,
refactors, or "improvements" nobody asked for — which inflates the task and can break things
adjacent to it.

**Fix pattern:** Add a short "Non-Output" or "Out of scope" line: "Do not touch the billing
integration. Do not redesign the nav — only the hero section."

## 5. Resources

**Check:** Are the inputs the task depends on (docs, repos, prior specs, existing files)
named and locatable, not just referenced vaguely?

**Why:** For any task with real inputs, an agent that has to guess where the source of truth
lives will either hallucinate it or stall. Anthropic's long-context guidance also notes that
naming and structuring reference material (not just mentioning it exists) measurably improves
grounding.

**Fix pattern:** List resources explicitly: repo URLs, file paths, doc links, prior goal.md
files this one builds on. If there are several, a short bulleted list beats a single
paragraph mentioning them in passing.

## 6. Guardrails

**Check:** Are irreversible or high-blast-radius actions (deleting data, force-pushing,
posting publicly, spending money, contacting real people) flagged as needing confirmation
before the executing agent takes them?

**Why:** Without this, an agent executing a goal.md autonomously has no signal for which
actions are safe to take unilaterally versus which need a human in the loop first.

**Fix pattern:** Add a Guardrails section naming the specific irreversible actions relevant
to *this* task and what to do instead of just doing them (ask first, or don't do it at all).

## 7. Execution order

**Check:** When steps have a real dependency order, are they written as an ordered
list — not a paragraph of intermixed tasks the executor has to re-sequence?

**Why:** Sequential steps as numbered/bulleted lists reduce misordering, especially when
later steps depend on earlier output.

**Fix pattern:** Convert "do A, and also remember B before C" prose into a numbered list
reflecting the actual dependency order.

## 8. Prerequisites / dependencies

**Check:** Is anything required *before* execution can start (access, credentials, a prior
step finishing, another goal.md's output) called out explicitly?

**Why:** A goal.md executed unattended can't ask "do I have access to X?" — if it's not
stated, the agent either blocks or guesses.

**Fix pattern:** Short explicit list: "Requires: repo write access, `.env` with API key
already present, goal [2] already complete."

## 9. Output format

**Check:** Is the shape of the deliverable explicit — a file at a path, a PR, a report in
chat, a specific document format — rather than left implicit?

**Why:** The same task ("summarize this") produces a wildly different artifact depending on
whether the target is a Slack message, a markdown file, or a PR description. Say which.

**Fix pattern:** State the deliverable directly: "Output: a PR against `main` with a
one-paragraph description," not just "let me know when it's done."

## 10. Ambiguity scan

**Check:** Re-read every line once more looking specifically for wording that could be taken
two different ways by two different readers.

**Why:** This is the cheapest, highest-value pass — most goal.md problems are one or two
ambiguous phrases, not structural gaps.

**Fix pattern:** For each ambiguous phrase found, either pick one interpretation and make it
explicit, or ask the user which one they meant (this is the primary source of clarifying
questions this skill should ask).

## 11. Examples (only when the task has a "taste" component)

**Check:** For tasks involving style, tone, or a subjective judgment call (copy, design,
naming), are there 1–3 examples of the desired output, or a reference to emulate?

**Why:** A few concrete examples steer output format and tone far more reliably than
adjectives like "modern" or "clean" on their own.

**Fix pattern:** Add a short `<example>`-style reference or link to a comparable existing
artifact the user likes.
