// Checks the built site in dist/ (run `npm run build` first; `npm test` does both).
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, readdirSync, existsSync, statSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const dist = join(root, 'dist');

const htmlFiles = readdirSync(dist).filter((f) => f.endsWith('.html'));
const pages = Object.fromEntries(htmlFiles.map((f) => [f, readFileSync(join(dist, f), 'utf8')]));

// Paths the app opens from Settings > For Parents (lib/core/external_links.dart).
// Changing these breaks shipped builds.
const APP_LINKED_PATHS = ['/privacy', '/support', '/feedback'];

const ALLOWED_EXTERNAL = new Set([
  'https://testflight.apple.com/join/Qj1a4NA8',
  'https://apps.apple.com/app/testflight/id899247664',
  'https://groups.google.com/g/math-dragons',
  'https://play.google.com/apps/testing/com.mathdragonsgame.mathDragons',
]);

const resolve = (path) => {
  const clean = path.split('#')[0].split('?')[0];
  if (clean === '' || clean === '/') return join(dist, 'index.html');
  const direct = join(dist, clean);
  if (existsSync(direct) && statSync(direct).isFile()) return direct;
  return join(dist, `${clean}.html`);
};

const hrefs = (html) => [...html.matchAll(/href="([^"]+)"/g)].map((m) => m[1]);

test('required pages exist', () => {
  for (const f of ['index.html', 'privacy.html', 'support.html', 'feedback.html', '404.html']) {
    assert.ok(pages[f], `missing ${f}`);
  }
});

test('every path linked from the app resolves to a page', () => {
  for (const p of APP_LINKED_PATHS) {
    assert.ok(existsSync(resolve(p)), `app links to ${p}, which does not exist`);
  }
});

test('internal links and anchors resolve', () => {
  for (const [file, html] of Object.entries(pages)) {
    for (const href of hrefs(html)) {
      if (!href.startsWith('/')) continue;
      assert.ok(existsSync(resolve(href)), `${file}: broken link ${href}`);
      const anchor = href.split('#')[1];
      if (anchor) {
        const target = readFileSync(resolve(href), 'utf8');
        assert.ok(target.includes(`id="${anchor}"`), `${file}: missing anchor #${anchor}`);
      }
    }
  }
});

test('external links are only the configured beta links or email', () => {
  for (const [file, html] of Object.entries(pages)) {
    for (const href of hrefs(html)) {
      if (href.startsWith('/') || href.startsWith('#')) continue;
      if (href.startsWith('mailto:')) {
        assert.match(href, /^mailto:(support|privacy)@playmathdragons\.com/, `${file}: ${href}`);
        continue;
      }
      if (href.startsWith('https://playmathdragons.com')) continue; // canonical / og
      assert.ok(ALLOWED_EXTERNAL.has(href), `${file}: unexpected external link ${href}`);
    }
  }
});

test('CSP-safe: no inline scripts or inline styles', () => {
  for (const [file, html] of Object.entries(pages)) {
    for (const m of html.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/g)) {
      assert.match(m[1], /\bsrc="/, `${file}: inline <script> found`);
      assert.equal(m[2].trim(), '', `${file}: script with inline body`);
    }
    assert.ok(!/<style[\s>]/.test(html), `${file}: inline <style> found`);
    assert.ok(!/\sstyle="/.test(html), `${file}: style attribute found`);
  }
});

test('brand rules: no em-dashes, no banned claims', () => {
  const banned = [/COPPA compliant/i, /\bproven\b/i, /\bimproves?\b/i, /\bguarantee/i, /\bgenius\b/i, /we collect no data/i];
  for (const [file, html] of Object.entries(pages)) {
    const text = html.replace(/<[^>]+>/g, ' ');
    assert.ok(!text.includes('—'), `${file}: em-dash found`);
    for (const re of banned) assert.ok(!re.test(text), `${file}: banned phrase ${re}`);
  }
});

test('no missing spaces around links or bold text', () => {
  // Catches "theprivacy policy" / "</a>and": a word glued to an inline tag.
  const glued = /[A-Za-z0-9,]<(a|strong)\b|<\/(a|strong)>[A-Za-z(]/g;
  for (const [file, html] of Object.entries(pages)) {
    const body = html.slice(html.indexOf('<body'));
    const hits = [...body.matchAll(glued)].map((m) => body.slice(m.index - 15, m.index + 25));
    assert.deepEqual(hits, [], `${file}: text glued to a tag`);
  }
});

test('every image has an alt attribute', () => {
  for (const [file, html] of Object.entries(pages)) {
    for (const m of html.matchAll(/<img\b[^>]*>/g)) {
      assert.match(m[0], /\salt(="|[\s>])/, `${file}: img without alt`); // bare alt = decorative
    }
  }
});

test('privacy policy names the developer and privacy contact', () => {
  const html = pages['privacy.html'];
  assert.ok(html.includes('Routeworks LLC'));
  assert.ok(html.includes('privacy@playmathdragons.com'));
  assert.ok(html.includes('The app collects no data') || html.includes('the app collects no data'));
});

test('beta perk wording matches the brand guide exactly where stated', () => {
  const perk = 'Everyone in the beta gets the full unlock free when Math Dragons launches.';
  assert.ok(pages['index.html'].replace(/\s+/g, ' ').includes(perk));
});

test('no unexpected network endpoints in config', () => {
  const headers = readFileSync(join(dist, '_headers'), 'utf8');
  assert.match(headers, /connect-src 'none'/);
});
