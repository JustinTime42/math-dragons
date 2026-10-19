// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  site: 'https://playmathdragons.com',
  // privacy.html is served at /privacy by Cloudflare's asset handling,
  // so URLs stay slash-free (matches the links baked into the app).
  build: {
    format: 'file',
    // Keep CSS in files so the Content Security Policy needs no inline styles.
    inlineStylesheets: 'never',
  },
  trailingSlash: 'never',
});
