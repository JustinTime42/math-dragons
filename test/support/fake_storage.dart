import 'package:math_dragons/core/fact_tracker.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/storage/local_storage.dart';

/// In-memory [LocalStorage] covering the profile and fact-history methods
/// used by FactTracker, GameShell and the game screens. No Hive involved.
class FakeStorage extends LocalStorage {
  final Map<String, FactRecord> facts = {};
  PlayerProfile _profile = PlayerProfile(id: 'test');

  @override
  PlayerProfile getProfile() => _profile;

  @override
  Future<PlayerProfile> updateProfile(
    PlayerProfile Function(PlayerProfile current) transform,
  ) async {
    _profile = transform(_profile);
    return _profile;
  }

  @override
  FactRecord? getFact(String factKey) => facts[factKey];

  @override
  Future<void> saveFact(FactRecord fact) async {
    facts[fact.factKey] = fact;
  }

  @override
  List<FactRecord> getAllFacts() => facts.values.toList();

  @override
  List<FactRecord> getFactsByStatus(FactStatus status) =>
      facts.values.where((f) => f.status == status).toList();

  @override
  Map<FactStatus, int> getFactStatusCounts() {
    final counts = {for (final s in FactStatus.values) s: 0};
    for (final f in facts.values) {
      counts[f.status] = counts[f.status]! + 1;
    }
    return counts;
  }
}
