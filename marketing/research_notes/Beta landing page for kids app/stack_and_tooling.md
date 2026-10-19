# Stack and Tooling for playmathdragons.com (researched 2026-10-19)

Scope: hosting, framework, analytics, attribution, device detection, forms/email, OG/SEO, QR, testing for a small, fast, cookieless marketing + beta landing site. All prices/limits are as fetched or reported on 2026-10-19 unless noted. Third-party comparison blogs were used only where vendor pages could not be fetched; those are flagged.

## Hosting: Cloudflare Workers static assets vs Cloudflare Pages vs Vercel vs Netlify vs GitHub Pages

### Takeaway
Cloudflare Workers with static assets is the strongest fit: static asset requests are free and unlimited, commercial use is fine, `_redirects`/`_headers` work natively, and Workers is the platform Cloudflare is steering migrations toward. Vercel Hobby is disqualified for a commercial app marketing site (needs Pro at $20/mo per seat); GitHub Pages is disqualified by its "no online business" rule; Netlify Free is now a 300-credit metered plan.

### Cited Findings
- Cloudflare's compatibility matrix lists Workers (with static assets) as supporting Redirects, Custom HTTP headers, Middleware, Preview URLs, Rollbacks, Gradual Deployments, Workers Logs, Source Maps, Cron Triggers, Rate Limiting and Email Workers bindings; Pages lacks Gradual Deployments, Workers Logs, Cron Triggers, Rate Limiting binding, Email Workers. Pages-only advantages: "Custom domains outside Cloudflare zones" and full Early Hints (Workers is partial). Fetched 2026-10-19 — [Cloudflare Workers vs Pages compatibility matrix](https://developers.cloudflare.com/workers/static-assets/compatibility-matrix/)
- The matrix states Workers has a broader feature set and frames Workers as the migration target from Pages, but does not literally say "use Workers for new projects" on that page — [Cloudflare compatibility matrix](https://developers.cloudflare.com/workers/static-assets/compatibility-matrix/); [Migrate from Pages guide](https://developers.cloudflare.com/workers/static-assets/migration-guides/migrate-from-pages/)
- Note: an earlier search-engine snapshot of the matrix said Workers did NOT yet support redirects/middleware; the live page (2026-10-19) shows both supported. Older blog posts asserting "Workers can't do redirects" are outdated — [Cloudflare compatibility matrix](https://developers.cloudflare.com/workers/static-assets/compatibility-matrix/)
- `_redirects` and `_headers` files "are supported natively in Workers with static assets" when placed in the static asset directory — [Cloudflare migrate-from-Pages guide](https://developers.cloudflare.com/workers/static-assets/migration-guides/migrate-from-pages/)
- Middleware via `run_worker_first` is billed as a normal Worker invocation; static asset requests are free — [Cloudflare migrate-from-Pages guide](https://developers.cloudflare.com/workers/static-assets/migration-guides/migrate-from-pages/)
- Workers Free: 100,000 requests/day, 10 ms CPU per invocation; Workers Paid minimum $5/month per account; "Requests to static assets are free and unlimited." — [Cloudflare Workers pricing](https://developers.cloudflare.com/workers/platform/pricing/)
- Third-party 2026 guides describe Workers static assets as Cloudflare's recommended successor to Pages for new projects while Pages remains supported (secondary sources) — [Mecanik.dev](https://mecanik.dev/en/posts/cloudflare-pages-vs-workers-which-to-use-in-2026/); [MorphLLM](https://www.morphllm.com/comparisons/cloudflare-pages-vs-workers)
- Vercel: "Hobby teams are restricted to non-commercial personal use only. All commercial usage of the platform requires either a Pro or Enterprise plan." Commercial use is defined as any deployment "used for the purpose of financial gain of anyone involved in any part of the production," including "Advertising the sale of a product or service." Page last updated 2026-09-14 — [Vercel Fair Use Guidelines](https://vercel.com/docs/limits/fair-use-guidelines)
- Vercel Hobby typical monthly inclusions: 100 GB Fast Data Transfer, 1M function invocations, 5K image transformations; Pro is on "Flat Rate CDN" and usage-based billing — [Vercel Fair Use Guidelines](https://vercel.com/docs/limits/fair-use-guidelines)
- Vercel Pro: $20/month per Developer seat, includes $20 usage credit; Hobby $0 with 1M CDN requests, 100 GB transfer — [Vercel Pricing](https://vercel.com/pricing)
- Netlify (2026-10-19): Free = 300 credits; Personal $9/mo (1,000 credits); Pro $20/mo (3,000 credits). Usage: production deploy 15 credits, bandwidth 20 credits/GB, web requests 2 credits/10K, compute 10 credits/GB-hr. Pricing page did not state commercial-use terms or forms limits — [Netlify Pricing](https://www.netlify.com/pricing/)
- GitHub Pages: soft 100 GB/month bandwidth, 1 GB site size, soft 10 builds/hour (not applied to custom Actions workflows); "is not intended for or allowed to be used as a free web-hosting service to run your online business," and not for sites "primarily directed at either facilitating commercial transactions" — [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)

### Inferences
- Netlify arithmetic: 300 credits / 20 per GB = at most ~15 GB/month of bandwidth with zero deploys; every production deploy costs 15 credits, so ~10 deploys eats half the free allowance. A viral Short could exhaust Free quickly. Cloudflare has no comparable bandwidth meter for static assets.
- The marketing site advertises a product (even a free beta of a future-monetized app), which plausibly falls under Vercel's "advertising the sale of a product or service" definition. Treat Vercel as $20/mo Pro or not at all.
- Recommended layout on Cloudflare: Astro static build to `dist/`, deployed as a Worker with `assets.directory`, `_redirects` for `/yt1`-style short paths (zero Worker invocations, free), and a tiny Worker route only for `/api/contact` (form POST) using free-tier invocations. DNS on Cloudflare (needed anyway, since Workers custom domains require a Cloudflare zone per the matrix).
- Since the owner is a pro web dev, Workers' Vite plugin, gradual deploys, and Workers Logs are useful extras Pages lacks.

### Gaps
- Could not find a Cloudflare first-party sentence explicitly stating "we recommend Workers for new projects" on the pages fetched; only third-party blogs say so.
- `_redirects` rule-count limits for Workers static assets were not stated on the fetched page (Pages historically documented 2,000 static + 100 dynamic; unverified for Workers in this session).
- Netlify's credit period (monthly assumed) and Free-tier commercial-use terms were not stated on the pricing page; the date credit pricing launched was not found.

## Framework: Astro vs Next.js static export vs Eleventy vs SvelteKit

### Takeaway
Astro is the natural pick: content-first, zero-JS by default, first-class MDX/content collections, and since January 2026 its team is part of Cloudflare, so the Astro + Cloudflare pairing is now first-party. Astro 6 (stable ~March 2026) is current.

### Cited Findings
- Cloudflare announced on 2026-01-16 that it acquired The Astro Technology Company; Astro remains open source (MIT) and usable regardless of host — [Business Wire press release](https://secure.businesswire.com/news/home/20260116386991/en/Cloudflare-Acquires-Astro-to-Accelerate-the-Future-of-High-Performance-Web-Development); [Roboin](https://roboin.io/article/en/2026/01/17/cloudflare-acquires-astro-web-framework/); [Gigazine](https://gigazine.net/gsc_news/en/20260119-cloudflare-acquires-astro)
- Astro 6 beta announced alongside the acquisition; Astro 6 stable reported ~2026-03-10 (one source says Feb 10, which appears to be the beta date; conflict) — [Bytes #469](https://bytes.dev/archives/469); [InfoQ](https://www.infoq.com/news/2026/02/astro-v6-beta-cloudflare); contradicted by [noqta.tn](https://noqta.tn/en/blog/astro-6-content-first-web-framework-developer-guide-2026)
- Astro 6: Live Content Collections stable (were experimental in 5.10); build-time collections remain preferred when content needn't be real-time; Fonts API and CSP API stable; experimental Rust compiler; rebuilt `@astrojs/cloudflare` adapter runs workerd in dev/prerender/prod — [Astro 6 Beta blog](https://astro.build/blog/astro-6-beta/); [heise](https://www.heise.de/en/news/Web-framework-Astro-6-0-experiments-with-new-Rust-compiler-11207142.html?view=print)

### Inferences
- For this site, use build-time content collections (glob loader over `src/content/articles/*.mdx`) not live collections; everything prerenders to static HTML.
- Astro's stable CSP API is directly useful for a privacy-first site (hash-based CSP without hand-maintaining script hashes).
- Next.js static export ships a React runtime for hydration even on mostly-static pages, which is wasted bytes on in-app browsers; Eleventy is equally fast but lacks typed content collections and an integrated image pipeline; SvelteKit is fine but its strength (app-like interactivity) isn't needed. (Background knowledge, not re-verified this session.)
- Astro features worth using (background knowledge, verify against current docs): `astro:assets` `<Image>`/`<Picture>` for AVIF/WebP with explicit dimensions (prevents CLS), `@astrojs/mdx`, `@astrojs/sitemap`, View Transitions / `<ClientRouter>` (optional; likely unnecessary for a 3-5 page site and adds JS), islands only for the form.

### Gaps
- No 2026 benchmark comparing Lighthouse scores across these frameworks was found in this session.
- Exact current Astro patch version (6.x) not confirmed.

## Analytics: cookieless options

### Takeaway
Cloudflare Web Analytics is free but cannot do custom events or see query strings, so it cannot measure "iPhone join"/"Android join" clicks or `?src=yt1`. Umami Cloud's free Hobby tier (100K events/mo, custom events, no cookies) or Plausible ($9/mo Starter) are the best fits. Vercel Web Analytics only applies if on Vercel.

### Cited Findings
- Cloudflare Web Analytics: custom events "Not yet, but we may add support for this in the future"; "Cloudflare Web Analytics do not log query strings to avoid collecting potentially sensitive data"; unsampled data kept 7 days then aggregated to ~10%, with dynamic sampling on queries — [Cloudflare Web Analytics FAQ](https://developers.cloudflare.com/web-analytics/faq/)
- Umami Cloud (2026-10-19): Hobby free, 100K events/mo, 1 website, 6-month retention; Pro $20/mo, 1M events, 20 sites, 2-year retention; custom events on all plans; no cookies, so no cookie banner required (vendor claim) — [Umami pricing](https://umami.is/pricing)
- Note: a third-party guide claims Umami Cloud free is 1M events/month, which conflicts with Umami's own page (100K); trust the vendor page — [APIScout](https://apiscout.dev/guides/plausible-vs-umami-vs-fathom-analytics-2026); contradicted by [Umami pricing](https://umami.is/pricing)
- Plausible (2026-10-19): Starter $9/mo, Growth $14/mo, Business $19/mo (monthly billing, 10K pageview entry tier; yearly = 2 months free); custom events/goals on all plans; UTM campaign tracking with channel grouping; "No cookies", "No cookie banner required" (vendor claim); self-hostable AGPL Community Edition — [Plausible](https://plausible.io/#pricing); [APIScout](https://apiscout.dev/guides/plausible-vs-umami-vs-fathom-analytics-2026)
- Funnels are reportedly Business-tier only on Plausible (secondary) — [classcub comparison](https://tt.classcub.com/blog/plausible-vs-fathom-vs-matomo)
- Fathom: ~$15/mo, cloud-only, closed source, cookieless; Simple Analytics: ~$19-20/mo, EU (Dutch) hosted, leans on auto-events (secondary sources, unverified against vendor pages) — [APIScout](https://apiscout.dev/guides/plausible-vs-umami-vs-fathom-analytics-2026); [Ripples](https://ripples.sh/blog/plausible-vs-fathom-vs-simple-analytics)
- Vercel Web Analytics: Hobby includes 50K events/month; Pro $3 per 100K events; Web Analytics Plus add-on $10/mo on Pro — [Vercel Pricing](https://vercel.com/pricing)
- PostHog can run cookieless with `persistence: "memory"` (persists only for one page view) or `disable_persistence: true`; cost is a new anonymous ID per page load, no returning-user identity; consent defaults are stored in localStorage unless configured — [PostHog persistence docs](https://posthog.com/docs/libraries/js/persistence)

### Inferences
- Pick Umami Cloud Hobby (free) or Plausible Starter. Both accept custom events with properties, so fire `join_click` with `{platform: "ios"|"android", src: "yt1"}`.
- PostHog is overkill for a landing page and its cookieless mode degrades it to roughly Plausible-level counting with a heavier script.
- Cloudflare Web Analytics can still run alongside for free page-view sanity checks, but it cannot be the conversion tool.
- Self-hosting Umami on the same Cloudflare account is possible but adds a database to maintain; cloud free tier is enough at beta scale.
- Consent-banner status is a vendor claim; the legal researcher should confirm (out of scope here).

### Gaps
- Fathom and Simple Analytics prices were not verified on vendor pages this session.
- PostHog's separate "cookieless_mode" server-side hashing option and free-tier event allowance were not covered by the fetched page.

## Attribution design: path redirects vs UTM, carrying source to outbound clicks

### Takeaway
Use `_redirects` rules like `/yt1 /?src=yt1 302` (free, no Worker invocation), read `src` client-side, attach it as a property on the outbound "join" click event, and treat that click as the conversion proxy. Nothing is trackable past TestFlight/Play without store-side tooling.

### Cited Findings
- `_redirects` is natively supported on Workers static assets — [Cloudflare migrate-from-Pages guide](https://developers.cloudflare.com/workers/static-assets/migration-guides/migrate-from-pages/)
- Cloudflare Web Analytics does not log query strings, so `?src=` values are invisible there — [Cloudflare Web Analytics FAQ](https://developers.cloudflare.com/web-analytics/faq/)
- Plausible natively reports UTM campaigns with channel grouping — [Plausible](https://plausible.io/#pricing)

### Inferences
- Redirect to `/?utm_source=youtube&utm_medium=shorts&utm_campaign=yt1` (instead of a custom `src`) so Plausible/Umami pick it up automatically with zero code; then also copy `utm_campaign` into the click event property. Short path for humans, UTM for tools.
- Alternative that avoids a redirect hop (faster on slow in-app connections): build `/yt1/index.html` as a real page (same content) with canonical to `/`, and fire the pageview with the path; analytics then sees `/yt1` directly. Trade-off: duplicate URLs (handled via canonical + noindex).
- Use 302 (not 301) so browsers don't permanently cache mappings you may repoint.
- Persist `src` only in memory or sessionStorage for the visit (sessionStorage is not a cookie; legal researcher to confirm treatment), and append it to outbound link `data-` attributes.
- Google Play listing URLs accept a `referrer` param in some flows, but closed testing via opt-in link gives no install attribution back to the site; TestFlight public links give none. Conversion = outbound click count by platform by source.
- Optionally add a server-side counter: route `/go/ios?src=yt1` through a tiny Worker that writes to Workers Analytics Engine then 302s to TestFlight. Cookieless, ad-blocker proof, and counts clicks even if the analytics script is blocked. Costs one free-tier invocation per click.

### Gaps
- Did not verify whether Google Play closed-testing opt-in URLs pass any referrer through.

## Device detection in in-app browsers

### Takeaway
Use client-side UA sniffing to choose which button to highlight, never to hide the other one. Detect in-app browsers (FBAN/FBAV/Instagram tokens) to show an "open in browser" hint if the TestFlight/Play handoff fails. iPads report a Mac UA by default and need a touch check.

### Cited Findings
- Facebook in-app browser UA contains `FBAN`/`FBAV` (app name/version); Android adds `FB_IAB`/`FB4A`, iOS `FBIOS`; Instagram UA contains `Instagram <version>` — [StackOverflow archive](https://dev.library.kiwix.org/content/stackoverflow_en_nopic_2021-08/questions/31569518/how-to-detect-facebook-in-app-browser); [Bankrate production script](https://www.bankrate.com/v6.402.0/next/build/assets/isMetabrowser-Bhx5FPe_.js)
- `inapp-spy` (npm, v5.0.10) detects facebook, instagram, messenger, threads, tiktok, gsa (Google app), linkedin, reddit, snapchat, telegram, twitter, wechat, whatsapp, line via UA; YouTube is NOT in its list; advises client-side detection for accuracy, "always test on real devices," and has an experimental async SFSafariViewController check that "may return false positives" — [inapp-spy README](https://cdn.jsdelivr.net/npm/inapp-spy@5.0.10/README.md)

### Inferences
- YouTube's app on iOS typically opens links in SFSafariViewController (a real Safari, indistinguishable by UA) and on Android in Chrome Custom Tabs; that's why no YouTube UA token exists. Those are full browsers, so TestFlight/Play links generally work from YouTube. Facebook/Instagram use their own WKWebView/Android WebView, which is where store handoff breaks. (Background knowledge; must be verified on real devices.)
- iPadOS 13+ Safari sends a Macintosh desktop UA by default; detect with `/Macintosh/.test(ua) && navigator.maxTouchPoints > 1` to treat as iOS. (Background knowledge, not sourced this session.)
- UA Client Hints (`navigator.userAgentData`) are Chromium-only; absent on all iOS browsers (WebKit), so they cannot be the primary signal. Use plain UA regex; hints at most as a refinement on Android. (Background knowledge.)
- Do detection client-side in a few lines of inline JS (no library needed for just iOS/Android/in-app), so pages stay fully static and cacheable. Server-side UA routing would require Worker invocations on every hit and break caching.
- Default (no JS / unknown): show both buttons equally.

### Gaps
- No primary source fetched on iPadOS desktop UA or Client Hints support; flagged as background knowledge.
- No 2026 data on whether TestFlight `testflight.apple.com/join/...` links open correctly from Instagram/Facebook WKWebView; needs real-device testing.

## Forms, spam protection, email waitlist

### Takeaway
Simplest privacy-forward path: a Worker endpoint (`/api/contact`) that validates Cloudflare Turnstile and sends mail via Email Workers or an email API, or Web3Forms (250 free/mo) if you want zero backend. For the waitlist, EmailOctopus (2,500 free subscribers) or Kit's free plan (10,000) are generous; Buttondown is the developer-friendly paid pick.

### Cited Findings
- Turnstile: Cloudflare says it "processes only the data strictly necessary to provide this security function" and "does not access, store, or transmit user communications, form entries"; Pre-Clearance mode issues a cookie — [Turnstile FAQ](https://developers.cloudflare.com/turnstile/frequently-asked-questions/)
- Turnstile Privacy Addendum: signals are "strictly necessary for the purpose of detecting and blocking bots"; specific cookies are in Cloudflare's Cookie Policy — [Turnstile Privacy Addendum](https://www.cloudflare.com/it-it/turnstile-privacy-policy)
- In practice a `cf.turnstile.u` cookie set by challenges.cloudflare.com has been flagged by Cookiebot as loading before consent; Pre-Clearance sets `cf_clearance` — [Webflow forum](https://discourse.webflow.com/t/cookie-consent-compliance-cf-turnstile-u-cookie-loading-before-consent/326947); [Friendly Captcha analysis (competitor)](https://friendlycaptcha.com/insights/cloudflare-turnstile-gdpr/)
- Consent platforms classify Turnstile as essential (vendor claim) — [ConsentStack](https://www.consentstack.io/vendors/cloudflare-turnstile)
- Workers static assets supports Email Workers and Rate Limiting bindings (Pages does not) — [Cloudflare compatibility matrix](https://developers.cloudflare.com/workers/static-assets/compatibility-matrix/)
- Web3Forms free: 250 submissions/mo, unlimited forms, hCaptcha included; Formspree free: 50/mo, reCAPTCHA paid-only (secondary/competitor sources) — [splitforms](https://splitforms.com/blog/web3forms-vs-formspree-vs-splitforms); [agentdeals](https://agentdeals.dev/vendor/web3forms)
- Waitlist pricing (secondary sources, 2026): Buttondown free to 100 subs, paid from $9/mo; EmailOctopus free to 2,500 subs / 10,000 emails/mo; Loops free to 1,000 contacts, paid from $49/mo; Kit free Newsletter plan 10,000 subs, Creator from $33/mo annual ($39 monthly) after a September 2025 price increase — [devtoolpicks](https://devtoolpicks.com/blog/best-mailchimp-alternatives-indie-hackers-2026); [EmailOctopus blog](https://emailoctopus.com/blog/best-free-email-marketing-tools); [EmailOctopus on Kit price hike](https://blog.emailoctopus.com/kit-formerly-convertkit-price-hike); [Sequenzy](https://www.sequenzy.com/blog/best-affordable-email-marketing-tools)

### Inferences
- Lowest-cookie spam protection: honeypot field + time-to-submit check + Workers Rate Limiting binding, adding Turnstile only if spam appears. Load Turnstile only on the contact page (not site-wide) to keep landing pages script-free.
- Web3Forms bundles hCaptcha, which is another third party; a self-built Worker keeps data on one vendor.
- For a kids' app audience the waitlist subscribers are parents; a double opt-in provider with EU hosting (EmailOctopus is UK-based; Buttondown is privacy-friendly and API-first) fits. Store minimal fields (email only). Legal implications are for the legal researcher.
- Could also store waitlist emails in D1 via the same Worker and export later, avoiding any ESP until launch.

### Gaps
- Vendor pricing pages for Buttondown, Loops, EmailOctopus, Kit, Resend Audiences, Basin, Formspree not fetched this session; figures are secondary. Resend Audiences and Basin not researched.
- Turnstile free-tier widget/siteverify limits not found.

## OG images, SEO, structured data, QR codes

### Takeaway
Generate OG images at build time (satori + resvg, or an Astro OG integration) to keep the site static; add `@astrojs/sitemap`, canonical tags, and `MobileApplication` JSON-LD. Generate QR codes at build time as inline SVG.

### Cited Findings
- No sources fetched this session for this question (tool budget prioritized hosting/analytics).

### Inferences (background knowledge, verify before relying)
- OG images: an Astro endpoint like `src/pages/og/[slug].png.ts` using `satori` (JSX/HTML to SVG) + `@resvg/resvg-js` (SVG to PNG), prerendered at build; 1200x630 PNG. Packages such as `astro-og-canvas` exist as alternatives. Need to bundle a TTF/OTF font (satori doesn't support WOFF2).
- Facebook/Instagram scrapers need absolute `og:image` URLs and cache aggressively; use the Meta Sharing Debugger to refresh.
- Structured data: schema.org `MobileApplication` (subtype of `SoftwareApplication`) with `name`, `operatingSystem` ("iOS, Android"), `applicationCategory` ("EducationalApplication" / "GameApplication"), `offers` (price 0). Google's rich result eligibility for software apps typically requires ratings/reviews, which a beta lacks, so expect no rich result yet. Articles: `Article`/`BlogPosting` JSON-LD.
- QR: the `qrcode` npm package can emit SVG strings at build time inside an Astro component; zero runtime JS. Point QR codes at short paths (`/qr1`) so they are attributable and repointable.

### Gaps
- Current Google documentation on SoftwareApplication rich result requirements not verified in 2026.
- No verified current version/maintenance status for astro-og-canvas or satori.

## Testing and QA

### Takeaway
Lighthouse CI (mobile, throttled) in GitHub Actions, Playwright for viewport and redirect/link tests (including UA-spoofed iOS/Android/in-app cases), axe-core via `@axe-core/playwright`, plus a manual real-device matrix inside YouTube, Facebook, Instagram on iOS and Android.

### Cited Findings
- inapp-spy's maintainer advises to "always test on real devices" for in-app browser behavior — [inapp-spy README](https://cdn.jsdelivr.net/npm/inapp-spy@5.0.10/README.md)
- Otherwise no sources fetched this session for this question.

### Inferences (background knowledge)
- Playwright device descriptors (`devices['iPhone 15']`, `devices['Pixel 7']`) plus custom UA strings containing `FBAN/FBAV` or `Instagram` can unit-test highlight logic; they cannot reproduce real WKWebView store-handoff behavior.
- Test every `_redirects` short path with `wrangler dev` or against a preview URL in Playwright (assert 302 + Location with expected UTM).
- Lighthouse CI budgets: e.g. LCP < 2.0 s on mobile throttle, total JS < 20 KB, CLS < 0.05; fail the build on regressions.
- Real-device matrix: post an unlisted test Short/Reel or DM the link to yourself in each app; verify button highlighting, TestFlight link opens App Store/TestFlight, Play opt-in link works, and the form submits.

### Gaps
- No 2026 sources on Lighthouse CI or Playwright versions gathered; no published data on in-app browser performance characteristics.
