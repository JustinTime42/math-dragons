import '../storage/local_storage.dart';

/// Tracks the current play session state.
class SessionManager {
  final LocalStorage _storage;

  DateTime? _sessionStart;
  DateTime? _gameStart;
  String? _currentGameId;
  int _gamesPlayedThisSession = 0;
  int _consecutiveSameGame = 0;
  String? _lastGameId;

  /// Whether this is the player's very first session ever.
  bool get isFirstEverSession => _storage.getProfile().isFirstSession;

  /// Whether a game session is currently active.
  bool get isInGame => _currentGameId != null;

  /// The game currently being played, or null.
  String? get currentGameId => _currentGameId;

  /// How many games have been played in this app session.
  int get gamesPlayedThisSession => _gamesPlayedThisSession;

  /// How many times the same game has been played consecutively.
  int get consecutiveSameGame => _consecutiveSameGame;

  SessionManager({required LocalStorage storage}) : _storage = storage;

  /// Call when the app launches.
  void startAppSession() {
    _sessionStart = DateTime.now();
    _gamesPlayedThisSession = 0;
    _consecutiveSameGame = 0;
    _lastGameId = null;
  }

  /// Call when a game round starts.
  void startGame(String gameId) {
    _currentGameId = gameId;
    _gameStart = DateTime.now();
    _gamesPlayedThisSession++;

    if (gameId == _lastGameId) {
      _consecutiveSameGame++;
    } else {
      _consecutiveSameGame = 1;
      _lastGameId = gameId;
    }
  }

  /// Call when a game round ends. Returns the duration of the round.
  Duration endGame() {
    final duration = _gameStart != null
        ? DateTime.now().difference(_gameStart!)
        : Duration.zero;

    // Update play time in profile
    final minutes = duration.inMinutes;
    if (minutes > 0) {
      _storage.updateProfile((p) => p.copyWith(
            totalPlayTimeMinutes: p.totalPlayTimeMinutes + minutes,
          ));
    }

    _currentGameId = null;
    _gameStart = null;

    return duration;
  }

  /// Call when the app session ends (app goes to background or closes).
  void endAppSession() {
    if (isInGame) {
      endGame();
    }

    if (isFirstEverSession) {
      _storage.updateProfile((p) => p.copyWith(isFirstSession: false));
    }
  }

  /// Whether to suggest trying a different game.
  bool get shouldSuggestDifferentGame => _consecutiveSameGame >= 3;

  /// Duration of the current app session.
  Duration get appSessionDuration => _sessionStart != null
      ? DateTime.now().difference(_sessionStart!)
      : Duration.zero;
}
