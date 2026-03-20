import 'package:hive/hive.dart';

part 'player_profile.g.dart';

@HiveType(typeId: 0)
class PlayerProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String dragonName;

  @HiveField(2)
  final int dragonEvolution; // 0=egg, 1=hatchling, 2=fledgling, 3=young, 4=adult, 5=elder

  @HiveField(3)
  final int totalScales;

  @HiveField(4)
  final int totalCorrectAnswers;

  @HiveField(5)
  final int totalPlayTimeMinutes;

  @HiveField(6)
  final int dailyChallengeStreak;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime lastPlayedAt;

  @HiveField(9)
  final Map<String, GameStats> gameStats;

  @HiveField(10)
  final PlayerSettings settings;

  @HiveField(11)
  final List<String> ownedCosmetics;

  @HiveField(12)
  final String? equippedColor;

  @HiveField(13)
  final List<String> equippedAccessories;

  @HiveField(14)
  final int schemaVersion;

  @HiveField(15)
  final bool isFirstSession;

  @HiveField(16)
  final String? ageGroup; // "under13" or "13plus", null if not set

  @HiveField(17)
  final String? firebaseUid;

  @HiveField(18)
  final String? linkedProvider; // null, "anonymous", or "google"

  @HiveField(19)
  final String? equippedBackground;

  PlayerProfile({
    required this.id,
    this.dragonName = 'Dragon',
    this.dragonEvolution = 0,
    this.totalScales = 0,
    this.totalCorrectAnswers = 0,
    this.totalPlayTimeMinutes = 0,
    this.dailyChallengeStreak = 0,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<String, GameStats>? gameStats,
    PlayerSettings? settings,
    List<String>? ownedCosmetics,
    this.equippedColor,
    List<String>? equippedAccessories,
    this.schemaVersion = 1,
    this.isFirstSession = true,
    this.ageGroup,
    this.firebaseUid,
    this.linkedProvider,
    this.equippedBackground,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastPlayedAt = lastPlayedAt ?? DateTime.now(),
        gameStats = gameStats ?? const {},
        settings = settings ?? const PlayerSettings(),
        ownedCosmetics = ownedCosmetics ?? const [],
        equippedAccessories = equippedAccessories ?? const [];

  PlayerProfile copyWith({
    String? id,
    String? dragonName,
    int? dragonEvolution,
    int? totalScales,
    int? totalCorrectAnswers,
    int? totalPlayTimeMinutes,
    int? dailyChallengeStreak,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<String, GameStats>? gameStats,
    PlayerSettings? settings,
    List<String>? ownedCosmetics,
    String? equippedColor,
    List<String>? equippedAccessories,
    int? schemaVersion,
    bool? isFirstSession,
    String? ageGroup,
    String? firebaseUid,
    String? linkedProvider,
    String? equippedBackground,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      dragonName: dragonName ?? this.dragonName,
      dragonEvolution: dragonEvolution ?? this.dragonEvolution,
      totalScales: totalScales ?? this.totalScales,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      dailyChallengeStreak: dailyChallengeStreak ?? this.dailyChallengeStreak,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      gameStats: gameStats ?? this.gameStats,
      settings: settings ?? this.settings,
      ownedCosmetics: ownedCosmetics ?? this.ownedCosmetics,
      equippedColor: equippedColor ?? this.equippedColor,
      equippedAccessories: equippedAccessories ?? this.equippedAccessories,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      isFirstSession: isFirstSession ?? this.isFirstSession,
      ageGroup: ageGroup ?? this.ageGroup,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      linkedProvider: linkedProvider ?? this.linkedProvider,
      equippedBackground: equippedBackground ?? this.equippedBackground,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'dragonName': dragonName,
        'dragonEvolution': dragonEvolution,
        'totalScales': totalScales,
        'totalCorrectAnswers': totalCorrectAnswers,
        'totalPlayTimeMinutes': totalPlayTimeMinutes,
        'dailyChallengeStreak': dailyChallengeStreak,
        'createdAt': createdAt.toIso8601String(),
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'gameStats': gameStats.map((k, v) => MapEntry(k, v.toJson())),
        'settings': {
          'soundEnabled': settings.soundEnabled,
          'musicEnabled': settings.musicEnabled,
          'hapticsEnabled': settings.hapticsEnabled,
        },
        'ownedCosmetics': ownedCosmetics,
        'equippedColor': equippedColor,
        'equippedAccessories': equippedAccessories,
        'schemaVersion': schemaVersion,
        'isFirstSession': isFirstSession,
        'ageGroup': ageGroup,
        'firebaseUid': firebaseUid,
        'linkedProvider': linkedProvider,
        'equippedBackground': equippedBackground,
      };

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      id: json['id'] as String,
      dragonName: json['dragonName'] as String? ?? 'Dragon',
      dragonEvolution: json['dragonEvolution'] as int? ?? 0,
      totalScales: json['totalScales'] as int? ?? 0,
      totalCorrectAnswers: json['totalCorrectAnswers'] as int? ?? 0,
      totalPlayTimeMinutes: json['totalPlayTimeMinutes'] as int? ?? 0,
      dailyChallengeStreak: json['dailyChallengeStreak'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'] as String)
          : null,
      gameStats: (json['gameStats'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, GameStats.fromJson(v as Map<String, dynamic>)),
          ) ??
          const {},
      settings: json['settings'] != null
          ? PlayerSettings(
              soundEnabled:
                  (json['settings'] as Map<String, dynamic>)['soundEnabled'] as bool? ?? true,
              musicEnabled:
                  (json['settings'] as Map<String, dynamic>)['musicEnabled'] as bool? ?? true,
              hapticsEnabled:
                  (json['settings'] as Map<String, dynamic>)['hapticsEnabled'] as bool? ?? true,
            )
          : const PlayerSettings(),
      ownedCosmetics: (json['ownedCosmetics'] as List<dynamic>?)
              ?.cast<String>() ??
          const [],
      equippedColor: json['equippedColor'] as String?,
      equippedAccessories: (json['equippedAccessories'] as List<dynamic>?)
              ?.cast<String>() ??
          const [],
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      isFirstSession: json['isFirstSession'] as bool? ?? true,
      ageGroup: json['ageGroup'] as String?,
      firebaseUid: json['firebaseUid'] as String?,
      linkedProvider: json['linkedProvider'] as String?,
      equippedBackground: json['equippedBackground'] as String?,
    );
  }
}

@HiveType(typeId: 1)
class GameStats {
  @HiveField(0)
  final int currentLevel;

  @HiveField(1)
  final int highScore;

  @HiveField(2)
  final int totalStars;

  @HiveField(3)
  final int timesPlayed;

  @HiveField(4)
  final int bestStreak;

  @HiveField(5)
  final double accuracy;

  @HiveField(6)
  final int totalCorrect;

  @HiveField(7)
  final int totalAttempted;

  @HiveField(8)
  final DateTime? lastPlayed;

  @HiveField(9)
  final Map<int, int> levelStars;

  const GameStats({
    this.currentLevel = 1,
    this.highScore = 0,
    this.totalStars = 0,
    this.timesPlayed = 0,
    this.bestStreak = 0,
    this.accuracy = 0.0,
    this.totalCorrect = 0,
    this.totalAttempted = 0,
    this.lastPlayed,
    this.levelStars = const {},
  });

  GameStats copyWith({
    int? currentLevel,
    int? highScore,
    int? totalStars,
    int? timesPlayed,
    int? bestStreak,
    double? accuracy,
    int? totalCorrect,
    int? totalAttempted,
    DateTime? lastPlayed,
    Map<int, int>? levelStars,
  }) {
    return GameStats(
      currentLevel: currentLevel ?? this.currentLevel,
      highScore: highScore ?? this.highScore,
      totalStars: totalStars ?? this.totalStars,
      timesPlayed: timesPlayed ?? this.timesPlayed,
      bestStreak: bestStreak ?? this.bestStreak,
      accuracy: accuracy ?? this.accuracy,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalAttempted: totalAttempted ?? this.totalAttempted,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      levelStars: levelStars ?? this.levelStars,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentLevel': currentLevel,
        'highScore': highScore,
        'totalStars': totalStars,
        'timesPlayed': timesPlayed,
        'bestStreak': bestStreak,
        'accuracy': accuracy,
        'totalCorrect': totalCorrect,
        'totalAttempted': totalAttempted,
        'lastPlayed': lastPlayed?.toIso8601String(),
        'levelStars':
            levelStars.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      currentLevel: json['currentLevel'] as int? ?? 1,
      highScore: json['highScore'] as int? ?? 0,
      totalStars: json['totalStars'] as int? ?? 0,
      timesPlayed: json['timesPlayed'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      totalCorrect: json['totalCorrect'] as int? ?? 0,
      totalAttempted: json['totalAttempted'] as int? ?? 0,
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'] as String)
          : null,
      levelStars: (json['levelStars'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v as int),
          ) ??
          const {},
    );
  }
}

@HiveType(typeId: 2)
class PlayerSettings {
  @HiveField(0)
  final bool soundEnabled;

  @HiveField(1)
  final bool musicEnabled;

  @HiveField(2)
  final bool hapticsEnabled;

  const PlayerSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
  });

  PlayerSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
  }) {
    return PlayerSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
