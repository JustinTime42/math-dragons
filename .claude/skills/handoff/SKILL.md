---
name: handoff
description: Write a structured session handoff so the next Claude conversation can resume without loss, or (with "resume") load the latest handoff and brief from it. Use ONLY when the user explicitly asks (/handoff, "hand off", "write the handoff"); it is the last action before Justin closes the session. Never write one unprompted. Use "/handoff resume" to re-load handoff context mid-session.
---

> **Timing (Justin's rule):** write the handoff only when instructed. It is the final step of a session, so do all other work (commits included, if requested) before it, and do nothing after it except report the path.
>
> **Auto-pickup:** `.claude/settings.json` runs `.claude/hooks/session-start-handoff.sh` on session start/clear, which prints `handoffs/LATEST.md` and every handoff it names into the new session's context. So LATEST.md must always name the current handoff, or the next session starts blind.

# Handoff

Adapted from the fort seat protocol (`~/dev/fortkit/templates/fort/seats/mayor.md`, "Handoff schema"), minus beads and events. A handoff is a **write-up for a stranger**: the next session has none of this conversation, only the repo. Write so it can act in its first five minutes without re-deriving anything.

## Where handoffs live

- `handoffs/` at the repo root, one file per session: `handoffs/<YYYY-MM-DD>-<workstream>-<slug>.md` (e.g. `2026-10-19-video-research-and-scaffold.md`). If two land the same day for the same workstream, add `-b`, `-c`.
- Workstreams so far: `video` (marketing video pipeline, home `marketing/`), `app` (Flutter app work). Add new ones as needed.
- `handoffs/LATEST.md` is a short pointer file: one line per workstream naming its most recent handoff. Update it every time.

## Mode 1: write (`/handoff`, default)

1. **Gather facts, don't recall them.** Run `git status --short` and `git log --oneline -15`; list files created or changed this session; re-read the workstream's tracker (`marketing/PLAN.md` for video) so checkbox state is current.
2. **Update the trackers first**, in the same session: tick finished items in the workstream PLAN, add newly discovered items, update stage status. A handoff that disagrees with PLAN.md is a bug.
3. **Write the handoff** using the schema below. Every claim in "Verified facts" carries evidence: a file path (with line when useful), commit hash, command output, or URL. Anything not verified goes under "Open risks / questions".
4. **Update `handoffs/LATEST.md`.**
5. **Durable lessons go to memory**, not just the handoff: if the session learned something that will matter beyond the next session (a user preference, a tool trap, a decision), write or update a file in the project auto-memory and its `MEMORY.md` index.
6. **Do not commit** unless the user asks. Report the handoff path and the suggested opening line for the next session (see below).

### Schema

```markdown
---
workstream: <video|app|...>
date: <YYYY-MM-DD>
model: <model that did the work>
stage: <pipeline stage, e.g. "Stage 1: guidance docs">
previous: <path of the prior handoff in this workstream, or none>
---

# Handoff: <workstream> <ISO timestamp>

## Read first
<ordered list of the 3-6 files the next session must read before acting, most important first>

## State of work
<what was done this session, one line per item, with outcome. Include what is half-done and exactly where it stopped>

## Decisions made
<decisions taken this session and WHY, including any made by Justin. Mark which are Justin's calls vs. defaults Claude chose that Justin may overturn>

## Verified facts
<claims with evidence: path:line, commit, command output, URL>

## Next actions
<ordered, concrete, each startable without further context. First item is what the next session does first>

## Open risks / questions
<including anything needing Justin's decision, flagged "JUSTIN:">

## Failed attempts
<what was tried and didn't work, so successors don't repeat it>
```

Then end your reply with the suggested opener, e.g.:
> Next session: `/handoff resume video`

## Mode 2: resume (`/handoff resume [workstream]`)

1. Read `handoffs/LATEST.md`, then the latest handoff for the workstream (ask if ambiguous and more than one workstream is live).
2. Read every file in its "Read first" list.
3. Check for drift: `git log` since the handoff's date, and whether PLAN.md still matches the handoff. Call out any mismatch.
4. Brief the user in a few lines: where things stand, open questions needing them, and the first next action. Then proceed with that action unless it needs their decision.

## Rules

- Never paste large file contents into a handoff; point to paths.
- No em-dashes in prose written for Justin (see global CLAUDE.md prose style).
- Handoffs are append-only history. Fix a wrong handoff by noting the correction in the next one, not by rewriting the old file.
