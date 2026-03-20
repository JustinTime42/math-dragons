// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Math Dragons';

  @override
  String get hubTitle => 'Dragon\'s Lair';

  @override
  String get dragonRunes => 'Dragon Runes';

  @override
  String get dragonRunesDescription => 'Connect ancient runes to cast spells';

  @override
  String get fireTrail => 'Fire Trail';

  @override
  String get fireTrailDescription => 'Blaze a trail of flame across the sky';

  @override
  String get dragonEggs => 'Dragon Eggs';

  @override
  String get dragonEggsDescription => 'Hatch dragon eggs with math equations';

  @override
  String get dragonsFeast => 'Dragon\'s Feast';

  @override
  String get dragonsFeastDescription =>
      'Feast on treasures matching the right properties';

  @override
  String get settings => 'Settings';

  @override
  String get sound => 'Sound';

  @override
  String get music => 'Music';

  @override
  String get haptics => 'Haptics';

  @override
  String get backToHub => 'Back to Hub';

  @override
  String get play => 'Play';

  @override
  String level(int number) {
    return 'Level $number';
  }

  @override
  String scalesCount(int count) {
    return '$count Scales';
  }

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get gamePlaceholder =>
      'Game Coming Soon!\nThis game will be built in a future step.';

  @override
  String get dragonNameLabel => 'Dragon Name';

  @override
  String playTimeMinutes(int count) {
    return '$count min played';
  }

  @override
  String factsLearned(int count) {
    return '$count facts learned';
  }

  @override
  String factsMastered(int count) {
    return '$count facts mastered';
  }

  @override
  String totalCorrect(int count) {
    return '$count correct answers';
  }

  @override
  String get aboutTitle => 'About Math Dragons';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get resume => 'Resume';

  @override
  String get quitToHub => 'Quit to Hub';

  @override
  String get playAgain => 'Play Again';

  @override
  String get levelComplete => 'Level Complete!';

  @override
  String get gameOver => 'Game Over';

  @override
  String get scoreLabel => 'Score';

  @override
  String get accuracyLabel => 'Accuracy';

  @override
  String get streakLabel => 'Best Streak';

  @override
  String get testResultScreen => 'Test Result Screen';

  @override
  String get dailyChallengeTitle => 'Today\'s Challenge';

  @override
  String get dailyChallengeReward => 'Reward: 25 scales';

  @override
  String get dailyTaskExample1 => 'Score 200 in Dragon Runes';

  @override
  String get dailyTaskExample2 => 'Play Dragon Eggs';

  @override
  String get dailyTaskExample3 => 'Get a 5-streak in any game';

  @override
  String get dragonNameHint => 'Name your dragon...';

  @override
  String get settingsSoundSection => 'Sound & Haptics';

  @override
  String get soundDescription => 'Sound effects for game actions';

  @override
  String get musicDescription => 'Background music in games and hub';

  @override
  String get hapticsDescription =>
      'Vibration feedback for answers and milestones';

  @override
  String get aboutDescription =>
      'Dragon-powered math games that are actually fun! Practice addition, subtraction, multiplication, and division through genuinely engaging gameplay.';

  @override
  String eggsHatched(int count) {
    return '$count eggs hatched';
  }

  @override
  String comboMultiplier(int count) {
    return 'Combo x$count';
  }

  @override
  String get newFactBonus => 'NEW FACT! +5';

  @override
  String get nope => 'Nope!';

  @override
  String get equalsButtonLabel => '=';

  @override
  String get nestOfAddition => 'Nest of Addition';

  @override
  String get crackingSubtraction => 'Cracking Subtraction';

  @override
  String get multiplicationRoost => 'Multiplication Roost';

  @override
  String get divisionDen => 'Division Den';

  @override
  String get ancientHatchery => 'Ancient Hatchery';

  @override
  String get dangerWarning => 'Eggs rising!';

  @override
  String get levelUp => 'Level Up!';

  @override
  String get highScore => 'High Score';

  @override
  String get newHighScore => 'New High Score!';

  @override
  String factsThisSession(int count) {
    return '$count facts practiced';
  }

  @override
  String get fireTrailTitle => 'Fire Trail';

  @override
  String flameIntensity(int percent) {
    return 'Flame: $percent%';
  }

  @override
  String get flameDanger => 'Flame fading!';

  @override
  String get flameExtinguished => 'Flame extinguished!';

  @override
  String get selfCollision => 'You hit your own trail!';

  @override
  String get wallHit => 'Ouch! The wall burns!';

  @override
  String get correctGem => 'Correct!';

  @override
  String get wrongGem => 'Not quite!';

  @override
  String get firstFlight => 'First Flight';

  @override
  String get thermalCurrents => 'Thermal Currents';

  @override
  String get firestorm => 'Firestorm';

  @override
  String get inferno => 'Inferno';

  @override
  String get dragonMaster => 'Dragon Master';

  @override
  String get countdownGo => 'GO!';

  @override
  String get wrapModeActive => 'Wrap Mode Active';

  @override
  String correctToAdvance(int count) {
    return '$count more to clear this level';
  }

  @override
  String get levelCleared => 'Level Cleared!';

  @override
  String get dragToConnect => 'Drag across runes to cast a spell';

  @override
  String get equationFound => 'Spell cast!';

  @override
  String get equationInvalid => 'Invalid spell!';

  @override
  String get equationAlreadyFound => 'Already cast!';

  @override
  String get equationBonus => 'Bonus spell!';

  @override
  String hintsRemaining(int count) {
    return '$count hints left';
  }

  @override
  String get noHintsRemaining => 'No hints left';

  @override
  String targetsProgress(int found, int total) {
    return '$found of $total spells found';
  }

  @override
  String get allSpellsFound => 'All spells found!';

  @override
  String get streakBonusActive => 'Streak bonus active!';

  @override
  String get emberEquations => 'Ember Equations';

  @override
  String get flameFormulas => 'Flame Formulas';

  @override
  String get infernoAlgebra => 'Inferno Algebra';

  @override
  String get dragonsCalculus => 'Dragon\'s Calculus';

  @override
  String get elderRunes => 'Elder Runes';

  @override
  String get dragonsFeastTitle => 'Dragon\'s Feast';

  @override
  String get correctEat => 'Delicious!';

  @override
  String get wrongEat => 'Yuck!';

  @override
  String get caughtByEnemy => 'Caught!';

  @override
  String livesRemaining(int count) {
    return '$count lives left';
  }

  @override
  String get freezeActivated => 'Fire Breath! Enemies frozen!';

  @override
  String get wingsActivated => 'Wings! Fly over enemies!';

  @override
  String get shieldActivated => 'Shield! Invulnerable!';

  @override
  String tilesEaten(int count) {
    return '$count tiles eaten';
  }

  @override
  String levelsCleared(int count) {
    return '$count levels cleared';
  }

  @override
  String get easyPickings => 'Easy Pickings';

  @override
  String get growingAppetite => 'Growing Appetite';

  @override
  String get refinedPalate => 'Refined Palate';

  @override
  String get gourmetDragon => 'Gourmet Dragon';

  @override
  String get dragonKingsFeast => 'Dragon King\'s Feast';

  @override
  String get evenNumbers => 'Even Numbers';

  @override
  String get oddNumbers => 'Odd Numbers';

  @override
  String multiplesOf(int n) {
    return 'Multiples of $n';
  }

  @override
  String get primeNumbers => 'Prime Numbers';

  @override
  String get compositeNumbers => 'Composite Numbers';

  @override
  String get perfectSquares => 'Perfect Squares';

  @override
  String factorsOf(int n) {
    return 'Factors of $n';
  }

  @override
  String greaterThan(int n) {
    return 'Greater than $n';
  }

  @override
  String lessThan(int n) {
    return 'Less than $n';
  }

  @override
  String betweenRange(int lo, int hi) {
    return 'Between $lo and $hi';
  }

  @override
  String get levelSelect => 'Level Select';

  @override
  String get levelLocked => 'Locked';

  @override
  String starsEarned(int count) {
    return '$count stars';
  }

  @override
  String evolutionProgress(String current, String next) {
    return '$current → $next';
  }

  @override
  String get evolutionMaxed => 'Elder Dragon — Maximum Evolution!';

  @override
  String get requirementMet => 'Complete!';

  @override
  String requirementProgress(int current, int required) {
    return '$current/$required';
  }

  @override
  String reachLevelInGames(int level, int count) {
    return 'Reach level $level in $count games';
  }

  @override
  String earnScales(int count) {
    return 'Earn $count scales';
  }

  @override
  String threeStarLevels(int count) {
    return '3-star $count levels';
  }

  @override
  String masterFacts(int count) {
    return 'Master $count facts';
  }

  @override
  String trySuggestion(String game) {
    return 'Try $game for bonus scales!';
  }

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementsPerGame => 'Per Game';

  @override
  String get achievementsCrossGame => 'Cross Game';

  @override
  String get achievementsMilestones => 'Milestones';

  @override
  String achievementProgress(int current, int target) {
    return '$current/$target';
  }

  @override
  String achievementScalesReward(int count) {
    return '+$count scales';
  }

  @override
  String get todaysChallenge => 'Today\'s Challenge';

  @override
  String get todaysChallengeComplete => 'Today\'s Challenge Complete!';

  @override
  String dailyChallengeScalesReward(int count) {
    return 'Reward: $count scales';
  }

  @override
  String dailyChallengeStreak(int count) {
    return '$count day streak';
  }

  @override
  String dailyChallengeStreakBonus(int count) {
    return '+$count streak bonus';
  }

  @override
  String get dragonStore => 'Dragon Store';

  @override
  String get dragonColors => 'Dragon Colors';

  @override
  String get dragonAccessories => 'Accessories';

  @override
  String get customizeYourDragon => 'Customize your dragon';

  @override
  String get styleYourDragon => 'Style your dragon';

  @override
  String get owned => 'Owned';

  @override
  String get equippedLabel => 'Equipped';

  @override
  String get purchase => 'Purchase';

  @override
  String get insufficientScales => 'Not enough scales';

  @override
  String get premiumPacks => 'Premium Packs';

  @override
  String soCloseHighScore(int points) {
    return 'So close to your high score! Just $points more points.';
  }

  @override
  String almostCleared(int count) {
    return 'Almost there! $count more correct answers to clear this level.';
  }

  @override
  String get soCloseThreeStars =>
      'So close to 3 stars! A little more accuracy and you\'ve got it!';

  @override
  String tryOtherGame(String game) {
    return 'Your dragon is hungry! Try $game for bonus scales.';
  }

  @override
  String get nextLevel => 'Next Level';

  @override
  String get customizeDragon => 'Customize Dragon';

  @override
  String get visitStore => 'Visit Store';

  @override
  String get emptyWardrobe => 'Your wardrobe is empty!';

  @override
  String get emptyWardrobeHint =>
      'Visit the Dragon Store to buy colors and accessories for your dragon.';

  @override
  String get equipped => 'Equipped';
}
