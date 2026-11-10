import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/core/player_profile.dart';
import 'package:math_dragons/hub/settings_screen.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import 'package:math_dragons/storage/local_storage.dart';

class _MockStorage extends LocalStorage {
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
}

Widget _app() => MultiProvider(
      providers: [Provider<LocalStorage>.value(value: _MockStorage())],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: SettingsScreen(),
      ),
    );

/// The settings ListView (the name TextField has its own Scrollable).
final _list = find
    .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
    .first;

void main() {
  testWidgets('About shows the real app version and build number',
      (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'Math Dragons',
      packageName: 'com.mathdragonsgame.mathDragons',
      version: '1.2.3',
      buildNumber: '45',
      buildSignature: '',
    );
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Version 1.2.3 (45)'), 200,
        scrollable: _list);
    expect(find.text('Version 1.2.3 (45)'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsNothing);
  });
}
