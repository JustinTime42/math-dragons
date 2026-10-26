---
status: draft (awaiting accuracy review + Justin's approval)
guide: metrics-and-learning
created: 2026-10-26
sources:
  - marketing/reports/Faceless short form video playbook.md (metrics, funnel)
  - marketing/reports/Beta landing page for kids app.md (analytics, attribution)
  - marketing/guides/content-strategy.md
---

# Metrics and Learning

What we measure, where it's logged, and how lessons flow back into the guides. Everything is judged against **our own channel's median**, not against outside benchmarks (the published ones are third-party and mostly not comparable).

## 1. The numbers that matter

**Goal 1, testers (the one that matters most right now):**
- **Android testers opted in** (Play Console), weekly. Target 25+, never below 12, and track the 14-day clock.
- **iPhone/iPad testers** (App Store Connect TestFlight: invites accepted, installs, sessions).
- **Feedback received** (emails, TestFlight feedback), logged for the Play production application.

**Goal 2, audience:**
- Subscribers (YouTube) and followers (Facebook), weekly.

**Per video, YouTube Shorts (Studio):**
- **Viewed vs swiped away** ("how many chose to view"): the hook metric.
- **Engaged views** (not raw views: since March 31, 2025, a Shorts view counts every start or replay).
- **Average percentage viewed** against the video's length.
- **Shares**, and subscribers gained per 1,000 engaged views.

**Per video, Facebook Reels (Professional Dashboard):**
- Average watch time against the video's length.
- Shares per reach.
- Reach from non-followers.
- Follows gained.

**Funnel:**
- Visits to `playmathdragons.com`, by path (`/fb###` per Facebook video; `/yt` for YouTube as a whole).
- Clicks on the iPhone and Android join buttons.
- **Gap today:** the site has no analytics yet. Umami (approved 2026-10-19) has to be added before the first post, with a privacy-policy update and the usual review. Until then, Play and TestFlight counts are the only funnel signal.

## 2. Where it's logged

| File | What | When |
|---|---|---|
| `marketing/metrics/videos.csv` | One row per video per platform: snapshot at 48 hours and at 7 days | After each snapshot |
| `marketing/metrics/testers.csv` | Date, Android opted-in, iOS testers, installs, notes | Weekly |
| `marketing/metrics/feedback-log.md` | Date, platform, what the tester said (summarized, no personal data), what we changed | As it arrives |
| `marketing/metrics/weekly/YYYY-WW.md` | The weekly review (§3) | Weekly |

No personal data in any of these: no names, emails or child details.

## 3. Weekly review (about 30 minutes)

1. Update `testers.csv`. Are Android testers climbing toward 25? Is anyone's 14-day count at risk?
2. Fill in snapshots for videos that hit 48 hours or 7 days.
3. Answer three questions:
   - Which videos made people **stop** (viewed-vs-swiped, watch time)? What did their first second have in common?
   - Which got **shared**?
   - Which sent people to **the site and the beta**?
4. Write one or two hypotheses and what we'll try next week.
5. If a lesson holds up across several videos, change the relevant guide and add a dated line to its changelog. That's how learning flows back into the rubric, the formats and the scripts.

## 4. Decision rules

- **Hooks and lengths:** adjust after every few videos.
- **A pillar:** judge after about 8-10 posts.
- **A series or format:** judge only after 10+ posts.
- **Pillar 4 (promo):** judged on beta traffic and opt-ins, not views.
- **The channel:** judge at 90 days (`content-strategy.md` §7).
- **Rubric weights** (`idea-scoring-rubric.md`): recalibrate after the first 10-15 posts by comparing scores with results.
- One standout video is a hypothesis, not a strategy. Look for patterns across several.

## 5. Open decisions (Justin)

1. Spreadsheet or CSV in the repo for the logs? (CSV in the repo is the default: versioned, and agents can read it.)
2. Add Umami to the site before the first post? (Recommended; it's the only way to see which videos send visitors.)
