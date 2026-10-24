import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/core/founding_tester.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/storage/local_storage.dart';

class _MockStorage extends LocalStorage {
  final PlayerProfile _profile;
  final Map<String, dynamic> meta = {};

  _MockStorage({DateTime? createdAt})
      : _profile = PlayerProfile(id: 'test', createdAt: createdAt);

  @override
  PlayerProfile getProfile() => _profile;

  @override
  dynamic getMeta(String key) => meta[key];

  @override
  Future<void> setMeta(String key, dynamic value) async {
    meta[key] = value;
  }
}

void main() {
  final cutoff = DateTime.utc(2027, 6, 1);
  final before = DateTime.utc(2027, 1, 1);
  final after = DateTime.utc(2027, 9, 1);

  group('FoundingTester.record', () {
    test('marks a device launched before the cutoff', () async {
      final storage = _MockStorage(createdAt: before);
      final result = await FoundingTester.record(storage,
          now: before, cutoffOverride: cutoff);
      expect(result, isTrue);
      expect(FoundingTester.isFounding(storage), isTrue);
      expect(storage.meta[FoundingTester.sinceKey], before.toIso8601String());
    });

    test('marks a beta install first opened after the cutoff', () async {
      final storage = _MockStorage(createdAt: before);
      final result = await FoundingTester.record(storage,
          now: after, cutoffOverride: cutoff);
      expect(result, isTrue);
      expect(FoundingTester.isFounding(storage), isTrue);
    });

    test('does not mark a new install after the cutoff', () async {
      final storage = _MockStorage(createdAt: after);
      final result = await FoundingTester.record(storage,
          now: after, cutoffOverride: cutoff);
      expect(result, isFalse);
      expect(FoundingTester.isFounding(storage), isFalse);
      expect(storage.meta, isEmpty);
    });

    test('never clears or re-dates an existing flag', () async {
      final storage = _MockStorage(createdAt: before);
      await FoundingTester.record(storage, now: before, cutoffOverride: cutoff);
      await FoundingTester.record(storage, now: after, cutoffOverride: cutoff);
      expect(FoundingTester.isFounding(storage), isTrue);
      expect(storage.meta[FoundingTester.sinceKey], before.toIso8601String());
    });

    test('with the default placeholder cutoff, every install today is founding',
        () async {
      final storage = _MockStorage();
      expect(await FoundingTester.record(storage), isTrue);
    });
  });
}
