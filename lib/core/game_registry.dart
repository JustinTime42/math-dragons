import 'game_interface.dart';
import '../storage/local_storage.dart';

/// Central registry of all available games.
/// Games register on app start; the hub discovers and displays them.
class GameRegistry {
  final List<MathDragonsGame> _games = [];
  final LocalStorage _storage;

  GameRegistry(this._storage);

  List<MathDragonsGame> get games => List.unmodifiable(_games);

  int get count => _games.length;

  bool get isEmpty => _games.isEmpty;

  void register(MathDragonsGame game) {
    // Prevent duplicate registration
    if (_games.any((g) => g.gameId == game.gameId)) return;
    _games.add(game);
  }

  MathDragonsGame? getById(String gameId) {
    try {
      return _games.firstWhere((g) => g.gameId == gameId);
    } catch (_) {
      return null;
    }
  }

  /// Games sorted by most recently played (for hub display).
  List<MathDragonsGame> get gamesByLastPlayed {
    final profile = _storage.getProfile();
    return List<MathDragonsGame>.from(_games)
      ..sort((a, b) {
        final aStats = profile.gameStats[a.gameId];
        final bStats = profile.gameStats[b.gameId];
        final aTime = aStats?.lastPlayed ?? DateTime(2000);
        final bTime = bStats?.lastPlayed ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
  }

  /// Games the player has never played (for "try a new game" suggestions).
  List<MathDragonsGame> get unplayedGames {
    final profile = _storage.getProfile();
    return _games.where((g) {
      final stats = profile.gameStats[g.gameId];
      return stats == null || stats.timesPlayed == 0;
    }).toList();
  }
}
