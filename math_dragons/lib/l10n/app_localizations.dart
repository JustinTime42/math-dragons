import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The app name shown in the title bar
  ///
  /// In en, this message translates to:
  /// **'Math Dragons'**
  String get appTitle;

  /// Title of the hub/home screen
  ///
  /// In en, this message translates to:
  /// **'Dragon\'s Lair'**
  String get hubTitle;

  /// Name of the Number Links game
  ///
  /// In en, this message translates to:
  /// **'Dragon Runes'**
  String get dragonRunes;

  /// Short description of Dragon Runes
  ///
  /// In en, this message translates to:
  /// **'Connect ancient runes to cast spells'**
  String get dragonRunesDescription;

  /// Name of the Math Snake game
  ///
  /// In en, this message translates to:
  /// **'Fire Trail'**
  String get fireTrail;

  /// Short description of Fire Trail
  ///
  /// In en, this message translates to:
  /// **'Blaze a trail of flame across the sky'**
  String get fireTrailDescription;

  /// Name of the Bubble Pop game
  ///
  /// In en, this message translates to:
  /// **'Dragon Eggs'**
  String get dragonEggs;

  /// Short description of Dragon Eggs
  ///
  /// In en, this message translates to:
  /// **'Hatch dragon eggs with math equations'**
  String get dragonEggsDescription;

  /// Name of the Muncher game
  ///
  /// In en, this message translates to:
  /// **'Dragon\'s Feast'**
  String get dragonsFeast;

  /// Short description of Dragon's Feast
  ///
  /// In en, this message translates to:
  /// **'Feast on treasures matching the right properties'**
  String get dragonsFeastDescription;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sound effects toggle label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Background music toggle label
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// Vibration feedback toggle label
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get haptics;

  /// Button text to return to hub
  ///
  /// In en, this message translates to:
  /// **'Back to Hub'**
  String get backToHub;

  /// Play button text
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Level indicator
  ///
  /// In en, this message translates to:
  /// **'Level {number}'**
  String level(int number);

  /// Dragon scales currency display
  ///
  /// In en, this message translates to:
  /// **'{count} Scales'**
  String scalesCount(int count);

  /// Placeholder text for upcoming features
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Placeholder text shown in stub game screens
  ///
  /// In en, this message translates to:
  /// **'Game Coming Soon!\nThis game will be built in a future step.'**
  String get gamePlaceholder;

  /// Label for dragon name input
  ///
  /// In en, this message translates to:
  /// **'Dragon Name'**
  String get dragonNameLabel;

  /// Total play time display
  ///
  /// In en, this message translates to:
  /// **'{count} min played'**
  String playTimeMinutes(int count);

  /// Number of math facts at familiar or mastered status
  ///
  /// In en, this message translates to:
  /// **'{count} facts learned'**
  String factsLearned(int count);

  /// Number of math facts at mastered status
  ///
  /// In en, this message translates to:
  /// **'{count} facts mastered'**
  String factsMastered(int count);

  /// Lifetime correct answer count
  ///
  /// In en, this message translates to:
  /// **'{count} correct answers'**
  String totalCorrect(int count);

  /// About section heading in settings
  ///
  /// In en, this message translates to:
  /// **'About Math Dragons'**
  String get aboutTitle;

  /// App version display
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Pause button tooltip
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Pause overlay title
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Resume button on pause overlay
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Quit game and return to hub
  ///
  /// In en, this message translates to:
  /// **'Quit to Hub'**
  String get quitToHub;

  /// Play another round button on result screen
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Title on result screen after completing a level
  ///
  /// In en, this message translates to:
  /// **'Level Complete!'**
  String get levelComplete;

  /// Title on result screen when game ends
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Label for score stat on result screen
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// Label for accuracy stat on result screen
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracyLabel;

  /// Label for streak stat on result screen
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get streakLabel;

  /// Demo button text on placeholder game screens
  ///
  /// In en, this message translates to:
  /// **'Test Result Screen'**
  String get testResultScreen;

  /// Title on the daily challenge card
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge'**
  String get dailyChallengeTitle;

  /// Reward text on daily challenge card
  ///
  /// In en, this message translates to:
  /// **'Reward: 25 scales'**
  String get dailyChallengeReward;

  /// Example daily challenge task 1
  ///
  /// In en, this message translates to:
  /// **'Score 200 in Dragon Runes'**
  String get dailyTaskExample1;

  /// Example daily challenge task 2
  ///
  /// In en, this message translates to:
  /// **'Play Dragon Eggs'**
  String get dailyTaskExample2;

  /// Example daily challenge task 3
  ///
  /// In en, this message translates to:
  /// **'Get a 5-streak in any game'**
  String get dailyTaskExample3;

  /// Placeholder text for dragon name input
  ///
  /// In en, this message translates to:
  /// **'Name your dragon...'**
  String get dragonNameHint;

  /// Section header for sound settings
  ///
  /// In en, this message translates to:
  /// **'Sound & Haptics'**
  String get settingsSoundSection;

  /// Subtitle text for sound toggle
  ///
  /// In en, this message translates to:
  /// **'Sound effects for game actions'**
  String get soundDescription;

  /// Subtitle text for music toggle
  ///
  /// In en, this message translates to:
  /// **'Background music in games and hub'**
  String get musicDescription;

  /// Subtitle text for haptics toggle
  ///
  /// In en, this message translates to:
  /// **'Vibration feedback for answers and milestones'**
  String get hapticsDescription;

  /// About section description text
  ///
  /// In en, this message translates to:
  /// **'Dragon-powered math games that are actually fun! Practice addition, subtraction, multiplication, and division through genuinely engaging gameplay.'**
  String get aboutDescription;

  /// Counter showing total eggs hatched
  ///
  /// In en, this message translates to:
  /// **'{count} eggs hatched'**
  String eggsHatched(int count);

  /// Combo multiplier display
  ///
  /// In en, this message translates to:
  /// **'Combo x{count}'**
  String comboMultiplier(int count);

  /// New fact bonus notification
  ///
  /// In en, this message translates to:
  /// **'NEW FACT! +5'**
  String get newFactBonus;

  /// Wrong answer feedback
  ///
  /// In en, this message translates to:
  /// **'Nope!'**
  String get nope;

  /// Equals button in equation builder
  ///
  /// In en, this message translates to:
  /// **'='**
  String get equalsButtonLabel;

  /// Dragon Eggs World 1 name
  ///
  /// In en, this message translates to:
  /// **'Nest of Addition'**
  String get nestOfAddition;

  /// Dragon Eggs World 2 name
  ///
  /// In en, this message translates to:
  /// **'Cracking Subtraction'**
  String get crackingSubtraction;

  /// Dragon Eggs World 3 name
  ///
  /// In en, this message translates to:
  /// **'Multiplication Roost'**
  String get multiplicationRoost;

  /// Dragon Eggs World 4 name
  ///
  /// In en, this message translates to:
  /// **'Division Den'**
  String get divisionDen;

  /// Dragon Eggs World 5 name
  ///
  /// In en, this message translates to:
  /// **'Ancient Hatchery'**
  String get ancientHatchery;

  /// Warning when eggs approach the danger line
  ///
  /// In en, this message translates to:
  /// **'Eggs rising!'**
  String get dangerWarning;

  /// Shown when auto-leveling to next tier
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get levelUp;

  /// High score label
  ///
  /// In en, this message translates to:
  /// **'High Score'**
  String get highScore;

  /// Shown when player beats their high score
  ///
  /// In en, this message translates to:
  /// **'New High Score!'**
  String get newHighScore;

  /// Number of unique facts practiced in this session
  ///
  /// In en, this message translates to:
  /// **'{count} facts practiced'**
  String factsThisSession(int count);

  /// Fire Trail game title
  ///
  /// In en, this message translates to:
  /// **'Fire Trail'**
  String get fireTrailTitle;

  /// Flame intensity meter label
  ///
  /// In en, this message translates to:
  /// **'Flame: {percent}%'**
  String flameIntensity(int percent);

  /// Warning when flame intensity is critically low
  ///
  /// In en, this message translates to:
  /// **'Flame fading!'**
  String get flameDanger;

  /// Game over message when flame reaches 0
  ///
  /// In en, this message translates to:
  /// **'Flame extinguished!'**
  String get flameExtinguished;

  /// Game over message on self-collision
  ///
  /// In en, this message translates to:
  /// **'You hit your own trail!'**
  String get selfCollision;

  /// Feedback on wall collision
  ///
  /// In en, this message translates to:
  /// **'Ouch! The wall burns!'**
  String get wallHit;

  /// Feedback when correct answer gem is eaten
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correctGem;

  /// Feedback when wrong answer gem is eaten
  ///
  /// In en, this message translates to:
  /// **'Not quite!'**
  String get wrongGem;

  /// Fire Trail World 1 name
  ///
  /// In en, this message translates to:
  /// **'First Flight'**
  String get firstFlight;

  /// Fire Trail World 2 name
  ///
  /// In en, this message translates to:
  /// **'Thermal Currents'**
  String get thermalCurrents;

  /// Fire Trail World 3 name
  ///
  /// In en, this message translates to:
  /// **'Firestorm'**
  String get firestorm;

  /// Fire Trail World 4 name
  ///
  /// In en, this message translates to:
  /// **'Inferno'**
  String get inferno;

  /// Fire Trail World 5 name
  ///
  /// In en, this message translates to:
  /// **'Dragon Master'**
  String get dragonMaster;

  /// Countdown completion text
  ///
  /// In en, this message translates to:
  /// **'GO!'**
  String get countdownGo;

  /// Indicator that wrap mode is on
  ///
  /// In en, this message translates to:
  /// **'Wrap Mode Active'**
  String get wrapModeActive;

  /// Remaining correct answers needed to complete level
  ///
  /// In en, this message translates to:
  /// **'{count} more to clear this level'**
  String correctToAdvance(int count);

  /// Shown when level target is reached
  ///
  /// In en, this message translates to:
  /// **'Level Cleared!'**
  String get levelCleared;

  /// Instruction text when no chain is active
  ///
  /// In en, this message translates to:
  /// **'Drag across runes to cast a spell'**
  String get dragToConnect;

  /// Feedback when a target equation is found
  ///
  /// In en, this message translates to:
  /// **'Spell cast!'**
  String get equationFound;

  /// Feedback when an invalid equation is submitted
  ///
  /// In en, this message translates to:
  /// **'Invalid spell!'**
  String get equationInvalid;

  /// Feedback when an already-found equation is submitted
  ///
  /// In en, this message translates to:
  /// **'Already cast!'**
  String get equationAlreadyFound;

  /// Feedback when a valid but non-target equation is submitted
  ///
  /// In en, this message translates to:
  /// **'Bonus spell!'**
  String get equationBonus;

  /// Hint counter label
  ///
  /// In en, this message translates to:
  /// **'{count} hints left'**
  String hintsRemaining(int count);

  /// Hint button when all hints used
  ///
  /// In en, this message translates to:
  /// **'No hints left'**
  String get noHintsRemaining;

  /// Progress indicator for target equations
  ///
  /// In en, this message translates to:
  /// **'{found} of {total} spells found'**
  String targetsProgress(int found, int total);

  /// Shown when all target equations are solved
  ///
  /// In en, this message translates to:
  /// **'All spells found!'**
  String get allSpellsFound;

  /// Shown when streak >= 3
  ///
  /// In en, this message translates to:
  /// **'Streak bonus active!'**
  String get streakBonusActive;

  /// Dragon Runes World 1 name
  ///
  /// In en, this message translates to:
  /// **'Ember Equations'**
  String get emberEquations;

  /// Dragon Runes World 2 name
  ///
  /// In en, this message translates to:
  /// **'Flame Formulas'**
  String get flameFormulas;

  /// Dragon Runes World 3 name
  ///
  /// In en, this message translates to:
  /// **'Inferno Algebra'**
  String get infernoAlgebra;

  /// Dragon Runes World 4 name
  ///
  /// In en, this message translates to:
  /// **'Dragon\'s Calculus'**
  String get dragonsCalculus;

  /// Dragon Runes World 5 name
  ///
  /// In en, this message translates to:
  /// **'Elder Runes'**
  String get elderRunes;

  /// Game title for hub and HUD
  ///
  /// In en, this message translates to:
  /// **'Dragon\'s Feast'**
  String get dragonsFeastTitle;

  /// Feedback on eating a correct tile
  ///
  /// In en, this message translates to:
  /// **'Delicious!'**
  String get correctEat;

  /// Feedback on eating a wrong tile
  ///
  /// In en, this message translates to:
  /// **'Yuck!'**
  String get wrongEat;

  /// Feedback when caught by an enemy
  ///
  /// In en, this message translates to:
  /// **'Caught!'**
  String get caughtByEnemy;

  /// Lives counter
  ///
  /// In en, this message translates to:
  /// **'{count} lives left'**
  String livesRemaining(int count);

  /// Freeze power-up activation
  ///
  /// In en, this message translates to:
  /// **'Fire Breath! Enemies frozen!'**
  String get freezeActivated;

  /// Wings power-up activation
  ///
  /// In en, this message translates to:
  /// **'Wings! Fly over enemies!'**
  String get wingsActivated;

  /// Shield power-up activation
  ///
  /// In en, this message translates to:
  /// **'Shield! Invulnerable!'**
  String get shieldActivated;

  /// Total tiles eaten stat
  ///
  /// In en, this message translates to:
  /// **'{count} tiles eaten'**
  String tilesEaten(int count);

  /// Levels cleared in session
  ///
  /// In en, this message translates to:
  /// **'{count} levels cleared'**
  String levelsCleared(int count);

  /// Dragon's Feast World 1 name
  ///
  /// In en, this message translates to:
  /// **'Easy Pickings'**
  String get easyPickings;

  /// Dragon's Feast World 2 name
  ///
  /// In en, this message translates to:
  /// **'Growing Appetite'**
  String get growingAppetite;

  /// Dragon's Feast World 3 name
  ///
  /// In en, this message translates to:
  /// **'Refined Palate'**
  String get refinedPalate;

  /// Dragon's Feast World 4 name
  ///
  /// In en, this message translates to:
  /// **'Gourmet Dragon'**
  String get gourmetDragon;

  /// Dragon's Feast World 5 name
  ///
  /// In en, this message translates to:
  /// **'Dragon King\'s Feast'**
  String get dragonKingsFeast;

  /// Category name
  ///
  /// In en, this message translates to:
  /// **'Even Numbers'**
  String get evenNumbers;

  /// Category name
  ///
  /// In en, this message translates to:
  /// **'Odd Numbers'**
  String get oddNumbers;

  /// Multiples category name
  ///
  /// In en, this message translates to:
  /// **'Multiples of {n}'**
  String multiplesOf(int n);

  /// Category name
  ///
  /// In en, this message translates to:
  /// **'Prime Numbers'**
  String get primeNumbers;

  /// Category name
  ///
  /// In en, this message translates to:
  /// **'Composite Numbers'**
  String get compositeNumbers;

  /// Category name
  ///
  /// In en, this message translates to:
  /// **'Perfect Squares'**
  String get perfectSquares;

  /// Factors category name
  ///
  /// In en, this message translates to:
  /// **'Factors of {n}'**
  String factorsOf(int n);

  /// Greater than category name
  ///
  /// In en, this message translates to:
  /// **'Greater than {n}'**
  String greaterThan(int n);

  /// Less than category name
  ///
  /// In en, this message translates to:
  /// **'Less than {n}'**
  String lessThan(int n);

  /// Range category name
  ///
  /// In en, this message translates to:
  /// **'Between {lo} and {hi}'**
  String betweenRange(int lo, int hi);

  /// Level select screen title
  ///
  /// In en, this message translates to:
  /// **'Level Select'**
  String get levelSelect;

  /// Shown for locked levels
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get levelLocked;

  /// Star count display
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String starsEarned(int count);

  /// Evolution progress label
  ///
  /// In en, this message translates to:
  /// **'{current} → {next}'**
  String evolutionProgress(String current, String next);

  /// Max evolution reached
  ///
  /// In en, this message translates to:
  /// **'Elder Dragon — Maximum Evolution!'**
  String get evolutionMaxed;

  /// Shown when a requirement is met
  ///
  /// In en, this message translates to:
  /// **'Complete!'**
  String get requirementMet;

  /// Requirement progress display
  ///
  /// In en, this message translates to:
  /// **'{current}/{required}'**
  String requirementProgress(int current, int required);

  /// Evolution requirement label
  ///
  /// In en, this message translates to:
  /// **'Reach level {level} in {count} games'**
  String reachLevelInGames(int level, int count);

  /// Scales requirement label
  ///
  /// In en, this message translates to:
  /// **'Earn {count} scales'**
  String earnScales(int count);

  /// Three star requirement label
  ///
  /// In en, this message translates to:
  /// **'3-star {count} levels'**
  String threeStarLevels(int count);

  /// Mastered facts requirement label
  ///
  /// In en, this message translates to:
  /// **'Master {count} facts'**
  String masterFacts(int count);

  /// Game variety suggestion
  ///
  /// In en, this message translates to:
  /// **'Try {game} for bonus scales!'**
  String trySuggestion(String game);

  /// Achievement unlock banner title
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// Achievements screen title
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// Per-game achievements tab
  ///
  /// In en, this message translates to:
  /// **'Per Game'**
  String get achievementsPerGame;

  /// Cross-game achievements tab
  ///
  /// In en, this message translates to:
  /// **'Cross Game'**
  String get achievementsCrossGame;

  /// Milestone achievements tab
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get achievementsMilestones;

  /// Achievement progress display
  ///
  /// In en, this message translates to:
  /// **'{current}/{target}'**
  String achievementProgress(int current, int target);

  /// Achievement scales reward display
  ///
  /// In en, this message translates to:
  /// **'+{count} scales'**
  String achievementScalesReward(int count);

  /// Daily challenge card title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge'**
  String get todaysChallenge;

  /// Daily challenge complete title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge Complete!'**
  String get todaysChallengeComplete;

  /// Daily challenge scales reward display
  ///
  /// In en, this message translates to:
  /// **'Reward: {count} scales'**
  String dailyChallengeScalesReward(int count);

  /// Daily challenge streak display
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String dailyChallengeStreak(int count);

  /// Daily challenge streak bonus display
  ///
  /// In en, this message translates to:
  /// **'+{count} streak bonus'**
  String dailyChallengeStreakBonus(int count);

  /// Store screen title
  ///
  /// In en, this message translates to:
  /// **'Dragon Store'**
  String get dragonStore;

  /// Store section: dragon colors
  ///
  /// In en, this message translates to:
  /// **'Dragon Colors'**
  String get dragonColors;

  /// Store section: accessories
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get dragonAccessories;

  /// Dragon colors subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize your dragon'**
  String get customizeYourDragon;

  /// Accessories subtitle
  ///
  /// In en, this message translates to:
  /// **'Style your dragon'**
  String get styleYourDragon;

  /// Cosmetic ownership label
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// Cosmetic equipped label
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get equippedLabel;

  /// Purchase button text
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// Insufficient scales message
  ///
  /// In en, this message translates to:
  /// **'Not enough scales'**
  String get insufficientScales;

  /// Store section: premium packs
  ///
  /// In en, this message translates to:
  /// **'Premium Packs'**
  String get premiumPacks;

  /// Encouragement near high score
  ///
  /// In en, this message translates to:
  /// **'So close to your high score! Just {points} more points.'**
  String soCloseHighScore(int points);

  /// Encouragement near level clear
  ///
  /// In en, this message translates to:
  /// **'Almost there! {count} more correct answers to clear this level.'**
  String almostCleared(int count);

  /// Encouragement near 3 stars
  ///
  /// In en, this message translates to:
  /// **'So close to 3 stars! A little more accuracy and you\'ve got it!'**
  String get soCloseThreeStars;

  /// Game variety suggestion on result screen
  ///
  /// In en, this message translates to:
  /// **'Your dragon is hungry! Try {game} for bonus scales.'**
  String tryOtherGame(String game);

  /// Button to advance to the next level on result screen
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// Title of the dragon customization screen
  ///
  /// In en, this message translates to:
  /// **'Customize Dragon'**
  String get customizeDragon;

  /// Button to navigate to the Dragon Store from customization screen
  ///
  /// In en, this message translates to:
  /// **'Visit Store'**
  String get visitStore;

  /// Empty state title when no cosmetics are owned
  ///
  /// In en, this message translates to:
  /// **'Your wardrobe is empty!'**
  String get emptyWardrobe;

  /// Empty state hint when no cosmetics are owned
  ///
  /// In en, this message translates to:
  /// **'Visit the Dragon Store to buy colors and accessories for your dragon.'**
  String get emptyWardrobeHint;

  /// Label shown on equipped cosmetic items
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get equipped;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
