import 'package:flutter/foundation.dart';
import 'local_storage.dart';

class MigrationRunner {
  static const int currentVersion = 3;

  /// Run any needed migrations on app start.
  static Future<void> run(LocalStorage storage) async {
    final storedVersion = storage.schemaVersion;

    if (storedVersion >= currentVersion) return;

    for (int v = storedVersion + 1; v <= currentVersion; v++) {
      final migration = _migrations[v];
      if (migration != null) {
        if (kDebugMode) {
          debugPrint('Running migration to v$v');
        }
        await migration(storage);
      }
    }

    await storage.setSchemaVersion(currentVersion);
  }

  static final Map<int, Future<void> Function(LocalStorage)> _migrations = {
    1: _migrateToV1,
    2: _migrateToV2,
    3: _migrateToV3,
  };

  /// v0 -> v1: Initial schema setup. Ensures a profile exists.
  static Future<void> _migrateToV1(LocalStorage storage) async {
    storage.getProfile();
  }

  /// v1 -> v2: Added firebaseUid and linkedProvider fields (now unused).
  /// Kept for existing users who already ran this migration.
  static Future<void> _migrateToV2(LocalStorage storage) async {
    // Force a re-save of the profile to pick up new field defaults
    final profile = storage.getProfile();
    await storage.saveProfile(profile.copyWith(schemaVersion: 2));
  }

  /// v2 -> v3: Remap old accessory IDs to match new generated image files.
  /// acc_glasses -> acc_necklace, acc_hat -> acc_wizard_hat,
  /// acc_bow -> acc_wing_decorations, acc_shield -> acc_battle_armor
  static Future<void> _migrateToV3(LocalStorage storage) async {
    const idRemap = <String, String>{
      'acc_glasses': 'acc_necklace',
      'acc_hat': 'acc_wizard_hat',
      'acc_bow': 'acc_wing_decorations',
      'acc_shield': 'acc_battle_armor',
    };

    final profile = storage.getProfile();

    final newOwned = (profile.ownedCosmetics)
        .where((id) => id.isNotEmpty)
        .map((id) => idRemap[id] ?? id)
        .toList();

    final newEquipped = (profile.equippedAccessories)
        .where((id) => id.isNotEmpty)
        .map((id) => idRemap[id] ?? id)
        .toList();

    await storage.saveProfile(profile.copyWith(
      ownedCosmetics: newOwned,
      equippedAccessories: newEquipped,
      schemaVersion: 3,
    ));
  }
}
