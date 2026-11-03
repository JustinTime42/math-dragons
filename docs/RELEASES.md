# Releases

One line per build that testers can install. Marketing claims about the app are checked against the newest **installable** build listed here, not against `main` (`marketing/guides/fact-check-protocol.md` §2).

| Version (build) | Commit | Date | Platforms | Notes |
|---|---|---|---|---|
| 1.0.3 (8) | `28d6638` | 2026-10-24 | iOS TestFlight (external, public link), Android closed testing | Settings > For Parents links (privacy, feedback, support) behind parental gate; founding-tester flag; no Android INTERNET permission. iOS export-compliance answered manually; `ITSAppUsesNonExemptEncryption` added after this build (`4253700`) |
| 1.0.4 (9) | `b80c7bb` | 2026-11-03 | iOS TestFlight (external, public link), Android closed testing | Adaptive practice Phase 1: Fire Trail uses the difficulty engine; first-answer-only fact tracking; clean fact keys in all games; Dragon Eggs rejects uneven division (7 ÷ 2 = 3 now wrong). Includes `ITSAppUsesNonExemptEncryption = false` |
