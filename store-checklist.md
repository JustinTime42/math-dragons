Final Report
What I Did (completed)
| Item | Details |
|------|---------|
| Android launcher icons | Generated custom icons from app_icon.png for all 5 density buckets + adaptive icon (Android 8.0+) using flutter_launcher_icons |
| Android app label | Changed "math_dragons" → "Math Dragons" in AndroidManifest.xml |
| Signing config cleanup | Removed stale TODO comments from build.gradle.kts; release config already correctly reads from key.properties |
| Store listing content | Created docs/store-listing.md with short description, full description, keywords, category recommendations, age rating guidance, content rating questionnaire answers, and v1.0.0 "What's New" text |
| .gitignore hardened | Added ios/Runner/GoogleService-Info.plist and lib/firebase_options.dart to prevent leaking API keys |
| Checklist updated | Updated store-checklist.md with accurate current status for every item |
| Verification | flutter analyze — 0 issues. flutter test — 585/585 passing |

What Was Already Done (discovered during analysis)
The checklist was outdated — many "critical blockers" were already resolved:
Firebase project exists (math-dragons-game) with google-services.json and firebase_options.dart in place
key.properties already exists with signing config
build.gradle.kts already pointed to release signing config (not debug)
Privacy policy already exists at docs/privacy-policy.html (COPPA compliant)
Bundle IDs already match (com.mathdragonsgame.mathDragons on both platforms)
Feature graphic already exists at assets/images/raw/feature_graphic.png

What YOU Still Need To Do (requires human/account access)
Firebase & Auth (requires Firebase Console access):
Download GoogleService-Info.plist for iOS from Firebase Console
Register SHA-1/SHA-256 fingerprints in Firebase Console
Set up Google Sign-In OAuth client IDs for both platforms

Android (requires local keytool + Google account):
Generate the actual upload-keystore.jks with secure passwords
Update key.properties passwords to match
Create/access Google Play Developer account ($25)
Set up internal testing track in Play Console

iOS (requires Mac + Apple account):
Enroll in Apple Developer Program ($99/year)
Configure signing in Xcode (team, provisioning profile)
Run pod install in ios/ directory
Test on physical iOS device
Set up App Store Connect + TestFlight

Hosting & Screenshots:
Host privacy policy at a public URL (simplest: add to your GitHub Pages site at AncBuckley.github.io)
Take screenshots on actual devices for store listings

Physical Device Testing:
Test full flow on Android device with release build
Test full flow on iOS device with release build
Verify Firebase auth + cloud sync end-to-end

Not a Blocker (optional)
Sound assets are empty — game will be silent but functional. Can add audio later.
