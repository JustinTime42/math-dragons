---
status: draft (awaiting Justin's W1 approval)
owner: Justin
created: 2026-10-19
supersedes: the landing-page section of /spec.md, once approved
sources:
  - marketing/reports/Beta landing page for kids app.md (research, 2026-10-19)
  - marketing/reports/Faceless short form video playbook.md (funnel/CTA consistency)
  - /spec.md (Justin's original landing-page outline)
---

# playmathdragons.com: Site Spec

## 1. Purpose and success criteria

The site exists to turn a parent who just watched a Short or Reel into an installed, engaged beta tester. Secondary jobs: satisfy store requirements (privacy policy, support URL), build trust in an unknown solo developer, and later host SEO articles that pair with the videos.

The site's real product is the hand-off to TestFlight or Google Play, not the page. Success is measured per step, not end to end:

| Step | Metric | Source |
|---|---|---|
| Arrive | visits per campaign path | analytics pageviews |
| Choose | `join_click {platform, src}` rate | analytics event + `/go/*` server counter |
| Android step 2 | `step2_click` rate | analytics event |
| Stuck | `troubleshoot_open`, `inapp_banner_shown`, `escape_click` | analytics events |
| Install | TestFlight installs/sessions, Play opt-ins | App Store Connect, Play Console |
| Source check | "Where did you hear about us?" | welcome survey |

No numeric targets until the first 10-15 videos produce a baseline (no public benchmark exists for beta signups from short-form video).

## 2. Audience and posture

- **Parents first**, then teachers and homeschoolers. Every word addresses an adult. Ages stated as **5-12**.
- **Parent-directed by design**, which keeps COPPA attached to the app rather than the site: no kids' corner, playable demo, coloring page, quiz, or "say hi to the dragon" prompt; testimonials from parents only; forms labeled "for parents and other adults"; articles written for parents and educators. This is the same rule that keeps the videos out of Made for Kids.
- **Tallyclaw** appears as illustration and as a dry, gruff voice speaking to adults (e.g. in the troubleshooter). Never as a guide or playmate inviting a child to interact.
- **No children shown** in any imagery, including the origin story (hands, desk, sketches, screens are fine).

## 3. Sitemap

| Path | Purpose | Notes |
|---|---|---|
| `/` | Landing: hero, install stepper, value exchange, how it works, origin teaser, FAQ preview | Primary page |
| `/story` | Origin story (dad built it for his own kid after every app failed the same way) | From `/spec.md` |
| `/faq` | Full FAQ | |
| `/privacy` | Privacy policy, app and website sections | Non-PDF, non-geofenced; store-linked |
| `/support` | Apple Support URL: contact form + plain email address | Required by Apple 1.5 |
| `/feedback` | Feedback form for testers | Set as the Play Console feedback channel (Google shows it on the opt-in page) and linked from the app |
| `/accessibility` | Accessibility statement + contact | |
| `/beta-status` | Build status; linked from a site banner when a build lapses | |
| `/yt###`, `/fb###` | Campaign landing variants, one per video (`/yt012`, `/fb012`) | Prerendered from campaign data, `noindex`, canonical to `/` |
| `/qr` | Target of the desktop QR code; lands the phone on the detected stepper | Campaign entry with `src=qr` |
| `/go/ios`, `/go/android` | Server-side click counter + 302 to TestFlight / Google Group | Worker route; single place to repoint links |
| `/api/contact` | Form handler for `/support` and `/feedback` | Worker route |
| `/articles/*` | Later: SEO articles (math history, techniques) | Phase 2, not in launch scope |

Legacy: `apps.routeworks.app/math-dragons` 301s to `playmathdragons.com/` and its privacy page 301s to `/privacy`, kept until every build that links to the old URL has expired.

## 4. Page requirements

### 4.1 Landing (`/`) and campaign variants

**Hero (above the fold on a 360x740 phone):**
- Parent-problem headline (worry-led, not product-led), at a 5th-7th grade reading level. Copy itself is a W2 deliverable.
- One primary CTA that scrolls to the install stepper with the detected platform first.
- Microcopy directly under the CTA: "Free beta. No ads. No accounts. The app collects no data." (The last clause is verified true for the app as of 2026-10-19 and must stay scoped to the app; the website does collect data.)
- Hero media: muted looping gameplay clip with a static poster image (poster is the LCP element). On campaign paths, the poster and first frame match the source video.
- "Ages 5-12" and "Built by a dad for his own kids" at or just below the fold.

**Campaign variants** reuse the landing layout. Each campaign entry overrides headline, subhead, poster/clip, and optionally a one-line callback to the video ("You just saw Tallyclaw's 9s trick. Here's the game it came from."). Message match is the cheapest conversion lever a static site has.

**Value exchange** beside the stepper, plain words: "You get: the full game, free, early, and [founding perk]. We ask: your kid plays a few times over two weeks, and you answer one short survey." Final wording in W2.

**How it works:** four games, what each practices, adaptive difficulty. Real screenshots (`assets/images/screenshots`). Feature-descriptive claims only.

**Origin teaser** linking to `/story`. **FAQ preview** (top 4) linking to `/faq`.

### 4.2 Install stepper (the most important component)

- Platform detection only decides **which path is shown first and highlighted**. Both paths always exist on the page. No JS or unknown device: both render equally.
- Each step is a self-contained button that still works when the parent comes back (every step leaves the site; no state is required between visits).
- **iPhone path:** (1) Get TestFlight, Apple's free beta-testing app; (2) come back and tap "Join the Math Dragons beta" (`/go/ios`); (3) tap Install in TestFlight.
- **Android path:** (1) Join the tester group (`/go/android`) with the warning **"Use the same Google account your Play Store uses"** (the most common failure); (2) tap "Become a tester" on the opt-in page (`step2_click` link to the opt-in URL); (3) install from Google Play.
- A small screenshot of each step's destination screen, so the parent knows what success looks like.
- Collapsed troubleshooter "Did it say 'App not available'?": account mismatch, wait a few minutes, open in Chrome. Tallyclaw voices it dryly to the parent.
- Google Group set to auto-approve (Justin, Play Console/Groups config).

### 4.3 In-app browser handling

- Detect Facebook/Instagram webviews by user agent (`FBAN|FBAV|FB_IAB|FB4A|FBIOS|Instagram`). YouTube opens the default browser and needs no special handling beyond testing.
- In a detected webview: top banner "You're inside Facebook's browser. Tap the menu, then Open in Chrome/Safari, so the install works."
  - Android: `intent://` escape button; the Android stepper sits behind the banner.
  - iOS: tap-initiated `x-safari-https://` attempt via `window.open`, with the manual instruction as fallback.
- iPad: treat `Macintosh` UA with `navigator.maxTouchPoints > 1` as iOS (pending Justin's answer on iPad support).

### 4.4 Desktop

Replace the stepper with one QR code (to `/qr`), the typed URL `playmathdragons.com`, and an optional "email me the link" field (waitlist-backed, see 4.8). QR generated at build time as inline SVG.

### 4.5 `/story`, `/faq`

- `/story`: Justin's origin story (from `/spec.md`): his daughter struggling, every app broken the same way, so he built one. Two or three paragraphs, "Built by a dad in Alaska."
- `/faq` (corrected from `/spec.md`): devices (iPhone via TestFlight and Android via Play testing, both live now); ages 5-12; is it free (free during beta; the founding perk); what math it covers (addition, subtraction, multiplication, division, number properties; verify current scope against the app before W2); child data (the app collects none: no accounts, no ads, progress stays on the device); what beta testing involves; how to leave the beta.

### 4.6 `/privacy`

Single page, sections: who we are and how to reach us (named privacy contact); the Math Dragons app (collects no data, no ads, no accounts, no third-party SDKs, children's privacy statement); the website (contact/feedback form, waitlist, analytics vendor, hosting logs, retention periods); Do Not Track / Global Privacy Control response; third parties receiving site data; deletion requests; effective date and change process. Migration steps: update URL in App Store Connect and Play Console, 301 from the old URL, in-app link in the next build (see App dependencies), keep the old redirect alive until old builds expire.

### 4.7 Forms (`/support`, `/feedback`)

Email and message required, name optional. Notice: "This form is for parents and other adults. If you're under 13, please ask a parent to write to us." Stated purpose ("so we can reply") and retention period. A separate, unticked waitlist opt-in; never auto-add. Spam: honeypot field + time-to-submit check + Workers Rate Limiting; Cloudflare Turnstile only on these pages and only if spam appears. Written procedure for deleting a message from a child (FTC one-time-response exception).

### 4.8 Waitlist (secondary)

Visually secondary to the install CTA. Uses: desktop "email me the link", parents stuck mid-flow, launch news, and the cross-platform founding-family record (a deferred option for honoring the perk). Email only, double opt-in, postal address (P.O. box) in every message, one-click unsubscribe, exportable provider.

### 4.9 Founding perk wording

Justin's decision (2026-10-19): everyone who joins the beta and installs gets lifetime free access, honored for now by an on-device founding-tester flag (app task). Research caution: "lifetime free" is a promise with no store mechanics behind it today, and Apple 2.3.1(a) treats undeliverable off-store promises as misleading. So the site wording must be **literal and deliverable**, e.g. "If Math Dragons ever adds paid features, every beta family gets them free." It is a thank-you to everyone, never tied to ratings, reviews, survey answers, or purchases, and it is described as a gift, not payment for testing. Exact wording passes the W2 accuracy review and Justin's sign-off.

### 4.10 Badges, trademarks, imagery

Text buttons during the beta ("Join the iPhone beta (TestFlight)", "Join the Android beta"). No App Store, TestFlight, or Google Play badges until public listing. TestFlight trademark symbol on first US mention; Apple and Google credit lines in the footer. Apple bezels only; no iPhone and Android device side by side in one image.

### 4.11 Footer

Privacy, Support, Feedback, Accessibility, analytics opt-out link, contact email, YouTube `@playmathdragons` and Facebook links, trademark credit lines, "Built by a dad in Alaska."

## 5. Claims rules (apply to all copy)

- Safe: feature descriptions ("practice", "adapts", "four games").
- Needs documentation: curriculum or standards alignment, only if mapped.
- Off-limits without a study of the app itself: "improves", "proven", "learn faster", outcome-stating testimonials.
- Never: "COPPA compliant" as a badge or headline, any safe-harbor seal, "safe" without specifics, "we collect no data" (the site does). Use "The Math Dragons app collects no data" / "built to collect no personal information from children".
- Never "no cookies" until verified in DevTools on the deployed site.
- Zero em-dashes in copy.

## 6. Architecture

- **Stack (locked 2026-10-19):** Astro 6, static output with build-time content collections (MDX), deployed as a Cloudflare Worker with static assets, DNS on Cloudflare. The `@astrojs/cloudflare` adapter provides the two server routes.
- **Code location:** `/website` in this repo. Docs in `marketing/website/`.
- **Server routes (the only dynamic code):**
  - `/go/:platform` (`ios` | `android`): reads `src` query param, writes one data point to Workers Analytics Engine (`platform`, `src`, timestamp; **no IP, no identifier**), then 302s to the configured target. Unknown platform: 302 to `/`.
  - `/api/contact`: validates honeypot, time-to-submit, rate limit; forwards to Justin's inbox (Email Workers binding or email API). Returns JSON `{ ok: true }` or `{ ok: false, error: <code> }`.
- **Single source of truth for outbound links:** one config module holding the TestFlight public link, TestFlight App Store link, Google Group URL, and Play opt-in URL. Changing a build or URL is a one-line edit.
- **Static config files:** `_redirects` (legacy and typo paths, all 302 except the routeworks 301s), `_headers` (CSP via Astro's CSP API, HSTS, caching).
- **Campaign data:** a content collection, one entry per video: `{ id: "yt012", platform: "youtube"|"facebook"|"qr", video: "MD-012", headline, subhead?, poster, clip?, callback?, active }`. Pages under `/yt###`, `/fb###` are generated from it.
- **Source propagation:** `src` stays in the URL and in page memory, is attached to `join_click`, and is appended to the `/go/*` links. No cookies, localStorage, or sessionStorage.

### Interfaces first

Per the Spec → Interface → Test → Implement rule, W4 starts by writing these as code before any page or route: the campaign collection schema (Zod in `src/content.config.ts`), the outbound-links config type, the `/go/*` and `/api/contact` request/response contracts, and the analytics event union type. Contract tests (Vitest/Playwright) pin them before implementation.

## 7. Analytics and consent

- **Vendor:** Umami Cloud free tier (100K events/month, custom events, cookieless) to start; Plausible Starter ($9/month) if UTM/channel reporting or retention becomes limiting. Cloudflare Web Analytics cannot record custom events or query strings, so it is not the primary tool.
- **Events:** `join_click {platform, src}`, `step2_click {src}`, `troubleshoot_open`, `inapp_banner_shown {app}`, `escape_click {app}`, `qr_view`, `waitlist_submit {src}`.
- **Server-side backup:** `/go/*` counter in Workers Analytics Engine (ad-blocker-proof).
- **Consent posture (US-first, small EU exposure):** no cookies or web storage; skip the analytics script entirely when the browser sends Global Privacy Control or Do Not Track; footer opt-out link; disclosure in `/privacy`. Revisit with a geo-targeted EU consent prompt only if EU traffic becomes material.

## 8. Non-functional requirements

- **Performance budgets (Lighthouse CI, mobile throttling):** LCP < 2.0 s, CLS < 0.05, total JS < 20 KB on `/` and campaign pages.
- **Accessibility:** WCAG 2.2 AA. Contrast-checked palette (4.5:1 text, 3:1 UI/focus), captions on all video, no autoplay with sound, pause control for motion over 5 s, `prefers-reduced-motion` honored, 24x24 px minimum targets, visible focus not hidden by sticky elements, labeled forms with text errors and no puzzle CAPTCHA, reflow at 320 px and 200% zoom, no overlay widgets.
- **SEO/sharing:** build-time 1200x630 OG images per page and per campaign (absolute URLs), sitemap, canonicals, `MobileApplication` JSON-LD (price 0), `Article` JSON-LD on future articles.
- **Visual design:** derived from `docs/VISUAL_DESIGN_GUIDE.md` and Stage 1 `guides/visual-style.md`; mobile-first. Fonts already in the app (Cinzel, Nunito) self-hosted.

## 9. QA gates

**Automated (CI on every PR):** Lighthouse CI budgets; Playwright tests for every campaign path, `/go/*` 302 targets and `src` pass-through, UA-highlight logic with spoofed `FBAN`/`Instagram`/iPad UAs, form contract; `@axe-core/playwright` on every page; link checker.

**Manual (before launch, before each promo wave, after each new build):** on a real iPhone and a real Android phone, complete both join flows end to end starting from (a) an unlisted YouTube video's link, (b) a Facebook Reel's first-comment link, (c) an Instagram link. Record results in `marketing/website/qa-log.md`. DevTools check for cookies/storage before any "no cookies" claim. Meta Sharing Debugger check of OG images.

**Content:** the mandatory accuracy and sense review (`marketing/README.md`) on all copy (W2) and again on the live pages (W5), then Justin's sign-off.

## 10. Operations

- New TestFlight build every 60-75 days (builds expire after 90). If a build lapses, flip the `/beta-status` banner on rather than leaving a dead link.
- Keep 25+ Android testers opted in so the 12-tester, 14-day production gate never resets.
- Repoint outbound targets in the links config, nowhere else.

## 11. Dependencies

- **Stage 1 guides:** `brand-and-voice.md`, `compliance-checklist.md` (W2 copy), `visual-style.md` (W3 design).
- **App tasks (app workstream):**
  - In-app privacy policy link to `playmathdragons.com/privacy` (none exists in `lib/` as of 2026-10-19; Apple 5.1.1(i) and Google User Data policy require one in the app). Also a parent-gated link to `/feedback`.
  - Founding-tester flag (decided 2026-10-19).
- **Justin (accounts/config):** Cloudflare zone for `playmathdragons.com`; Google Group auto-approve; Play Console feedback URL set to `/feedback`; App Store Connect privacy and support URLs; analytics account; email provider; P.O. box.

## 12. Open decisions (need Justin before W1 approval)

1. **Campaign path convention.** Proposed: `/yt012`, `/fb012` (zero-padded, platform-prefixed, matches `MD-012`). Must be fixed before the first video since it's spoken on screen.
2. **Beta links:** the TestFlight public link, Google Group URL, and Play opt-in URL (not found in the repo).
3. **iPad:** does the app support iPad, and should the TestFlight link filter devices?
4. **Analytics:** start on Umami Cloud free (proposed) or go straight to Plausible?
5. **Waitlist at launch?** Proposed: yes, small and secondary. Provider choice (needs double opt-in, postal footer, export); and P.O. box or mail-receiving agency for the CAN-SPAM address.
6. **Named privacy contact:** personal name, a business name (Routeworks?), or a role address like privacy@playmathdragons.com.
7. **Can `apps.routeworks.app/math-dragons` serve 301s indefinitely?**
8. **Origin-story imagery:** what's acceptable with no children shown.
9. **EU/UK posture:** notice + opt-out + GPC skip (proposed), or an EU consent prompt.

## 13. Verification still owed (from research)

TestFlight and Play flows inside Facebook/Instagram webviews (real device); whether `intent://` and `x-safari-https://` escapes still work; Workers `_redirects` rule limits; TestFlight TM vs R; Google Play attribution line; CAN-SPAM, Consumer Reviews Rule, and Endorsement Guides text; CalOPPA statute text and state age-verification laws; current OG/structured-data/Lighthouse/Playwright tooling versions.
