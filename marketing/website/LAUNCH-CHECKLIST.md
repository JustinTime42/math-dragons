# Launch checklist: playmathdragons.com + app 1.0.3+8

Status as of 2026-10-23 (later): Cloudflare nameservers active, wrangler logged in, Zoho Mail live for support@/privacy@playmathdragons.com (MX, SPF, DKIM verified; site switched to these addresses). Remaining: delete the two proxied GoDaddy A records (domain returns 525), Google Group settings, copy sign-off, then deploy. Steps marked **JUSTIN** need your accounts; **CLAUDE** steps happen in a session once yours are done. Tick boxes as you go.

Order matters: the site must be live before build 1.0.3+8 goes to Apple/Google review, because the build links to `/privacy`, `/support` and `/feedback`.

## Part 1: get the site live

### 1. Add the domain to Cloudflare (JUSTIN, ~10 min + DNS wait)
- [x] Sign in at dash.cloudflare.com (create a free account if needed). Click **Add a domain**, enter `playmathdragons.com`, choose **Free**.
- [x] Cloudflare imports existing DNS records. **Delete the two A records** for `playmathdragons.com` pointing to `15.197.148.33` and `3.33.130.190` (GoDaddy parking). Leave anything else (e.g. MX) alone.
- [x] Copy the two nameservers Cloudflare shows (like `xxx.ns.cloudflare.com`).
- [x] At GoDaddy: My Products, then `playmathdragons.com`, then **DNS**, then **Nameservers**, then **Change nameservers**, choose **I'll use my own nameservers**, paste both Cloudflare nameservers, save. (If GoDaddy offers to turn off DNSSEC, accept.)
- [x] Back in Cloudflare, wait for the domain to show **Active** (minutes to a few hours; Cloudflare emails you).
- [x] In Cloudflare, **Security**, then **Bots**: make sure **Bot Fight Mode is off** (it sets a cookie; the privacy policy says the site sets none).

### 2. Log wrangler in (JUSTIN, 1 min)
- [x] In Claude Code, run: `! cd website && npx wrangler login` and approve in the browser.

### 3. Lock down the Google Group (JUSTIN, 3 min)
At groups.google.com, open **math dragons**, then **Group settings**:
- [x] **Who can join group:** keep **Anyone can join** (testers must be able to join instantly).
- [x] **Who can view members:** **Group managers**.
- [x] **Who can view conversations:** **Group managers**.
- [x] **Who can post:** **Group managers**.
- [x] Save.

(Today any member can see other testers' emails and post to the group. The privacy policy says other testers can't see emails, so this must be done before the site goes live.)

### 4. Sign off on the copy (JUSTIN, ~15 min)
- [x] Read the pages: `cd website && npm run dev`, then open the local URL (pages: `/`, `/privacy`, `/support`, `/feedback`). Source: `website/src/pages/`. Review notes: `marketing/website/pages-v1.review.md`.
- [x] Confirm or correct the origin line on `/`: "My daughter was struggling with math facts, and every app we tried had the same problems. So I built one."
- [x] Confirm: **OS backups stay on** (iCloud / Android auto backup restore progress and the founding flag; disclosed in the policy).
- [x] Confirm: **support emails deleted within 12 months** after a conversation ends (now promised in the policy).
- [x] Tell Claude "copy approved" (plus any changes).

### 5. Deploy and verify (CLAUDE): DONE 2026-10-23, version 5cfb201b
Live check: /, /privacy, /support, /feedback 200; /privacy/ 307 to /privacy; unknown path 404; CSP, HSTS, nosniff, referrer and permissions headers present; zero Set-Cookie on all pages; no Cloudflare-injected scripts (email obfuscation not active), mailto links intact; only script is /js/platform.js (no storage APIs).
- [ ] **JUSTIN:** Cloudflare, SSL/TLS, Edge Certificates: turn on **Always Use HTTPS** (http:// currently serves the page instead of redirecting).
- [x] `npm test`, then `npm run deploy` (custom domain attaches automatically).
- [x] Verify live: HTTPS, all four pages, 404, security headers, `/privacy/` redirects to `/privacy`.
- [x] Verify **no cookies or storage** in a real browser's DevTools before the "no cookies" line stands.
- [ ] Merge `website/store-pages` (on Justin's OK).

### Email (done 2026-10-23)
- [x] Zoho Mail: support@ and privacy@playmathdragons.com send and receive; MX/SPF/DKIM (`zmail`) verified by DNS lookup.
- [ ] Optional: the imported `_dmarc` record sends reports to GoDaddy (`dmarc_rua@onsecureserver.net`); change `rua` to `mailto:privacy@playmathdragons.com` or remove it.
- [ ] After deploy: update the contact email in App Store Connect and Play Console to support@playmathdragons.com.

## Part 2: ship app 1.0.3+8

### 6. Merge and build (CLAUDE, on Justin's OK to push)
- [ ] Merge `app/store-links-founding-flag` into `main` and push (this triggers the Codemagic iOS test workflow).
- [ ] Remove the worktree `~/dev/math-dragons-app-links` after merge.

### 7. iOS (JUSTIN)
- [ ] In Codemagic, start **iOS Release (App Store)** manually. It uploads to TestFlight.
- [ ] In App Store Connect: Math Dragons, then **App Information**: set **Privacy Policy URL** to `https://playmathdragons.com/privacy`. In the version's page, set **Support URL** to `https://playmathdragons.com/support`.
- [ ] TestFlight, then your **external testing group**: add build 1.0.3 (8) and submit it for **Beta App Review**.
- [ ] Once approved: make sure the group's **public link is enabled** and the tester limit isn't reached. This should clear the "isn't accepting any new testers" message (the likely cause is an expired or unapproved external build).
- [ ] Open the link on a phone to confirm it offers **Accept / Install**.

### 8. Android (JUSTIN)
- [ ] Build the bundle (Claude can do it: `flutter build appbundle --release`; output `build/app/outputs/bundle/release/app-release.aab`).
- [ ] Play Console: Math Dragons, then **Test and release**, then **Closed testing**, then your track, then **Create new release**, upload the `.aab`, roll out.
- [ ] **App content**, then **Privacy policy**: set `https://playmathdragons.com/privacy`.
- [ ] Closed testing track, **Testers** tab: set the **Feedback URL or email** to `https://playmathdragons.com/feedback`.
- [ ] Store listing contact details: website `https://playmathdragons.com`.

### 9. End-to-end check (JUSTIN + CLAUDE)
- [ ] On a real iPhone and a real Android phone, follow the steps on playmathdragons.com from scratch, and check Settings, For Parents: all three links open behind the grown-ups check.
- [ ] Log results in `marketing/website/qa-log.md`.
