import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/l10n/app_localizations.dart';
import 'package:math_dragons/monetization/parental_gate.dart';

Widget _host(void Function(BuildContext) onPressed) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: Builder(
      builder: (context) => TextButton(
        onPressed: () => onPressed(context),
        child: const Text('open'),
      ),
    ),
  );
}

void main() {
  group('ParentalGateChallenge', () {
    test('factors are two-digit, 13..29, never multiples of 10', () {
      final random = Random(42);
      for (var i = 0; i < 1000; i++) {
        final c = ParentalGateChallenge.generate(random);
        for (final n in [c.a, c.b]) {
          expect(n, inInclusiveRange(13, 29));
          expect(n % 10, isNot(0));
        }
        expect(c.answer, c.a * c.b);
      }
    });

    test('check accepts only the exact product', () {
      const c = ParentalGateChallenge(23, 17);
      expect(c.check('391'), isTrue);
      expect(c.check(' 391 '), isTrue);
      expect(c.check('390'), isFalse);
      expect(c.check(''), isFalse);
      expect(c.check('abc'), isFalse);
    });
  });

  group('ParentalGate.show', () {
    Future<bool?> run(WidgetTester tester, String? answer,
        {bool cancel = false}) async {
      bool? result;
      await tester.pumpWidget(_host((context) async {
        result = await ParentalGate.show(context, random: Random(7));
      }));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Grown-ups only'), findsOneWidget);
      if (cancel) {
        await tester.tap(find.text('Cancel'));
      } else {
        await tester.enterText(
            find.byKey(const Key('parental_gate_input')), answer!);
        await tester.tap(find.byKey(const Key('parental_gate_submit')));
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));
      return result;
    }

    testWidgets('correct answer passes', (tester) async {
      final expected = ParentalGateChallenge.generate(Random(7)).answer;
      expect(await run(tester, '$expected'), isTrue);
    });

    testWidgets('wrong answer fails and closes', (tester) async {
      final expected = ParentalGateChallenge.generate(Random(7)).answer;
      expect(await run(tester, '${expected + 1}'), isFalse);
      expect(find.text('Grown-ups only'), findsNothing);
    });

    testWidgets('cancel fails', (tester) async {
      expect(await run(tester, null, cancel: true), isFalse);
    });
  });
}
