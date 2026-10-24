/**
 * Single source of truth for every outbound link and contact address on the
 * site (marketing/website/SPEC.md §6). Changing a build or URL is a one-line
 * edit here, nowhere else.
 */

export interface BetaLinks {
  /** TestFlight public link (iPhone and iPad). */
  testflight: string;
  /** Apple's TestFlight app on the App Store (step 1 of the iOS flow). */
  testflightApp: string;
  /** Open-join Google Group; testers must join before opting in. */
  googleGroup: string;
  /** Play closed-testing opt-in page. */
  playOptIn: string;
}

export interface Contacts {
  support: string;
  privacy: string;
  developer: string;
}

export const SITE_URL = 'https://playmathdragons.com';

export const beta: BetaLinks = {
  testflight: 'https://testflight.apple.com/join/Qj1a4NA8',
  testflightApp: 'https://apps.apple.com/app/testflight/id899247664',
  googleGroup: 'https://groups.google.com/g/math-dragons',
  playOptIn: 'https://play.google.com/apps/testing/com.mathdragonsgame.mathDragons',
};

export const contacts: Contacts = {
  support: 'support@playmathdragons.com',
  privacy: 'privacy@playmathdragons.com',
  developer: 'Routeworks LLC',
};

export const mailto = (address: string, subject?: string) =>
  `mailto:${address}${subject ? `?subject=${encodeURIComponent(subject)}` : ''}`;
