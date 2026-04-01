import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:math_dragons/app.dart';
import 'package:math_dragons/storage/local_storage.dart';

/// Smoke test: verifies the app launches without crashing.
/// This is the minimum bar for App Store submission — if this fails,
/// Apple will reject the build (Guideline 2.1a).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorage storage;

  setUp(() async {
    storage = LocalStorage();
    await storage.initialize();
  });

  tearDown(() async {
    await storage.close();
  });

  testWidgets('app launches and renders home screen', (tester) async {
    await tester.pumpWidget(MathDragonsApp(storage: storage));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // App should have rendered a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);

    // The hub screen should be visible (main menu)
    expect(find.text('Math Dragons'), findsWidgets);
  });
}
