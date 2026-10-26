---
status: draft (awaiting accuracy review + Justin's approval)
guide: fact-check-protocol
created: 2026-10-26
sources:
  - marketing/README.md ("Accuracy and sense review", Justin's rule 2026-10-19)
  - marketing/guides/script-standards.md §5, compliance-checklist.md
  - docs/specs/adaptive-practice.md §2, §9.5 (adaptivity claim gates)
---

# Fact-Check Protocol

How the mandatory accuracy and sense review (`marketing/README.md`) is run. It exists because a math brand aimed at parents can't afford one confident wrong fact, and because an author can't reliably check their own work (this project's own reviews have caught the author's mistakes several times).

## 1. When it runs

| Gate | On | Who |
|---|---|---|
| **Script gate** (Stage 3) | `treatment.md`: script, on-screen text, math strings, titles, descriptions, captions, first comment | Independent reviewer, then Justin |
| **Render gate** (Stage 5) | The exported video file and the final upload copy | Independent reviewer, then Justin |
| **Website copy** | Any page change | Independent reviewer, then Justin |
| **Guides** | New or changed guidance with factual content | Independent reviewer, then Justin |

The **independent reviewer** is a fresh agent with no authoring context, told to try to prove the claims wrong. **The author never reviews their own work,** whoever the author is (Claude, a subagent, or Justin); Justin's sign-off is a separate, final step and never replaces the independent review.

## 2. Procedure

1. **Claims list.** Start from the treatment's claims list and check it's complete: every factual statement, number, date, attribution, quote, statistic, app claim and joke premise in every text the viewer sees or hears.
2. **Math.** Recompute every number, equation and answer by running code. Check that the captions and math cards show exactly the treatment's strings.
3. **Facts and history.** Check each against the sources in §3. Legends must be framed as legends.
4. **Learning science.** The claim's wording must match its confidence level (`script-standards.md` §5). No outcome claims.
5. **App claims.** Check against the code of the build testers can install today, not `main`. That build is recorded in `docs/RELEASES.md` (version, build number, commit, date, platforms); add a line there with every release. Adaptivity claims need their phase merged, released, and the claim tests in `docs/specs/adaptive-practice.md` §9.5 passing.
6. **Volatile facts.** Re-check anything that changes: platform policies, prices, records (largest known prime), guideline wording (AAP), dates of observances.
7. **Sense read.** Read the whole piece as a skeptical parent and as a math teacher. Does each line make sense? Is the reasoning right, not just the numbers? Does any simplification mislead? Is anything said to a child?
8. **Compliance.** Run the relevant sections of `compliance-checklist.md`.
9. **Record** everything in `review.md` (§4).
10. **Justin signs off.**

## 2b. Render gate checklist (on the exported file)

- [ ] VO matches the approved script word for word (listen through once with the script open)
- [ ] Captions match the aligned VO words, with numbers shown exactly as the treatment's math strings
- [ ] Math cards show exactly the treatment's strings; recompute once more
- [ ] Nothing flashes more than 3 times a second
- [ ] Loudness about -14 LUFS integrated; voice clear over music
- [ ] Text and key visuals inside the safe zones (`visual-style.md` §2)
- [ ] Nothing identifying in hands or gameplay footage
- [ ] `compliance-checklist.md` stage 2 sections passed
- [ ] Upload settings planned per `compliance-checklist.md` §J

## 3. Source hierarchy

1. **Primary:** platform help pages and policy text, government and regulator sites, peer-reviewed papers, standards documents, the app's own code.
2. **Our research,** HIGH-confidence items: the trivia bank (research report Appendix A) and the evidence table.
3. **Reputable secondary:** established science journalism, the MacTutor history archive, major newspapers.
4. **Not enough on its own:** blogs, vendor marketing, forums, AI summaries. They can point to a source; they can't be the source.

When sources conflict, say so in the review and use the more cautious wording.

## 4. `review.md` template

```markdown
# MD-###: review
## Script gate (date, reviewer)
Verdict: PASS | PASS WITH FIXES | FAIL
| # | Claim (as written) | Verdict | Evidence | Fix |
|---|---|---|---|---|
Math recomputed: <code output>
Sense read: <issues>
Compliance (§A-H): <results>
Justin sign-off: <date>

## Render gate (date, reviewer)
Verdict:
Checked on file: <path>
Issues:
Justin sign-off: <date>
```

## 5. After publishing: corrections

If a published video turns out to be wrong:
- **Minor** (a small imprecision that doesn't change the point): pin a correction comment and fix the description.
- **Material** (wrong math, a false fact the video depends on, a claim the app doesn't support):
  - **YouTube:** make the video private or unlisted.
  - **Facebook:** Reels have no unlisted option; delete the Reel (or, if it's only the caption that's wrong, edit the caption and pin a correction comment).
  - Log what slipped through. Don't re-upload a lightly edited copy (platforms treat that as unoriginal); make a new, corrected video if the topic is worth it.
- Every correction gets a line in the weekly review, and the protocol or guides change if a gap let it through.
