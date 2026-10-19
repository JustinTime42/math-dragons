# AI-Assisted Short-Form Video Production Pipeline (state as of 2026-10-19)

Scope: tooling and workflow for a faceless 9:16 channel about kids' math learning, aimed at parents, promoting the Flutter game Math Dragons (2D fantasy dragon art, existing style bible). Creator is a solo dev already using OpenAI image gen and ElevenLabs. Every price below is dated by the source's own date or the date I read it (2026-10-19). Most pricing sources are third-party aggregators that disagree with each other; that is flagged inline. Platform AI-labeling and monetization policy is out of scope (covered by another researcher).

Research note: roughly 18 searches/fetches. Primary sources fetched directly: ElevenLabs API pricing page, OpenAI deprecations page (via search), Google Developers Blog on Veo 3.1, Remotion license page (via search). Everything else is secondary and should be re-checked before committing money.

## 1. AI voiceover: which TTS to use

### Takeaway
ElevenLabs remains the practical default for this creator (already integrated, v3 has the best expressive control, commercial license from the $6 Starter tier, official API price $0.08 per 1K chars for v3 as read 2026-10-19). OpenAI gpt-4o-mini-tts is roughly 5x cheaper (~$0.015/min) with prompt-steerable delivery ("warm, patient teacher") and is a good fallback/A-B candidate. Independent arena leaderboards have churned all year (Inworld, Gemini Flash TTS, Speechify Simba, Qwen at #1 at various points), so arena rank should not drive the choice; parent-audience fit and pipeline integration should.

### Cited Findings
- ElevenLabs official API pricing (page undated, read 2026-10-19): v3 $0.08 per 1K characters (~$0.08/min), 5,000-char limit per request, 70+ languages; Multilingual v2 $0.08/1K (10,000-char limit); Flash/Turbo $0.04/1K (40,000-char limit). Plans: Starter $6/mo, Creator $22/mo, Pro $99/mo, Scale $299/mo, Business $990/mo ([ElevenLabs API pricing](https://elevenlabs.io/pricing/api)).
- Conflict: an aggregator lists Eleven v3 at $0.10/1K characters and GA since 2026-02-02 ([LLM Reference](https://www.llmreference.com/provider/elevenlabs/eleven-v3)); a pricing-change tracker (2026-09-28) reports a lower-latency "v3 Conversational" at $0.05/1K ([usagepricing.com](https://www.usagepricing.com/blueprint/activity/elevenlabs-2026-09-28-v3-conversational-dubbing-v2)). The official page ($0.08) should be treated as authoritative. The official page also references "v4" in its included-character table, which suggests a newer model may be live or imminent; I could not confirm details.
- ElevenLabs v3 supports dramatic delivery, emotional nuance, multi-speaker dialogue ([LLM Reference](https://www.llmreference.com/provider/elevenlabs/eleven-v3)).
- Free tier has no commercial license; Starter (~$6/mo) unlocks commercial licensing ([fast.io review](https://www.fast.io/resources/elevenlabs-ai-review-2026.md)). I found no explicit statement on commercial rights for Voice Design-created voices.
- Voice Design v3 via a marketplace is billed ~$0.20 per execution (reseller, not official) ([eachlabs](https://www.eachlabs.ai/elevenlabs/elevenlabs/elevenlabs-voice-design-v3)).
- ElevenLabs pricing article discussing voice cloning and the NO FAKES Act context, dated 2026-05-31 ([Fora Soft](https://www.forasoft.com/learn/ai-for-video-engineering/articles-ai/elevenlabs-pricing-voice-cloning-no-fakes-act)). Cloning your own voice is the low-risk case.
- OpenAI gpt-4o-mini-tts: ~$0.60 per 1M text tokens + $12 per 1M audio tokens, ~$0.015 per minute of audio (July 2026 summary); steerable by instruction prompts (e.g. "warm, patient teacher"); voice cloning limited ([techsy.io](https://techsy.io/it/blog/migliori-api-sintesi-vocale-sviluppatori)).
- Cartesia Sonic 3: pricing sources disagree. $0.030/min (LiveKit Build/Ship) or $0.0225/min (LiveKit Scale) via LiveKit ([LiveKit pricing](https://www.livekit.com/pricing)); credit-based direct pricing at 15 credits/sec, Startup $49, Scale $299 ([Speechify, July 2026](https://speechify.ai/alternatives/cartesia)); ~$39 per 1M characters estimate ([techsy.io](https://techsy.io/it/blog/migliori-api-sintesi-vocale-sviluppatori)). Cartesia is optimized for low latency (40 to 90 ms TTFA), which matters for voice agents, not for pre-rendered video.
- Artificial Analysis Speech Arena leadership has changed repeatedly in 2026: Inworld TTS 1.5 Max top at Elo 1217 (April 2026 snapshot) ([Magic Hour](https://magichour.ai/model-leaderboard/text-to-speech)); Gemini 3.1 Flash TTS, Sonic 3.5 etc. in the top five (late May 2026) ([offlinetts.com](https://offlinetts.com/blog/tts-arena-leaderboard-2026/)); Speechify claims Simba 3.2 #1 in July 2026, statistically tied with Alibaba Qwen-Audio-3.0-TTS-Plus (vendor press release, treat cautiously) ([Speechify](https://speechify.ai/blog/best-tts-providers-2026-comparison); [press release](https://smb.oxfordeagle.com/article/Speechifys-Simba-32-Ranks-1-on-Independent-Artificial-Analysis-TTS-Leaderboard-Worlds-Best-Real-Time-Voice-Model-Above-ElevenLabs-OpenAI-Google-DeepMind-andamp-Others/6a4d33c21f33de42266d6b48)). Live board: [Artificial Analysis](https://artificialanalysis.ai/text-to-speech/leaderboard). Fish Audio S2 Pro listed as top open-weights model (undated snapshot) (same link).

### Inferences
- Cost is a non-issue at this volume: a 45-second Short is ~600 to 800 characters, so v3 is about $0.05 to $0.07 per take; even 5 retakes per video is under $0.50.
- Recommended approach: ElevenLabs Professional Voice Clone of Justin's own voice (authentic "dad/dev who built this" persona, no likeness risk) or a Voice Design voice; use v3 audio tags for emotion; keep gpt-4o-mini-tts as a cheap fallback. For a parent audience, a calm, warm, conversational adult voice (not hype-narrator, not a cartoon kid voice) fits the existing "talk to adults, not kids" content rule in the project memory. This is inference, not sourced audience data.
- Get word-level timestamps from the TTS (ElevenLabs offers with-timestamps endpoints) or run Whisper on the output to drive captions and cut points programmatically.

### Gaps
- No credible, sourced data on which voice styles perform best specifically with parent audiences.
- Which ElevenLabs plans include Professional Voice Cloning was not stated on the pricing page; check the plan comparison page.
- Google Cloud TTS / Gemini TTS pricing not verified.

## 2. AI video generation models

### Takeaway
Sora 2 is gone from the API (shutdown 2026-09-24), so do not build on it. For animating existing 2D dragon art, the realistic shortlist is Kling 3.0 / Kling O3 (element referencing for character lock, up to 15 s clips, ~$0.08 to $0.11/s official), Veo 3.1 (up to 3 reference images, native audio, $0.05/s Lite to $0.40/s standard, SynthID invisible watermark), and Runway Gen-4 Turbo / Gen-4.5 ($0.05 to $0.12/s). Use these for short, text-free "hero" motion shots of the mascot only; never for anything showing numbers, equations, or UI.

### Cited Findings
- Sora: OpenAI's deprecations page (notice 2026-03-24) lists the Videos API, sora-2, sora-2-pro and snapshots with shutdown 2026-09-24 and no recommended replacement ([OpenAI deprecations](https://developers.openai.com/api/docs/deprecations); [techjacksolutions](https://techjacksolutions.com/ai-brief/openai-videos-api-sora-2-deprecated-september-2026/)). Sora consumer apps closed 2026-04-26 ([videocreate.org](https://videocreate.org/guides/sora-shutdown)). After 2026-09-24 there is no legitimate way to buy Sora generations ([InVideo, Aug 2026](https://invideo.io/blog/ai-video-model-pricing/)).
- Official per-second rates as of August 2026 ([InVideo pricing roundup, 2026-08-06](https://invideo.io/blog/ai-video-model-pricing/)):
  - Veo 3.1: $0.40/s (720p/1080p), $0.60/s 4K, max 8 s, audio always on.
  - Veo 3.1 Fast: $0.10/s 720p, $0.12/s 1080p, $0.30/s 4K.
  - Veo 3.1 Lite: $0.05/s 720p, $0.08/s 1080p.
  - Kling 3.0 Turbo: ~$0.11/s (720p only via API; 1080p uses plan credits), native audio since Kling 2.6.
  - MiniMax-H3 (Hailuo successor, launched 2026-07-31): $0.13/s, 2K, native stereo, failed generations not billed.
  - HappyHorse: ~$0.125/s 720p, ~$0.22/s 1080p, 15 s max.
  - LTX-2.3: $0.06 to $0.32/s depending on tier/resolution.
  - Grok Imagine Video 1.0/1.5: $0.05/s / $0.08/s.
  - P-Video (Pruna): $0.02/s 720p, $0.04/s 1080p.
  - Seedance: token-billed on Volcano Engine, roughly ~$0.14/s at 1080p (approximation).
  - PixVerse V6: credit-billed, no official dollar rate.
  - Resellers typically quote 2 to 3x official rates.
- A later aggregator says Gemini API rates read 2026-10-13 match ($0.40/s Veo 3.1, Fast $0.10/s, Lite $0.05/s) and warns the earliest shutdown for the three Veo 3.1 *preview* model IDs on the Gemini API is 2026-10-22, i.e. three days from today. Conflict: one source says audio adds ~50% to Veo price, another says audio is included ([search summary of apiframe/benchlm/higgsfield](https://benchlm.ai/blog/posts/ai-video-generation-models)). Verify the GA model IDs before coding against Veo.
- Kling official developer pricing for Kling 3.0 ~$0.084/s 720p, ~$0.112/s 1080p; API credits separate from consumer subscription credits ([higgsfield](https://higgsfield.ai/blog/ai-video-api-pricing-vs-subscriptions); [fluxnote](https://fluxnote.io/blog/ai-video-generation-pricing-guide-2026)). Runway Gen-4 Turbo ~$0.05/s, Gen-4.5 ~$0.12/s, credits $0.01 each (same aggregators; not verified on Runway's page).
- Veo 3.1 supports up to 3 reference images of a character, object or scene, explicitly "helpful for maintaining character consistency across multiple shots or applying a specific style" ([Google Developers Blog](https://developers.googleblog.com/introducing-veo-3-1-and-new-creative-capabilities-in-the-gemini-api/)). Available via Gemini API and Vertex AI; also via fal.ai `fal-ai/veo3.1/reference-to-video` ([fal docs](https://fal.ai/docs/model-api-reference/video-generation-api/veo3.1-reference-to-video.md)).
- Kling 3.0: element referencing locks a character's appearance from a reference image across shots; Kling O3 (Video 3.0 Omni) is the variant for reference-heavy character work; multi-character coreference for 3+ characters; clips up to 15 s ([fal.ai Kling 3](https://fal.ai/kling-3); [Freepik/Magnific](https://www.freepik.com/kling-3-0)). Up to 4 image references for reference-to-video ([Atlas Cloud](https://www.atlascloud.ai/blog/guides/advanced-kling-3-cinematic-video-tutorial)). Voice Binding ties a voice to a character ([Vizard](https://vizard.ai/blog/vizard-now-supports-kling-3-0-the-most-cinematic-ai-video-model-yet)).
- Watermarks: Google applies SynthID invisible watermarking to all frames of Veo videos ([Google DeepMind](https://deepmind.google/discover/blog/watermarking-ai-generated-text-and-video-with-synthid)). A visible "Veo" mark appears in consumer app output (user report, cropping removed it), suggesting the visible mark is an app-level feature, not API ([Google dev forum thread](https://discuss.google.dev/t/veo-3-vertex-ai-and-other-apis/257446)). A forum post claims Veo outputs carry full commercial usage rights; this is a user's reading, not official (same link).
- Open/self-host options (Wan, etc.) are suggested as Sora migration targets ([Spheron](https://www.spheron.network/blog/sora-2-api-shutdown-2026-self-hosted-video-alternatives/)).

### Inferences
- Best fit for Math Dragons: image-to-video from existing style-bible dragon art (first frame = actual game art) with Kling O3 element reference or Veo 3.1 reference images. Keep clips 3 to 6 s, simple motion (breathing, head turn, wing flap, flying past camera). Short clips minimize drift.
- An alternative with zero AI-model risk: rig the existing 2D art with Rive or simple puppet/parallax animation in Remotion/After Effects. Since the art already exists as layered game assets, this guarantees on-model consistency. This aligns with the "Track D non-occluding cosmetics" art pipeline decision in project memory.
- Generation budget: at ~$0.10/s and 3 to 4 attempts per usable shot, a 5 s hero shot costs ~$1.50 to $2. Two hero shots per video = ~$3 to $4.
- Veo native audio should be discarded for these shots (voiceover and music are layered in edit).

### Gaps
- No source evaluated how well Kling/Veo/Runway preserve a flat 2D illustrated style (vs drifting toward 3D/realistic). Needs a hands-on bake-off with 3 to 5 dragon images.
- Official commercial-use terms for Veo (Gemini API/Vertex) and Kling API outputs not confirmed from primary terms pages.
- Luma, Pika, Seedance quality for stylized content not researched in depth; Runway pricing not verified at the source.

## 3. Programmatic animation (exact numbers, math visuals)

### Takeaway
For any shot that shows numbers, equations, or a math concept, render programmatically. Manim (MIT, Python) is the best fit for equation and number-line animation and matches Justin's Python skills; Remotion (React/TS) is the best fit as the overall composition/timeline engine for a templated, data-driven Short (captions, overlays, gameplay, b-roll), and is free for individuals and companies of up to 3 people. Motion Canvas sits between.

### Cited Findings
- Manim: MIT-licensed, the engine behind 3Blue1Brown, "gold standard" for math visualization in Python ([beginnersinai comparison](https://beginnersinai.org/remotion-vs-motion-canvas-vs-manim/)).
- Motion Canvas: MIT, TypeScript, imperative generator-based timeline, renders to a single canvas, aimed at precise explainer animation ([Remotion's own comparison page](https://www.remotion.dev/docs/compare/motion-canvas); same beginnersinai source).
- Remotion: React/TypeScript, declarative, needs a headless browser to render, suited to scalable pipelines (same sources; note Remotion's page is self-authored).
- Remotion licensing: free for individuals and companies up to 3 people; Creators $25/seat/mo; Automators $0.01/render with $100/mo minimum; Enterprise from $500/mo ([Remotion license pricing](https://www.remotion.dev/docs/license/pricing); [Spotsaas](https://www.spotsaas.com/blog/remotion-review)). License text says it will "slightly change" in Remotion 5.0, details not found ([GitHub LICENSE](https://github.com/remotion-dev/remotion/blob/main/LICENSE.md)).
- An open-source Claude agent skill exists for authoring Remotion motion graphics ([GitHub topic: faceless-video](https://github.com/topics/faceless-video)).

### Inferences
- As a solo dev, Justin qualifies for Remotion's free tier, so Remotion can be the backbone: a `ShortTemplate` composition driven by a JSON spec (script beats, VO file, word timestamps, gameplay clip in/out, Manim clip paths, dragon hero clips, music track). This avoids per-render SaaS fees.
- Manim renders transparent-background MOV/WebM clips (e.g. "7 + 5 = 12 via make-a-ten") that drop into the Remotion timeline. All on-screen numbers are then guaranteed correct and can be unit-tested against the script.
- Lottie/Rive exports of existing game UI animations can be reused directly; FFmpeg handles final loudness normalization (-14 LUFS is common for social) and encode.

### Gaps
- No 2026-specific benchmark data on render speed for Manim vs Remotion.
- After Effects scripting not researched (likely unnecessary given the code-first stack).

## 4. Assembly, editing, captions, end-to-end generators

### Takeaway
CapCut has no official API (confirmed absent as of 2026-10-15), so it can only be the manual polish step. For automated assembly, either self-host with Remotion (cheapest, most control) or use a JSON-to-video API (Shotstack ~$0.20 to $0.40/min, JSON2Video ~$0.25/min, Creatomate variable). Submagic has an API for trendy captions (Business+API ~$69/mo). End-to-end faceless generators (InVideo AI, Revid) have a low quality ceiling with generic stock visuals and are the "templated" look that reads as slop.

### Cited Findings
- No official CapCut API for editing/rendering; CapCut terms ban scripted access; GitHub "CapCutAPI" projects only write draft files opened in the app; no CapCut/ByteDance "Open Platform" found (checked 2026-10-15) ([wireflow](https://www.wireflow.ai/blog/capcut-api)).
- Shotstack ~$0.40/rendered min pay-as-you-go, ~$0.20 on plans from $39/mo, flat across resolutions up to 1080p ([wireflow Shotstack pricing](https://www.wireflow.ai/blog/shotstack-pricing); [Shotstack](https://shotstack.io/vs/creatomate-alternatives/)).
- Creatomate Essential $54/mo for 2,000 credits, effective $0.10 to $0.84/min depending on resolution/fps; rates rose during 2026; credits do not roll over ([wireflow Creatomate vs Shotstack](https://www.wireflow.ai/blog/creatomate-vs-shotstack); [motionbox, 2026-08-05](https://motionbox.io/blog/best-json2video-alternatives-in-2026)).
- JSON2Video Professional ~$49.95/mo for 200 Full HD minutes (~$0.25/min), TTS included in render credits ([apispine](https://apispine.com/json2video/pricing); [JSON2Video](https://json2video.com/how-to/creatomate-alternative/)).
- Creatomate publishes an n8n + ChatGPT faceless Shorts tutorial ([Creatomate](https://creatomate.com/blog/how-to-auto-generate-faceless-shorts-with-chatgpt-and-n8n)).
- Submagic: Business + API $69/mo (annual $41/member/mo), up to 100 videos/member/mo, 4K/60fps export, API access ([toolsforhumans](https://www.toolsforhumans.ai/ai-tools/submagic); [fluxnote](https://fluxnote.io/guides/submagic-pricing-2026)). One competitor page claims no API (conflict; likely outdated).
- InVideo AI: mixed reviews; strongest for short-form social, but captions called basic and stock footage generic (April 2026); Capterra complaints on export limits and quality ([marcandrews](https://marcandrews.com/invideo-ai-review-2026); [fluxnote](https://fluxnote.io/guides/invideo-ai-for-youtube-shorts-2026); [Capterra](https://capterra.com/p/180680/InVideo/reviews/)).
- Revid: 3.2/5 from 105 reviews, 48% one-star on Trustpilot (Dec 2025), credit/inconsistency complaints; source is a competitor blog ([virvid](https://virvid.ai/blog/best-alternatives-revid-ai-top-5-tools-compared-2026)).

### Inferences
- End-to-end generators cannot use the Math Dragons style bible, actual gameplay, or verified math visuals, so they are a poor fit regardless of price.
- Captions are easy to do in-house: Whisper/ElevenLabs word timestamps -> Remotion word-by-word highlighted captions (2 to 4 words on screen, large, high-contrast, inside the 9:16 safe zone, clear of the bottom ~20% and right-side UI). Submagic is optional if Justin wants trendy auto-styles without building them.
- Descript remains useful for a manual human edit pass on VO (filler removal, overdub) but is not needed if VO is TTS.

### Gaps
- Descript, Captions.ai, OpusClip 2026 pricing/API not researched (OpusClip is a long-to-short repurposer, less relevant here).
- Faceless.video, AutoShorts not reviewed; no independent quality reviews found.

## 5. Recording mobile gameplay

### Takeaway
Use scrcpy `--record` (streams to PC, avoids the on-device `adb screenrecord` 3-minute cap) on a physical Android device or emulator, or `xcrun simctl io booted recordVideo` on iOS simulator. A Flutter integration test that scripts taps can make gameplay capture reproducible. Sourced evidence here is thin; most of this is established practice rather than 2026-specific reporting.

### Cited Findings
- `adb screenrecord` has a 3-minute limit, originally emulator-only, later enforced on devices; an unofficial issue-tracker comment says it was to be lifted in Android 14 (unconfirmed) ([Google Issue Tracker](https://issuetracker.google.com/issues/198237873)).
- scrcpy streams to the PC and records with `scrcpy --record file.mp4`; skipped frames are still recorded even if not displayed in real time; mirroring targets 30 to 60 fps ([scrcpy README archive](https://git.blob42.xyz/Archives/scrcpy/raw/commit/dca11f6c513e3b63e5494fce5bfffdc5c29be002/README.md)).

### Inferences
- Phones are already portrait, so native capture is close to 9:16 (most modern phones are ~19.5:9, so expect a small crop or letterbox to 1080x1920).
- Prefer a physical device over the emulator for capture; project memory notes the local AVD uses NVK software rendering, which will likely drop frames.
- For reproducible "perfect run" footage, drive the game with a Flutter `integration_test` script (deterministic seed, scripted taps with human-like delays) while scrcpy records. Hide the debug banner and status bar; consider a demo mode flag that shows a clean device frame.
- Record at the device's native resolution and 60 fps, then let Remotion scale/crop. Capture SFX via game audio export rather than recording device audio, so the mix stays clean.

### Gaps
- No sourced 2026 guidance on Flutter integration-test-driven video capture or iOS simulator frame-rate limits.
- Whether the 3-minute adb cap is lifted on current Android versions is unconfirmed.

## 6. Music and SFX licensing

### Takeaway
ElevenLabs Music is the cleanest AI-music option (licensed training deals, commercial use on Starter+, $0.15/min via API), and Justin already has an ElevenLabs account and a `generate-music` skill. Suno Pro/Premier grants commercial rights but no guarantee of copyright, making Content ID registration shaky; Udio has disabled downloads. Never register AI music with Content ID yourself, and keep license receipts per track.

### Cited Findings
- ElevenLabs Music API: $0.15/min, 5-min duration limit, fine-tuning $1.50 per finetune, "Commercial use licensing on Starter+ plans"; sound effects described as royalty-free ([ElevenLabs API pricing](https://elevenlabs.io/pricing/api)).
- ElevenLabs Music commercial use allowed on all paid plans except film/TV/radio/studio games (Enterprise only); training licensed via Merlin and Kobalt; a multi-year Universal deal reportedly signed 2026-09-10 ([teamday, Sept 2026](https://www.teamday.ai/blog/best-ai-music-models-2026); [Stability AI explainer](https://stability.ai/explainers/stable-audio-vs-competitors-licensing-export-rights-and-self-hosting-compared)).
- Suno terms (updated 2026-08-10): assigns ownership of output downloaded while subscribed but makes no promise copyright will vest, so Content ID claims are shaky; Content ID risk rated moderate ([dev.to](https://dev.to/akaranjkar08/suno-songs-on-youtube-2026-content-id-and-disclosure-40p7); [The Post Flow](https://thepostflow.com/ai/ai-music-licensing-for-video-editors-what-you-can-actually-use-and-when-the-rights-evaporate/)).
- Udio disabled all downloads on 2025-10-29 after label settlements; not usable for publishing ([teamday](https://www.teamday.ai/blog/best-ai-music-models-2026)).
- Conflict: an April 2026 piece described Suno/Udio licensing as unsettled due to lawsuits ([digitalapplied](https://www.digitalapplied.com/blog/ai-music-generation-platforms-suno-udio-elevenlabs-2026)); later sources describe settlements, so the April view looks outdated.

### Inferences
- Simplest safe path: reuse Math Dragons' own game soundtrack (owned IP, reinforces brand recognition) plus ElevenLabs Music for variety, and the game's own SFX plus ElevenLabs SFX. YouTube Audio Library and TikTok's commercial music library are the fallback for trending-style tracks (not sourced here).
- Keep music low under VO (ducking ~-18 to -24 dB under speech is typical practice).

### Gaps
- No primary YouTube Content ID policy text on AI music was found.
- Royalty-free libraries (Epidemic, Artlist, YouTube Audio Library) not researched for 2026 pricing.

## 7. Quality bar: avoiding "AI slop"

### Takeaway
The consistent signal in 2026 commentary is that YouTube's crackdown targets mass-produced, templated, low-human-input content, not AI use per se; what separates working channels is a narrow niche, original scripting, a distinct visual identity, and a human editing pass. Math Dragons has a structural advantage: proprietary art, real gameplay, and real math expertise that templated generators cannot copy.

### Cited Findings
- AI works for faceless channels "only if you treat the AI tools as a production shortcut": narrow niche, AI scripting, AI voice, human editing, publish ~2x/week for 3+ months before judging ([Lilach Bullock](https://www.lilachbullock.com/grow-faceless-youtube-channel-with-ai/)).
- In January 2026 YouTube terminated 16 channels with a combined 4.7B lifetime views; one analysis argues the system uses on-camera faces as a proxy for mass production ([HackerNoon](https://hackernoon.com/youtubes-ai-slop-crackdown-cant-tell-a-directed-ai-film-from-a-bot-farm)). Others say the target is content with little human creative input ([OutlierKit](https://alpha.outlierkit.com/resources/youtube-ai-slop-crackdown-2026/)).
- Kapwing studies cited: about 1 in 5 Shorts shown to new users was AI-generated junk (study of 15,000 trending channels); a different audit found a higher share; methodologies differ ([OutlierKit](https://alpha.outlierkit.com/resources/youtube-ai-slop-crackdown-2026/); [Vozo](https://www.vozo.ai/blogs/youtube/youtube-ai-slop)).
- Thousands of channels publish near-identical videos from the same templates; repeated hooks, pacing and caption styles are hallmarks of slop ([air.io](https://air.io/en/top-of-voice/ai-on-youtube-in-2026-how-to-stay-ahead-without-turning-into-digital-noise); [subsub.io](https://subsub.io/blog/how-ai-generated-youtube-shorts-will-change-creators-in-2026)).
- Most of these sources are vendors with commercial interests; little hard retention data exists (search summary).

### Inferences
- Known pitfalls and mitigations for this channel:
  - Garbled text/numbers from video models: never let a generative model render digits, equations, or UI. Math is Manim/Remotion only; add an automated check that every number in the script matches the on-screen overlay data.
  - Math errors in LLM scripts: have the script generator output a structured "claims" list (e.g. "8 x 7 = 56"), verify arithmetic in code, and have a human review pedagogy claims.
  - Inconsistent mascot: generate from actual style-bible art as first frame/reference; reject off-model takes; prefer rigged 2D animation for recurring mascot moments.
  - Uncanny motion: keep AI shots short (3 to 5 s), slow, and cut on motion.
  - Templated sameness: rotate 3 to 4 formats (e.g. "the trick schools skip", "watch a 7-year-old's mistake", "60-second parent explainer", "game moment + why it works") with varied hooks.
- A human pass per video (watch at full speed, fix one or two beats, check captions) is the cheapest insurance and is what platforms reportedly look for.

### Gaps
- No rigorous public data on retention differences between AI-assisted and fully human faceless Shorts.

## 8. Per-video cost and time at 3 to 5 videos/week; example pipelines

### Takeaway
A code-first pipeline (LLM script + verification -> ElevenLabs VO -> Manim math clips + gameplay capture + 0 to 2 AI hero shots -> Remotion assembly with auto captions -> human review) should run roughly $2 to $6 per 30 to 60 s Short in variable costs plus ~$25 to $120/month in subscriptions, and about 45 to 90 minutes of human time per video once templated. These are inferences built from the dated prices above, not sourced benchmarks.

### Cited Findings
- `youtube-shorts-pipeline` (rushindrasinha, MIT): topic -> research -> script (Claude) -> visuals (Gemini Imagen) -> voiceover (ElevenLabs) -> captions (Whisper) -> music -> upload; exponential backoff, structured logging, 78 tests, resumable state ([SourcePulse](https://www.sourcepulse.org/projects/26865997)).
- GitHub topic `faceless-video` lists multiple pipelines including a Remotion Claude skill and an AGPL-3.0 viral content pipeline ([GitHub](https://github.com/topics/faceless-video)).
- Tutorials combining OpenAI + ElevenLabs + MoviePy for script-to-video, generating visuals per sentence ([DEV Community](https://dev.to/alex_abdfd4d4832b8ecbe21a/automating-faceless-shorts-videos-for-youtube-and-tiktok-using-openai-and-elevenlabs-2c5); [Robopost](https://robopost.app/blog/how-to-use-elevenlabs-and-openai-to-automate-faceless-shorts-video-for-youtube-and-tiktok/)).
- No-code n8n templates: Gemini + ElevenLabs + Leonardo + Shotstack ([GrowwStacks](https://growwstacks.com/workflows/create-faceless-videos-with-gemini-elevenlabs-leonardo-ai-and-shotstack)); ChatGPT + n8n + Creatomate ([Creatomate](https://creatomate.com/blog/how-to-auto-generate-faceless-shorts-with-chatgpt-and-n8n)).
- Unit prices used below: ElevenLabs v3 $0.08/1K chars, Music $0.15/min ([ElevenLabs](https://elevenlabs.io/pricing/api)); Kling ~$0.08 to $0.11/s, Veo 3.1 Fast $0.10 to $0.12/s ([InVideo](https://invideo.io/blog/ai-video-model-pricing/)); Remotion free for <=3-person companies ([Remotion](https://www.remotion.dev/docs/license/pricing)); Shotstack ~$0.20 to $0.40/min ([wireflow](https://www.wireflow.ai/blog/shotstack-pricing)).

### Inferences
- Per-video variable cost estimate (45 s Short):
  - Script + verification LLM calls: ~$0.05 to $0.30.
  - VO (ElevenLabs v3, ~700 chars, ~3 takes): ~$0.20.
  - Images (OpenAI image gen for storyboard stills/thumbnails, a few images): ~$0.20 to $1.
  - AI video hero shots (0 to 2 x 5 s, ~3 attempts each at ~$0.10/s): $0 to ~$3.
  - Music (ElevenLabs, 1 min) or owned game soundtrack: $0 to $0.15.
  - Rendering: $0 self-hosted Remotion/Manim (or ~$0.20 to $0.40 on Shotstack).
  - Total: roughly $1 to $5 per video; $15 to $100/month at 3 to 5/week.
- Fixed monthly: ElevenLabs Creator $22 (or Pro $99 for more characters/voice clone headroom), optional Submagic ~$41 to $69, optional Kling/Veo prepaid credits.
- Time once templated: idea + script review 15 to 20 min, gameplay capture 10 min (amortized if a bank of clips is pre-recorded), automated render 5 to 10 min, human QA + tweaks 20 to 40 min. First 2 to 3 weeks building the Remotion template and Manim library will be the main investment (est. 20 to 40 hours).
- Suggested pipeline shape for Math Dragons:
  1. Idea bank (parent pain points from the marketing vault) -> LLM script in a fixed JSON schema (hook, beats, on-screen math, CTA) with a code-level arithmetic check.
  2. ElevenLabs v3 VO with timestamps (cloned creator voice).
  3. Visual beats resolved per type: `manim` (math), `gameplay` (pre-recorded clip library tagged by mechanic), `art` (style-bible stills with Ken Burns/parallax), `hero` (optional Kling/Veo image-to-video from style art).
  4. Remotion composition renders 1080x1920 with word-level captions, safe zones, music ducking, end card.
  5. Human QA checklist, then manual upload/schedule.

### Gaps
- No creator postmortem found with measured per-video cost/time for a comparable code-first pipeline.
- No documented example of a kids' math/edtech faceless channel pipeline specifically.
