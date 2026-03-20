# Apple App Store Publishing Guide

Reference document for setting up and publishing Math Dragons on the Apple App
Store, including App Store Connect configuration, Kids Category compliance,
and ASO (App Store Optimization) strategy.

---

## Table of Contents

1. [Developer Account Setup](#1-developer-account-setup)
2. [Bundle ID & App Registration](#2-bundle-id--app-registration)
3. [App Store Connect Listing Fields](#3-app-store-connect-listing-fields)
4. [ASO Strategy](#4-aso-strategy)
5. [Screenshot Requirements](#5-screenshot-requirements)
6. [Kids Category Compliance](#6-kids-category-compliance)
7. [App Privacy](#7-app-privacy)
8. [In-App Purchases](#8-in-app-purchases)
9. [Build & Upload](#9-build--upload)
10. [App Review Process](#10-app-review-process)
11. [Pre-Submission Checklist](#11-pre-submission-checklist)

---

## 1. Developer Account Setup

### Account Type

Registered as an **Organization** using the existing LLC, consistent with the
Google Play developer account.

### Requirements

| Requirement | Details |
|---|---|
| **Apple Developer Program** | $99/year enrollment fee |
| **D-U-N-S Number** | Required for organization enrollment (same D-U-N-S used for Google Play) |
| **Legal Entity** | LLC name must match D-U-N-S records exactly |
| **Apple ID** | Dedicated Apple ID for the organization recommended |

---

## 2. Bundle ID & App Registration

### Bundle ID

Registered in **Certificates, Identifiers & Profiles**:

| Field | Value |
|---|---|
| **Bundle ID** | `com.mathdragonsgame.mathDragons` |
| **Description** | Math Dragons |
| **Capabilities** | Defaults (no special capabilities needed) |

No special capabilities are required. In-App Purchase capability is enabled by
default for all App IDs. Push Notifications, Sign in with Apple, iCloud, etc.
are not used.

### App Store Connect — New App

| Field | Value |
|---|---|
| **Platform** | iOS |
| **Name** | Math Dragons |
| **Primary Language** | English (U.S.) |
| **Bundle ID** | `com.mathdragonsgame.mathDragons` (select from dropdown) |
| **SKU** | `math-dragons` |
| **User Access** | Full Access |

---

## 3. App Store Connect Listing Fields

### Metadata Fields

| Field | Value |
|---|---|
| **Subtitle** | 4 Fun Math Games for Kids |
| **Category** | Education (primary), Games (secondary) |
| **Age Rating** | Complete the questionnaire (should result in 4+) |
| **Privacy Policy URL** | `https://apps.routeworks.app/math-dragons/privacy` |
| **Support URL** | `https://apps.routeworks.app/math-dragons/support` |
| **Marketing URL** | `https://apps.routeworks.app/math-dragons/` |
| **Copyright** | (LLC name and year) |

### Promotional Text (170 chars max)

Can be updated at any time without submitting a new build. Not indexed for
search — used purely for conversion.

```
Raise a dragon while mastering math facts! 4 unique games with adaptive difficulty that grows with your child. Safe, offline, and ad-free.
```

### Description (4000 chars max)

Not indexed for search on iOS (unlike Google Play). Optimized for conversion —
clear, scannable, parent-focused.

```
Math Dragons turns math practice into an adventure your kids will actually ask to play.

Your child raises a dragon companion that evolves as they master math facts across four genuinely fun games — not boring drills disguised as games, but real games that happen to build real math skills.

FOUR UNIQUE GAMES

Dragon Runes — Chain numbers and operators to build equations in this relaxing puzzle game. Perfect for building equation-solving confidence.

Fire Trail — Guide your dragon through a grid, eating the right answers under time pressure. Fast-paced mental math that feels like an arcade game.

Dragon Eggs — Tap falling eggs with real physics to assemble equations. A satisfying, tactile experience that makes equation building feel like play.

Dragon's Feast — Navigate a grid eating numbers that match categories like "multiples of 7" or "prime numbers" while dodging guardians. Pac-Man meets Number Munchers.

SMART DIFFICULTY THAT ADAPTS

Math Dragons tracks which facts your child knows and which need more practice, then automatically adjusts what problems appear. Struggling with 7 x 8? It'll show up more often — but never so much that it feels like a drill. The difficulty grows with your child, from basic addition through division.

RAISE YOUR DRAGON

Watch your dragon evolve through 6 stages — from egg to elder dragon. Earn scales by playing any game, then customize with colors and accessories. The dragon is the reward that ties everything together.

BUILT FOR KIDS, DESIGNED FOR PARENTS

- No ads — ever
- No internet required — works completely offline
- No data collection — everything stays on your child's device
- No accounts or sign-ups
- Parental gate protects all purchases
- Designed for ages 5-12
- Covers addition, subtraction, multiplication, and division

WHAT'S INCLUDED

Free: Dragon Runes and Fire Trail (first 2 worlds each)
Premium Unlock ($4.99, one-time): All 4 games, all worlds, full dragon evolution, all cosmetics, and 500 bonus scales.

No subscriptions. No hidden costs. Just math and dragons.
```

### Keywords (100 chars max)

Comma-separated, no spaces after commas. Do NOT repeat words already in the
app name ("Math", "Dragons") or subtitle ("Fun", "Games", "Kids"). Do not
repeat the category ("Education"). Apple's algorithm composes combinations
automatically.

```
multiplication,addition,subtraction,division,learning,arithmetic,practice,facts,grade,homework,table
```

**Keyword strategy:**

| Keyword | Rationale |
|---|---|
| `multiplication` | High-volume parent search; combines with `table` and `practice` |
| `addition` | Core operation; combines with `facts`, `practice` |
| `subtraction` | Core operation; combines with `facts`, `practice` |
| `division` | Core operation; combines with `facts`, `practice` |
| `learning` | High-volume; combines with `math` (from title) |
| `arithmetic` | Alternate term parents use; combines with `practice` |
| `practice` | Intent keyword; combines with all operations |
| `facts` | Matches "math facts" (Apple combines with title) |
| `grade` | Matches "3rd grade math", "4th grade" etc. |
| `homework` | Intent keyword; parents searching for homework help |
| `table` | Combines with `multiplication` for "multiplication table" |

**Auto-composed search terms** (via Apple's algorithm combining title + subtitle + keywords):

- "math games for kids", "fun math games" (title + subtitle)
- "multiplication practice", "addition facts", "division practice"
- "multiplication table", "math homework", "math learning"
- "arithmetic games", "math facts for kids"

---

## 4. ASO Strategy

### How iOS Search Indexing Works

On iOS, only these fields are indexed for search:

| Field | Indexed? | Char Limit |
|---|---|---|
| **App Name** | Yes | 30 chars |
| **Subtitle** | Yes | 30 chars |
| **Keywords** | Yes | 100 chars |
| **Category** | Yes (automatic) | N/A |
| **In-App Purchase names** | Yes | N/A |
| **Description** | No | 4000 chars |
| **Promotional Text** | No | 170 chars |

This means:

- **Title + Subtitle + Keywords** are your entire search vocabulary. Choose
  carefully and do not waste characters repeating words across fields.
- **Description** is for convincing parents to download, not for keyword
  stuffing. Write for humans.
- **Promotional Text** is for timely messaging (seasonal updates, new features,
  social proof). Can be updated without a new build.

### Ongoing Optimization

- Monitor impressions and conversion rate in App Analytics (App Store Connect)
- Rotate keywords every 4-6 weeks based on performance data
- Update promotional text for seasonal relevance (back to school, summer break)
- A/B test screenshots using App Store Connect's product page optimization

---

## 5. Screenshot Requirements

### Required Device Sizes

| Display Size | Device to Simulate | Screenshot Resolution |
|---|---|---|
| **6.7" (required)** | iPhone 14 Pro Max (430 x 932 viewport) | 1290 x 2796 px |
| **6.5" (required)** | iPhone 11 Pro Max (414 x 896 viewport) | 1242 x 2688 px |
| **5.5" (optional)** | iPhone 8 Plus | 1242 x 2208 px |
| **iPad Pro 12.9" (if supporting iPad)** | iPad Pro 12.9" | 2048 x 2732 px |

### How to Capture (from browser, no physical device)

1. Open the web build in Chrome/Brave DevTools
2. Enable device toolbar, select the target device
3. Use the **DevTools built-in screenshot** tool (three-dot menu in the device
   toolbar > "Capture screenshot") — this respects the device pixel ratio and
   produces the correct resolution
4. Save as PNG or JPEG

### Recommended Screenshots (3-5 minimum)

1. **Hub screen** — shows all 4 games, dragon companion
2. **Dragon Runes gameplay** — equation building in action
3. **Fire Trail gameplay** — fast-paced grid action
4. **Dragon Eggs gameplay** — physics-based falling eggs
5. **Dragon evolution / cosmetics** — shows progression and customization

### Screenshot Guidelines

- Screenshots must accurately represent the app experience
- First screenshot is the most important — it appears in search results
- Can include text overlays describing features (keep text large and readable)
- Must be appropriate for all audiences (4+ content)
- Do not include device frames unless using Apple's official templates

---

## 6. Kids Category Compliance

Math Dragons is listed in the **Kids Category**, which has strict requirements
beyond the standard App Store guidelines.

### Age Band

Declare as **Ages 6-8** and/or **9-11** based on content difficulty. If only one
age band is allowed, choose **9-11** (the content extends through division and
number properties, which suits this range, while remaining accessible to
younger players).

### Kids Category Requirements

| Requirement | Math Dragons Status |
|---|---|
| **No third-party advertising** | OK — no ads of any kind |
| **No external links** | OK — no links that leave the app |
| **No third-party analytics** | OK — no analytics SDKs |
| **No data collection** | OK — all data stored locally |
| **Parental gate for purchases** | OK — multiplication problem gate |
| **Parental gate for external links** | OK — no external links exist |
| **Age-appropriate content** | OK — educational math content only |
| **No behavioral advertising** | OK — no advertising at all |

### Apple-Specific Kids Category Rules (vs Google Play)

- Apple requires **no external links of any kind** within the app, including
  links to your website, social media, or other apps. This is stricter than
  Google Play.
- Any link that takes the user outside the app (including Safari, App Store,
  or Settings) must be behind a parental gate — but for Kids Category, the
  safest approach is **no external links at all**.
- If the app includes a privacy policy link within the app itself, it must be
  behind a parental gate or in a parent-only section.
- Login features (if added later) must be behind a parental gate.

### COPPA Compliance

Same requirements as documented in `GOOGLE_PLAY_PUBLISHING.md` section 7. The
privacy policy at `https://apps.routeworks.app/math-dragons/privacy` covers
both platforms.

---

## 7. App Privacy

### App Privacy Details (App Store Connect)

In the "App Privacy" section of the app's page, you must declare your data
practices. This is displayed on the App Store listing.

For Math Dragons (current state — no data collection, no network calls):

| Question | Answer |
|---|---|
| **Do you or your third-party partners collect data?** | No |
| **Data types collected** | None |
| **Data linked to identity** | None |
| **Data used to track users** | None |

This will display the **"Data Not Collected"** label on the App Store listing,
which is a strong trust signal for parents.

### If the App Changes

If any data collection is added in the future (analytics, crash reporting, cloud
sync, accounts), the App Privacy details must be updated to reflect the actual
data practices. This requires a new app submission.

---

## 8. In-App Purchases

### Products to Create in App Store Connect

| Product Type | Reference Name | Product ID | Price |
|---|---|---|---|
| **Non-Consumable** | Premium Unlock | `com.mathdragonsgame.mathDragons.premium` | $4.99 |
| **Consumable** | Scale Pouch | `com.mathdragonsgame.mathDragons.scales.small` | $0.99 |
| **Consumable** | Scale Hoard | `com.mathdragonsgame.mathDragons.scales.large` | $2.99 |

### IAP Setup Notes

- Each product needs a display name, description, and screenshot for review
- Products must be submitted for review alongside (or after) the app binary
- Apple takes a 30% commission (15% if qualifying for the Small Business Program
  — under $1M annual revenue)
- Parental gate must be shown before any purchase flow begins
- IAP implementation uses RevenueCat (per the monetization plan in Step 11)

### Small Business Program

If annual App Store revenue is under $1M (very likely for an indie kids app),
enroll in Apple's **App Store Small Business Program** to reduce commission from
30% to 15%. Apply at [Apple's Small Business Program page](https://developer.apple.com/app-store/small-business-program/).

---

## 9. Build & Upload

### Requirements

Building for iOS requires:

- **macOS** with **Xcode** installed (cannot build iOS from Linux)
- A valid **iOS Distribution Certificate**
- A **Provisioning Profile** for the app's bundle ID
- **Xcode** or **Transporter** app to upload the build

### Build Steps (Flutter)

```bash
# Clean and build the iOS release archive
flutter clean
flutter build ipa --release

# The .ipa file will be at:
# build/ios/ipa/math_dragons.ipa
```

### Upload Options

1. **Xcode** — Open the `.xcarchive`, use Organizer > Distribute App
2. **Transporter** — Free Mac app from the App Store; drag and drop the `.ipa`
3. **CLI** — `xcrun altool --upload-app -f build/ios/ipa/math_dragons.ipa`

### Signing

- Use **automatic signing** in Xcode for simplicity
- Or manually configure a Distribution Certificate + App Store Provisioning
  Profile in the Flutter Xcode project at `math_dragons/ios/Runner.xcodeproj`

---

## 10. App Review Process

### Key Differences from Google Play

| Aspect | Google Play | Apple App Store |
|---|---|---|
| **Review type** | Automated + manual | Always manual (human reviewer) |
| **Review time** | Usually hours | Usually 24-48 hours (can be longer) |
| **First submission** | May take longer | Often takes longer; expect extra scrutiny |
| **Kids apps** | Families Policy review | Kids Category review (stricter) |
| **Rejection** | Can resubmit immediately | Can resubmit or appeal via Resolution Center |

### Common Rejection Reasons for Kids Apps

- External links without parental gates (or at all in Kids Category)
- Privacy policy not accessible or not covering children's data
- In-app purchases not gated behind parental controls
- Metadata referencing features not yet in the app
- Screenshots not matching actual app experience
- App crashes or significant bugs during review

### Tips for First Submission

- Test thoroughly on a real iOS device (or simulator) before submitting
- Ensure the parental gate is clearly functional
- Include clear review notes explaining the parental gate mechanism
- Provide a demo account or instructions if any features are gated
- Make sure the privacy policy URL is live and accessible

### App Review Notes Field

When submitting, include notes for the reviewer:

```
Math Dragons is a kids' educational math game designed for ages 5-12.

Parental Gate: All in-app purchases are protected by a parental gate that
requires solving a hard multiplication problem (e.g., 17 x 14). This prevents
children from making unauthorized purchases.

The app works entirely offline with no data collection. All game progress is
stored locally on the device.

Free version includes: Dragon Runes and Fire Trail (first 2 worlds each).
Premium Unlock ($4.99) provides access to all 4 games and all worlds.
```

---

## 11. Pre-Submission Checklist

### Account Setup
- [ ] Apple Developer Program enrolled ($99/year)
- [ ] Organization account verified with D-U-N-S
- [ ] Bundle ID registered (`com.mathdragonsgame.mathDragons`)
- [ ] App created in App Store Connect

### Store Listing
- [ ] App name: "Math Dragons"
- [ ] Subtitle: "4 Fun Math Games for Kids"
- [ ] Promotional text entered (170 chars)
- [ ] Description entered (4000 chars)
- [ ] Keywords entered (100 chars)
- [ ] Category set: Education (primary), Games (secondary)
- [ ] Privacy policy URL entered
- [ ] Support URL entered
- [ ] Marketing URL entered
- [ ] Copyright field filled

### Screenshots & Assets
- [ ] App icon uploaded (1024x1024 PNG, no transparency, no rounded corners)
- [ ] Screenshots uploaded for 6.7" display (1290 x 2796)
- [ ] Screenshots uploaded for 6.5" display (1242 x 2688)
- [ ] At least 3 screenshots per required device size

### Kids Category
- [ ] Kids Category selected
- [ ] Age band declared (6-8 and/or 9-11)
- [ ] No external links in the app
- [ ] No third-party analytics or advertising SDKs
- [ ] Parental gate implemented and functional
- [ ] Content appropriate for declared age band

### App Privacy
- [ ] App Privacy details completed in App Store Connect
- [ ] "Data Not Collected" declared (if still accurate)

### In-App Purchases
- [ ] Premium Unlock product created and submitted for review
- [ ] Scale Pouch product created and submitted for review
- [ ] Scale Hoard product created and submitted for review
- [ ] All IAP display names and descriptions filled in
- [ ] IAP screenshots provided for review

### Build
- [ ] iOS build compiled and signed on macOS
- [ ] Build uploaded via Xcode, Transporter, or CLI
- [ ] Build selected in App Store Connect version
- [ ] Tested on real device or simulator
- [ ] No crashes during core gameplay flows
- [ ] Parental gate tested and working

### Compliance
- [ ] Age rating questionnaire completed
- [ ] Privacy policy live and accessible at HTTPS URL
- [ ] Privacy policy covers children's data (COPPA)
- [ ] Privacy policy linked from within the app (behind parental gate)
- [ ] No unapproved SDKs in the build
- [ ] Small Business Program applied for (if eligible)

### Review Submission
- [ ] App Review notes written (explain parental gate, offline nature)
- [ ] Contact info provided for reviewer questions
- [ ] Submit for review

---

## References

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Building Apps for Kids](https://developer.apple.com/app-store/kids-apps/)
- [Creating Your Product Page](https://developer.apple.com/app-store/product-page/)
- [App Store Search](https://developer.apple.com/app-store/search/)
- [App Store Small Business Program](https://developer.apple.com/app-store/small-business-program/)
- [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/)
- [Categories and Discoverability](https://developer.apple.com/app-store/categories/)
