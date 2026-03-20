# Google Play Publishing Guide

Reference document for setting up and publishing Math Dragons on Google Play,
including developer account requirements, website pages, and Families Policy compliance.

---

## Table of Contents

1. [Developer Account Setup](#1-developer-account-setup)
2. [Website Requirements](#2-website-requirements)
3. [Landing Page Spec](#3-landing-page-spec)
4. [Privacy Policy Spec](#4-privacy-policy-spec)
5. [Support Page Spec](#5-support-page-spec)
6. [Play Console Listing Fields](#6-play-console-listing-fields)
7. [Families Policy Compliance](#7-families-policy-compliance)
8. [Data Safety Form](#8-data-safety-form)
9. [Multi-App Strategy](#9-multi-app-strategy)
10. [Pre-Submission Checklist](#10-pre-submission-checklist)

---

## 1. Developer Account Setup

### Account Type

Register as an **Organization** (not Personal), using the existing LLC.

### Requirements

| Requirement | Details |
|---|---|
| **D-U-N-S Number** | Mandatory for organization accounts. 9-digit identifier from Dun & Bradstreet. Check/request at [dnb.com](https://www.dnb.com/). Free, but can take **up to 30 days** to issue. |
| **Registration Fee** | One-time $25 via Google Payments. |
| **Business Info Match** | Legal name and address in Google Payments must **exactly match** the D-U-N-S / Dun & Bradstreet profile. |
| **Verified Phone Number** | Becomes public on Play Store developer page. |
| **Verified Email Address** | Becomes public on Play Store developer page. |
| **Google Search Console** | Must verify ownership of the organization website domain via Google Search Console **before** linking it in Play Console. |

### Setup Steps

1. Check if the LLC already has a D-U-N-S number at [dnb.com](https://www.dnb.com/).
   - If not, request one (allow up to 30 days).
2. Ensure LLC name/address in Dun & Bradstreet matches exactly what will be in Google Payments.
3. Verify the business domain in [Google Search Console](https://search.google.com/search-console) (DNS TXT record method recommended).
4. Register at [play.google.com/console](https://play.google.com/console) → choose **Organization**.
5. Pay $25, enter LLC info matching D-U-N-S profile.
6. Complete identity verification (may require government-issued ID of account owner).
7. Link the verified website domain.

---

## 2. Website Requirements

### Domain Strategy

Use a subdomain of the existing LLC domain: **`apps.routeworks.app`**. This
subdomain is pointed via CNAME to a separate Vercel project, keeping the app
pages completely independent from the main business website on Firebase.

The parent domain `routeworks.app` is verified in Google Search Console. The
subdomain inherits trust from the parent domain for Play Console verification.

**Important**: Do NOT use a free hosting subdomain (e.g., `something.vercel.app`,
`something.netlify.app`). Google Play org verification requires a domain you own
and can verify via DNS.

### Website Project

The website source lives in a separate repo: `routeworks-apps`
(`C:\Users\justi\Code\routeworks-apps`). It is a Next.js static site deployed
to Vercel at `apps.routeworks.app`.

### URL Structure

```
apps.routeworks.app/                         ← home (all apps listing)
apps.routeworks.app/math-dragons/            ← landing page
apps.routeworks.app/math-dragons/privacy     ← privacy policy (REQUIRED)
apps.routeworks.app/math-dragons/support     ← support / contact page

apps.routeworks.app/[future-app]/            ← repeat for each new app
apps.routeworks.app/[future-app]/privacy
apps.routeworks.app/[future-app]/support
```

### General Rules for All Pages

- Must be publicly accessible (no login wall, no geo-fencing).
- Must use HTTPS.
- Must not be a PDF — must be a live web page.
- Must not be editable by end users (no wiki-style pages).
- LLC name must appear somewhere (footer is fine).

---

## 3. Landing Page Spec

**URL**: `https://apps.routeworks.app/math-dragons/`

This is linked from the Play Store listing as the app's website.

### Required Content

| Element | Details |
|---|---|
| **App name** | "Math Dragons" |
| **App icon / logo** | The app icon used in the Play Store listing. |
| **Short description** | What the app is and who it's for. E.g., "A fun math facts game for kids ages 5-12 that turns arithmetic practice into a dragon-raising adventure." |
| **Screenshots** | 2-4 representative screenshots (reuse the ones created for the Play Store listing). |
| **Key features** | 3-5 bullet points covering core gameplay and learning value. |
| **Download link** | Google Play badge/link (add once published). Use official [Google Play badge assets](https://play.google.com/intl/en_us/badges/). |
| **Privacy & Support links** | Links to `/apps/math-dragons/privacy` and `/apps/math-dragons/support`. |
| **LLC attribution** | LLC name in footer or bottom of page. |

### Optional but Recommended

- Target age range.
- "No data collection" trust badge (if applicable).
- Link to any social media presence.

---

## 4. Privacy Policy Spec

**URL**: `https://apps.routeworks.app/math-dragons/privacy`

This is the most scrutinized page. Google Play requires it at the account level,
per-app in the Play Console listing, AND linked from within the app itself.

### Formatting Rules

- Page title must explicitly say **"Privacy Policy"**.
- The LLC name OR the app name ("Math Dragons") must appear in the policy.
- Must have an **effective date** (and update it when the policy changes).
- Must be written in clear, understandable language.

### Required Sections

#### 4.1 Introduction

- Identify the LLC as the developer/operator of Math Dragons.
- State the policy applies to the Math Dragons mobile application.

#### 4.2 Data Collection

Describe what data is collected. For Math Dragons as currently built:

- **Local data only**: Player profile (dragon name), game statistics, fact
  records, and settings are stored on-device using Hive local storage.
- **No server-side data collection**: The app does not transmit any data to
  external servers.
- **No account creation**: There are no user accounts, logins, or sign-ups.
- **No analytics SDKs**: The app does not include any analytics or crash
  reporting SDKs that send data externally.
- **No unapproved SDKs**: The app contains no third-party SDKs that transmit data.

If any of the above changes in the future (e.g., adding Firebase Analytics or
crash reporting), update this section immediately.

#### 4.3 Data Usage

- All data is used solely to provide the in-app game experience (tracking
  progress, personalizing the dragon, recording math fact mastery).
- Data never leaves the device.

#### 4.4 Third-Party Sharing

- State clearly: **no data is shared with any third parties**.
- No third-party SDKs that collect or transmit user data are included.

#### 4.5 Children's Privacy (COPPA / GDPR-K)

This section is **critical** because Math Dragons targets children.

- State that the app is designed for children and complies with the U.S.
  Children's Online Privacy Protection Act (COPPA) and applicable provisions of
  the EU General Data Protection Regulation (GDPR) regarding children's data.
- State that the app does **not knowingly collect personal information** from
  children under 13 (COPPA) or under the applicable age in the user's
  jurisdiction (GDPR).
- State that if a parent or guardian becomes aware that their child has provided
  personal information, they should contact you (provide email) and you will
  delete it.

#### 4.6 Data Retention and Deletion

- All data is stored locally on the user's device.
- Uninstalling the app removes all stored data.
- Users can clear app data at any time via device settings.
- No server-side data exists to retain or delete.

#### 4.7 Data Security

- Data is stored in the app's private storage directory, accessible only to the
  app itself (standard Android sandboxing).

#### 4.8 Changes to This Policy

- State that the policy may be updated and that the effective date at the top
  will reflect changes.
- Recommend users review periodically.

#### 4.9 Contact Information

- Provide an email address for privacy inquiries.
- Privacy email: `privacy@routeworks.app`
- Support email: `support@routeworks.app`

---

## 5. Support Page Spec

**URL**: `https://apps.routeworks.app/math-dragons/support`

Google Play has a "Support URL" field in the store listing.

### Required Content

| Element | Details |
|---|---|
| **Support email** | A monitored email address for user inquiries. |
| **App name and version** | Current version of Math Dragons. |
| **Supported platforms** | Android version requirements (minimum SDK level). |

### Recommended Content

- **FAQ section** with 3-5 common questions:
  - "How do I reset my progress?"
  - "What age is this app designed for?"
  - "Does the app require an internet connection?"
  - "How do I contact you about a problem?"
- **Known issues** (if any).
- **Response time expectation** (e.g., "We aim to respond within 48 hours").

---

## 6. Play Console Listing Fields

When creating the store listing in Play Console, these URLs map to the website:

| Play Console Field | URL to Enter |
|---|---|
| **Developer website** | `https://apps.routeworks.app` |
| **Privacy policy URL** | `https://apps.routeworks.app/math-dragons/privacy` |
| **Support URL** | `https://apps.routeworks.app/math-dragons/support` |
| **Support email** | `support@routeworks.app` |
| **Support phone** | (Optional) A phone number |

### Other Required Listing Assets

These are uploaded to Play Console directly (not on the website):

| Asset | Spec |
|---|---|
| **App icon** | 512x512 PNG, 32-bit, no transparency |
| **Feature graphic** | 1024x500 PNG or JPG |
| **Screenshots** | Min 2, max 8 per device type. Min 320px, max 3840px, 16:9 or 9:16 aspect. |
| **Short description** | Max 80 characters |
| **Full description** | Max 4000 characters |
| **App category** | Education (primary), likely "Educational Games" subcategory |
| **Content rating** | Complete the IARC questionnaire in Play Console |
| **Target audience** | Declare age groups (required for Families Policy) |

---

## 7. Families Policy Compliance

Since Math Dragons targets children, it falls under
[Google Play's Families Policy](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en).

### Target Audience Declaration

Declare as **children only** (ages 5-12). This is the strictest tier but gives the
best discoverability for parents and aligns with the kids-focused brand.

On Apple, list in the **Kids Category** — eligible because of full kids-only compliance.

### Monetization Model

**Freemium + one-time unlock.**

- Free tier: 2 games (Dragon Runes + Fire Trail), first 2 worlds each, 2 dragon
  evolution stages, basic cosmetics
- Premium unlock: $4.99 one-time purchase — all 4 games, all worlds, all evolution
  stages, all cosmetics, 500 bonus scales
- Scale packs: $0.99 / $2.99 consumables (optional, never required)
- Parental gate (hard multiplication problem) before all purchases

### SDK Restrictions (Children-Only Apps)

Apps targeting **only children** must not include any SDKs that are not approved
for use in child-directed services.

| Rule | Status for Math Dragons |
|---|---|
| No unapproved SDKs | OK — no analytics or tracking SDKs |
| No precise location data collection | OK — no location access |
| No device identifier transmission | OK — no data transmitted |
| Parental gate on purchases | OK — multiplication problem gate |

### If Adding SDKs in the Future

- **Analytics/Crash Reporting:** Must not collect personal information from children
  or transmit device identifiers. Firebase Analytics can be configured for
  child-directed treatment, but verify the specific SDK version is compliant.
  Always update the privacy policy to reflect any new data collection.

### Content Requirements

- App content must be appropriate for children.
- No violence, sexual content, or mature themes.
- No links or redirects to content inappropriate for children.
- No calls to action encouraging children to leave the app.
- No external links of any kind within the app (required for Apple Kids Category).

---

## 8. Data Safety Form

All apps must complete a Data Safety Form in Play Console, regardless of whether
they collect data. This information is displayed on the Play Store listing.

### For Math Dragons (Current State)

Since Math Dragons stores everything locally and has no network calls:

| Data Safety Question | Answer |
|---|---|
| Does your app collect or share any user data? | **No** |
| Does your app use any third-party libraries or SDKs that collect data? | **No** |
| Is all user data encrypted in transit? | **N/A** (no data transmitted) |
| Can users request data deletion? | **Yes** — uninstall removes all data; can also clear via device settings |
| Does your app follow Google Play's Families Policy? | **Yes** |

### If the App Changes

If you add any of the following, the Data Safety Form must be updated:

- Analytics (Firebase, etc.)
- Crash reporting
- Cloud save / accounts
- Any network calls at all

---

## 9. Multi-App Strategy

The website and developer account are designed to support multiple apps.

### Adding a New App

For each new app:

1. Create pages in the `routeworks-apps` repo:
   ```
   app/[new-app-name]/page.tsx
   app/[new-app-name]/privacy/page.tsx
   app/[new-app-name]/support/page.tsx
   ```
   These deploy to:
   ```
   apps.routeworks.app/[new-app-name]/
   apps.routeworks.app/[new-app-name]/privacy
   apps.routeworks.app/[new-app-name]/support
   ```
2. Write an app-specific privacy policy (data collection may differ per app).
3. Create an app-specific support page.
4. Complete a separate Data Safety Form in Play Console.
5. Complete a separate content rating questionnaire.
6. If the app targets children, ensure Families Policy compliance independently.

### Shared Across Apps

- Same developer account and LLC.
- Same verified domain.
- Same developer contact info on Play Store.
- Can share a privacy policy template, but each app needs its own policy
  reflecting its actual data practices.

---

## 10. Pre-Submission Checklist

### Account Setup
- [ ] D-U-N-S number obtained and LLC info matches
- [ ] Google Play Developer account registered as Organization
- [ ] $25 registration fee paid
- [ ] Identity verification completed
- [ ] Domain verified in Google Search Console
- [ ] Website linked in Play Console

### Website Pages
- [ ] Landing page live at `https://apps.routeworks.app/math-dragons/`
- [ ] Privacy policy live at `https://apps.routeworks.app/math-dragons/privacy`
- [ ] Support page live at `https://apps.routeworks.app/math-dragons/support`
- [ ] All pages accessible via HTTPS
- [ ] All pages publicly accessible (no auth, no geo-fence)
- [ ] LLC name appears on all pages (footer)
- [ ] Privacy policy names the LLC or "Math Dragons"
- [ ] Privacy policy has an effective date
- [ ] Privacy policy covers children's data (COPPA section)
- [ ] Support page has a working contact email

### Play Console Listing
- [ ] App icon uploaded (512x512)
- [ ] Feature graphic uploaded (1024x500)
- [ ] At least 2 screenshots uploaded
- [ ] Short description filled (max 80 chars)
- [ ] Full description filled (max 4000 chars)
- [ ] App category set to Education
- [ ] Privacy policy URL entered
- [ ] Support URL entered
- [ ] Support email entered

### Compliance
- [ ] Content rating questionnaire completed (IARC)
- [ ] Target audience / age group declared
- [ ] Families Policy requirements reviewed and met
- [ ] Data Safety Form completed
- [ ] No unapproved SDKs included in the build
- [ ] No unapproved SDKs (confirmed clean dependency tree)
- [ ] No analytics or crash reporting SDKs (or only child-safe approved ones)
- [ ] Privacy policy linked from within the app itself

### Build
- [ ] Release APK/AAB signed with upload key
- [ ] App tested on target Android versions
- [ ] No internet permission requested (unless needed)
- [ ] `minSdkVersion` set appropriately

---

## References

- [Choose a developer account type](https://support.google.com/googleplay/android-developer/answer/13634885?hl=en)
- [Required information to create a Play Console developer account](https://support.google.com/googleplay/android-developer/answer/13628312?hl=en)
- [Verify your developer identity information](https://support.google.com/googleplay/android-developer/answer/10841920?hl=en)
- [Google Play Families Policies](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en)
- [Data practices in Families apps](https://support.google.com/googleplay/android-developer/answer/11043825?hl=en)
- [User Data Policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en)
- [Google Play Store Privacy Policy Requirements (Termly)](https://termly.io/resources/articles/google-play-store-privacy-policy-updates/)
- [Prepare your app for review](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en)
- [Google Play badge assets](https://play.google.com/intl/en_us/badges/)
