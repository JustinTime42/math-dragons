# Justin: next steps (written 2026-11-03)

Ordered by what unblocks the most. Each block says what Claude does once you're done. Detailed site/store steps live in `marketing/website/LAUNCH-CHECKLIST.md`; this is the short path through everything.

Status checked 2026-11-03: site live (phase 1); `http://` not yet redirecting to `https://`; 1.0.4 (9) built and pushed but not recorded as released; no Buttondown key set; Kdenlive and scrcpy not installed.

## 1. Release app 1.0.4 (9) to testers (~30 min, mostly waiting)
Fixes the Dragon Eggs 7 ÷ 2 bug before we film gameplay, and unlocks the first adaptivity claims.
- [ ] Play Console: Closed testing, new release, upload `~/dev/math-dragons/build/app/outputs/bundle/release/app-release.aab` (1.0.4, versionCode 9), roll out
- [ ] Codemagic: start **iOS Release (App Store)**; in App Store Connect add build 1.0.4 (9) to the external group (Beta App Review if asked)
- [ ] Tell Claude when both are live → Claude logs it in `docs/RELEASES.md` (claims C1 and C2-FT become publishable)

## 2. Store settings to confirm (~15 min)
- [ ] App Store Connect: Privacy Policy URL `https://playmathdragons.com/privacy`, Support URL `https://playmathdragons.com/support`, contact email `support@playmathdragons.com`; TestFlight Test Information: feedback email and privacy URL
- [ ] Play Console: privacy policy URL; closed-test feedback URL `https://playmathdragons.com/feedback`; contact email
- [ ] **Privacy labels** (MD-008 can't publish until these match): Play Data safety = "No data collected", Ads = "No"; App Store Connect App Privacy = "Data Not Collected"
- [ ] Optional: does the Play 12-tester / 14-day rule apply to this Organization account? (Play Console dashboard)

## 3. Website phase 2: launch list + analytics (~45 min)
- [ ] Cloudflare: SSL/TLS, Edge Certificates, turn on **Always Use HTTPS** (still off)
- [ ] Cloudflare: confirm Workers Logs off, no challenge pages / Always Online
- [ ] Buttondown: create account; sending domain `playmathdragons.com` (add its DNS records in Cloudflare); double opt-in on; **all open/click tracking off**; 30-day cleanup of unconfirmed addresses on; ask support about hard deletion; **hosted signup page off**; postal address in the email footer (P.O. box or business address)
- [ ] `! cd ~/dev/math-dragons-web2/website && npx wrangler secret put BUTTONDOWN_API_KEY`
- [ ] Tell Claude → Claude merges `website/phase-2`, deploys **with Umami off**, tests the signup round trip with you, checks no cookies live
- [ ] Umami Cloud: create the site (free Hobby plan), send Claude the website ID → Claude redeploys with analytics on

## 4. Channels (~30 min)
- [ ] YouTube: create the channel, handle `@playmathdragons`; channel description written to parents; link `playmathdragons.com`
- [ ] YouTube: turn on **advanced features** (phone verification; needed for the per-Short related-video link)
- [ ] Facebook: create the **Math Dragons** Page (username `playmathdragons` if free); website field `playmathdragons.com`
- [ ] Banner and profile art: Claude can draft from the style bible on request

## 5. Voices (~1-2 hours, can be split)
- [ ] ElevenLabs (Creator plan): record samples for your **Professional Voice Clone**, following ElevenLabs' current recording guidance (quiet room, same mic, natural reading; it asks for a substantial amount of clean audio). Claude can write you reading scripts in the brand voice on request
- [ ] Tallyclaw: Claude generates 3-5 **Voice Design** candidates from the brand-guide prompt if you add an ElevenLabs API key (`export ELEVENLABS_API_KEY=...` in your shell, never in the repo), or you generate them in the ElevenLabs app; you pick one
- [ ] Claude records both voice IDs and settings in `marketing/production/voices.md`

## 6. Tools (~10 min)
- [ ] `sudo dnf install kdenlive scrcpy` (Fedora) ; Claude installs Manim in a project virtualenv

## 7. Approvals still open (~30 min reading)
- [ ] The 14 scripts (`marketing/videos/MD-0NN/treatment.md` + `review.md`): sign the script gate, all at once or flag changes
- [ ] The last four guides: `visual-style.md`, `production-pipeline.md`, `metrics-and-learning.md`, `fact-check-protocol.md`
- [ ] Adaptive Phase 2 go-ahead, with Q5 (count only arithmetic facts toward mastery) and Q4 (clean old corrupt history): optional now

## What Claude does in parallel (no need to wait)
- Tallyclaw still art (stone variant: neutral, smug, unimpressed, pointing claw) from the style bible, for your approval
- Manim math cards for the voice-only videos (MD-004, MD-006, MD-007, MD-009, MD-012)
- The caption script (`marketing/production/captions.py`) and the production folder setup
- Production plans (Stage 4) for the first week's videos

## Then: first videos
Order of production once voice + tools exist: MD-001/MD-002 (join the beta; needs gameplay capture on 1.0.4 and the deployed site), then week 1 (MD-003 Einstein needs Tallyclaw art; MD-004 zero puzzle; MD-005 fingers). Nothing posts until the walkthrough (MD-001) is up, YouTube advanced features are on, and Umami is live.
