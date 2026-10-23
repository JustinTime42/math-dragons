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
  // Astro's HTML compression dropped the space between a line of text and a
  // link starting on the next line ("theprivacy policy"). Pages are small;
  // keep the whitespace.
  compressHTML: false,
});
