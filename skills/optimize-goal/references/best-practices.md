# goal.md review checklist

Condensed from two sources:

- Anthropic's [prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) — general prompt clarity, examples, structure.
- Claude Code's [`/goal` reference](https://code.claude.com/docs/en/goal) — the actual mechanics of how a goal.md's content gets executed once it's handed to `/goal`.

Use this as a lens to find gaps, not a form every goal.md must fill in. A short, already-clear
goal.md may only need two or three of these checked; a large multi-repo goal may need all of
them plus examples.

---

## How `/goal` actually works (read this first)

`/goal <condition>` does two things with the same text, not one:

1. **First turn:** the condition itself is used as the directive — Claude acts on it directly, no separate prompt needed.
2. **Every turn after:** a separate small/fast model (Haiku by default) re-reads the condition against the conversation transcript and answers yes/no. No → Claude keeps working, using the model's stated reason as guidance. Yes → the goal clears.

This means a goal.md destined for `/goal` is judged twice, and by two different things:

- **By Claude**, as an instruction to act on.
- **By a transcript-only judge model that cannot run commands or read files itself.** It only sees what Claude has already surfaced in the conversation. A condition like "all tests pass" only resolves if Claude actually runs the tests and the output lands in the transcript — the judge cannot verify anything Claude didn't first demonstrate.

Two hard constraints follow directly from this:

- **4,000-character cap** on the condition text.
- **No bound by default.** Nothing stops the loop except the condition becoming true, so an unbounded or unverifiable condition can run indefinitely.

Everything below is shaped by these mechanics, not just general prompt clarity.

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

## 3. Success criteria — measurable AND transcript-verifiable

**Check:** Is "done" defined as something Claude's own output can demonstrate inside the
conversation — not merely something objectively true? Every success criterion needs three
parts:

- **One measurable end state** — a test result, a build exit code, a file count, an empty queue.
- **A stated check** — how Claude proves it, e.g. "`npm test` exits 0" or "`git status` is clean." If the check isn't named, Claude may consider the goal met without ever producing evidence the judge model can read.
- **Constraints that must not change** — anything that has to stay untouched on the way there, e.g. "no other test file is modified."

**Why:** The model evaluating completion after each turn never runs commands or reads files
itself — it only judges the transcript. A criterion that's true in reality but never
demonstrated in-conversation (e.g. "the tests pass" when Claude never actually ran them this
session) can neither be confirmed nor denied correctly.

**Fix pattern:** "The page should convert better" (unverifiable) → "The signup form is
reachable in ≤2 clicks from the hero and the CTA sits above the fold — confirm by describing
the click path and pasting the relevant markup" (measurable + has a stated check).

## 4. Bound the loop

**Check:** Does the condition include an explicit turn or time limit clause (e.g. "...or stop
after 20 turns"), or is the end state guaranteed to resolve on its own?

**Why:** `/goal` has no default ceiling — it keeps re-evaluating every turn until the
condition holds. An end state that's ambiguous, perpetually "almost met," or dependent on
something outside Claude's control (e.g. a human review) can loop unbounded.

**Fix pattern:** Add a stop clause to any open-ended or exploratory goal: "...or stop after 15
turns and report what's blocking completion."

## 5. Non-goals / explicit scope boundary

**Check:** Does the goal.md say what's explicitly *out* of scope, not only what's in scope?

**Why:** Absent an explicit boundary, agents tend to over-deliver — extra features,
refactors, or "improvements" nobody asked for — which inflates the task and can break things
adjacent to it. This doubles as one of the "constraints that must not change" the evaluator
should be checking every turn (see #3).

**Fix pattern:** Add a short "Non-Output" or "Out of scope" line: "Do not touch the billing
integration. Do not redesign the nav — only the hero section."

## 6. Resources

**Check:** Are the inputs the task depends on (docs, repos, prior specs, existing files)
named and locatable, not just referenced vaguely?

**Why:** For any task with real inputs, an agent that has to guess where the source of truth
lives will either hallucinate it or stall. Anthropic's long-context guidance also notes that
naming and structuring reference material (not just mentioning it exists) measurably improves
grounding.

**Fix pattern:** List resources explicitly: repo URLs, file paths, doc links, prior goal.md
files this one builds on. If there are several, a short bulleted list beats a single
paragraph mentioning them in passing.

## 7. Guardrails

**Check:** Are irreversible or high-blast-radius actions (deleting data, force-pushing,
posting publicly, spending money, contacting real people) flagged as needing confirmation
before the executing agent takes them?

**Why:** Without this, an agent executing a goal.md autonomously — potentially unattended,
across many `/goal` turns — has no signal for which actions are safe to take unilaterally
versus which need a human in the loop first.

**Fix pattern:** Add a Guardrails section naming the specific irreversible actions relevant
to *this* task and what to do instead of just doing them (ask first, or don't do it at all).

## 8. Execution order

**Check:** When steps have a real dependency order, are they written as an ordered
list — not a paragraph of intermixed tasks the executor has to re-sequence?

**Why:** Sequential steps as numbered/bulleted lists reduce misordering, especially when
later steps depend on earlier output.

**Fix pattern:** Convert "do A, and also remember B before C" prose into a numbered list
reflecting the actual dependency order.

## 9. Prerequisites / dependencies

**Check:** Is anything required *before* execution can start (access, credentials, a prior
step finishing, another goal.md's output) called out explicitly?

**Why:** A goal.md executed unattended can't ask "do I have access to X?" — if it's not
stated, the agent either blocks or guesses.

**Fix pattern:** Short explicit list: "Requires: repo write access, `.env` with API key
already present, goal [2] already complete."

## 10. Output format

**Check:** Is the shape of the deliverable explicit — a file at a path, a PR, a report in
chat, a specific document format — rather than left implicit?

**Why:** The same task ("summarize this") produces a wildly different artifact depending on
whether the target is a Slack message, a markdown file, or a PR description. Say which.

**Fix pattern:** State the deliverable directly: "Output: a PR against `main` with a
one-paragraph description," not just "let me know when it's done."

## 11. Fits the `/goal` argument, not just reads well as a doc

**Check:** If this goal.md is meant to be fed to `/goal` directly, does the condition portion
compress to something under the 4,000-character cap, written as a condition (see #3) rather
than a general task description?

**Why:** A goal.md can carry more supporting detail than `/goal` accepts in one shot — context,
resources, and rationale are useful for a human reader and for Claude's first turn, but the
per-turn evaluator only needs the condition, the check, and the constraints. If the file is
long, the review should call out which portion *is* the condition to paste into `/goal`.

**Fix pattern:** For long goal.md files, end with a short, explicit block (e.g. under a
`## Condition` heading) that's the actual `/goal`-ready text — self-contained, under 4,000
characters, phrased as a checkable condition — separate from the surrounding context/resources
prose.

## 12. Ambiguity scan

**Check:** Re-read every line once more looking specifically for wording that could be taken
two different ways by two different readers.

**Why:** This is the cheapest, highest-value pass — most goal.md problems are one or two
ambiguous phrases, not structural gaps.

**Fix pattern:** For each ambiguous phrase found, either pick one interpretation and make it
explicit, or ask the user which one they meant (this is the primary source of clarifying
questions this skill should ask).

## 13. Examples (only when the task has a "taste" component)

**Check:** For tasks involving style, tone, or a subjective judgment call (copy, design,
naming), are there 1–3 examples of the desired output, or a reference to emulate?

**Why:** A few concrete examples steer output format and tone far more reliably than
adjectives like "modern" or "clean" on their own.

**Fix pattern:** Add a short `<example>`-style reference or link to a comparable existing
artifact the user likes.
