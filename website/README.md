# playmathdragons.com

Marketing site and beta landing page for Math Dragons. Spec: `../marketing/website/SPEC.md` (approved 2026-10-19).

Stack: Astro (static, `build.format: 'file'`) served by Cloudflare Workers static assets (`wrangler.jsonc`), custom domain `playmathdragons.com`. No Worker script, analytics, forms or cookies yet (phase 1: store-required pages).

## Commands

```bash
npm install
npm run dev       # local dev server
npm run check     # astro type check
npm test          # build + contract tests on dist/ (tests/dist.test.mjs)
npx wrangler dev  # serve dist/ under the Cloudflare runtime (no login needed)
npm run deploy    # build + wrangler deploy (needs `npx wrangler login` once)
```

## Rules

- All outbound links and contact addresses live in `src/config/site.ts`. Nowhere else.
- `/privacy`, `/support`, `/feedback` are linked from the shipped app (`lib/core/external_links.dart`). Never move or rename them; `tests/dist.test.mjs` enforces this.
- No inline scripts or styles (the CSP in `public/_headers` forbids them).
- Every copy change goes through the accuracy and sense review in `../marketing/README.md` and Justin's sign-off before deploy. Update the dates in `src/pages/privacy.astro` whenever the policy changes.
- Cinzel (headings) is subset to `public/fonts/cinzel-bold.woff2` from `../assets/fonts/Cinzel-Bold.ttf` (SIL Open Font License).
