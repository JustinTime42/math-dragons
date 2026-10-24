import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:math_dragons/core/external_links.dart';
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

/// Reads "To continue, what is A × B?" off the dialog and returns A*B.
int _answerOnScreen(WidgetTester tester) {
  final text = tester
      .widgetList<Text>(find.textContaining('To continue'))
      .first
      .data!;
  final m = RegExp(r'(\d+) × (\d+)').firstMatch(text)!;
  return int.parse(m.group(1)!) * int.parse(m.group(2)!);
}

void main() {
  late List<Uri> launched;
  late Future<bool> Function(Uri) original;

  setUp(() {
    launched = [];
    original = ExternalLinks.launcher;
    ExternalLinks.launcher = (uri) async {
      launched.add(uri);
      return true;
    };
  });

  tearDown(() => ExternalLinks.launcher = original);

  Future<void> tapLink(WidgetTester tester, String label) async {
    await tester.pumpWidget(_app());
    await tester.scrollUntilVisible(find.text(label), 200, scrollable: _list);
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('For Parents section lists all three links', (tester) async {
    await tester.pumpWidget(_app());
    for (final label in [
      'FOR PARENTS', // section headers render uppercase
      'Privacy policy',
      'Send feedback',
      'Help and support',
    ]) {
      await tester.scrollUntilVisible(find.text(label), 100, scrollable: _list);
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('link does not open if the gate is cancelled', (tester) async {
    await tapLink(tester, 'Privacy policy');
    expect(find.text('Grown-ups only'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(launched, isEmpty);
  });

  testWidgets('link does not open on a wrong answer', (tester) async {
    await tapLink(tester, 'Send feedback');
    final wrong = _answerOnScreen(tester) + 1;
    await tester.enterText(
        find.byKey(const Key('parental_gate_input')), '$wrong');
    await tester.tap(find.byKey(const Key('parental_gate_submit')));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(launched, isEmpty);
  });

  for (final (label, uri) in [
    ('Privacy policy', ExternalLinks.privacyPolicy),
    ('Send feedback', ExternalLinks.feedback),
    ('Help and support', ExternalLinks.support),
  ]) {
    testWidgets('"$label" opens $uri after the gate', (tester) async {
      await tapLink(tester, label);
      await tester.enterText(find.byKey(const Key('parental_gate_input')),
          '${_answerOnScreen(tester)}');
      await tester.tap(find.byKey(const Key('parental_gate_submit')));
      await tester.pumpAndSettle();
      expect(launched, [uri]);
    });
  }

  test('all links point at playmathdragons.com over https', () {
    for (final uri in [
      ExternalLinks.privacyPolicy,
      ExternalLinks.feedback,
      ExternalLinks.support,
    ]) {
      expect(uri.scheme, 'https');
      expect(uri.host, 'playmathdragons.com');
    }
  });
}
