import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/hub/customize_screen.dart';
import 'package:math_dragons/storage/local_storage.dart';
import 'package:math_dragons/widgets/cosmetic_preview.dart';

/// Minimal mock of LocalStorage for widget tests.
class _MockStorage extends LocalStorage {
  PlayerProfile _profile;

  _MockStorage({PlayerProfile? profile})
      : _profile = profile ?? PlayerProfile(id: 'test');

  @override
  PlayerProfile getProfile() => _profile;

  @override
  Future<void> saveProfile(PlayerProfile profile) async {
    _profile = profile;
  }

  @override
  Future<PlayerProfile> updateProfile(
    PlayerProfile Function(PlayerProfile current) transform,
  ) async {
    _profile = transform(_profile);
    profileNotifier.value = _profile;
    return _profile;
  }
}

Widget _buildApp({required _MockStorage storage, String initialRoute = '/customize'}) {
  return MultiProvider(
    providers: [
      Provider<LocalStorage>.value(value: storage),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      routes: {
        '/customize': (context) => const CustomizeScreen(),
        '/store': (context) => const Scaffold(body: Text('Store')),
      },
      initialRoute: initialRoute,
    ),
  );
}

void main() {
  group('CustomizeScreen', () {
    testWidgets('shows empty wardrobe when no cosmetics owned', (tester) async {
      final storage = _MockStorage();

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      expect(find.text('Your wardrobe is empty!'), findsOneWidget);
      expect(find.text('Visit the Dragon Store to buy colors and accessories for your dragon.'), findsOneWidget);
    });

    testWidgets('shows CosmeticPreview at top', (tester) async {
      final storage = _MockStorage();

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      expect(find.byType(CosmeticPreview), findsOneWidget);
    });

    testWidgets('shows owned color items', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['color_crimson', 'color_sapphire'],
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      // Should show the two color names
      expect(find.text('Crimson'), findsOneWidget);
      expect(find.text('Sapphire'), findsOneWidget);
      // Should NOT show empty wardrobe
      expect(find.text('Your wardrobe is empty!'), findsNothing);
    });

    testWidgets('shows owned accessory items', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['acc_crown'],
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      expect(find.text('Crown'), findsOneWidget);
    });

    testWidgets('can equip a color by tapping', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['color_crimson'],
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      // Tap the Crimson tile
      await tester.tap(find.text('Crimson'));
      await tester.pumpAndSettle();

      // Profile should now have equippedColor set
      expect(storage.getProfile().equippedColor, 'color_crimson');
    });

    testWidgets('can unequip a color by tapping again', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['color_crimson'],
          equippedColor: 'color_crimson',
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      // Tap the Crimson tile to unequip
      await tester.tap(find.text('Crimson'));
      await tester.pumpAndSettle();

      expect(storage.getProfile().equippedColor, isNull);
    });

    testWidgets('can toggle accessory equip', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['acc_crown'],
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      // Tap to equip
      await tester.tap(find.text('Crown'));
      await tester.pumpAndSettle();
      expect(storage.getProfile().equippedAccessories, contains('acc_crown'));

      // Tap again to unequip
      await tester.tap(find.text('Crown'));
      await tester.pumpAndSettle();
      expect(storage.getProfile().equippedAccessories, isNot(contains('acc_crown')));
    });

    testWidgets('Visit Store button navigates to /store', (tester) async {
      final storage = _MockStorage();

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Visit Store'));
      await tester.pumpAndSettle();

      // Should have navigated to store
      expect(find.text('Store'), findsOneWidget);
    });

    testWidgets('shows Dragon Colors section header when colors owned', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['color_crimson'],
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      expect(find.text('Dragon Colors'), findsOneWidget);
    });

    testWidgets('shows Accessories section header when accessories owned', (tester) async {
      final storage = _MockStorage(
        profile: PlayerProfile(
          id: 'test',
          ownedCosmetics: ['acc_crown'],
        ),
      );

      await tester.pumpWidget(_buildApp(storage: storage));
      await tester.pumpAndSettle();

      expect(find.text('Accessories'), findsOneWidget);
    });
  });
}
