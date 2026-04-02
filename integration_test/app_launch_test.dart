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

    // The hub screen has a persistent dragon breathing animation
    // (AnimationController.repeat), so pumpAndSettle will never return.
    // pump with a fixed duration is the correct pattern for apps with
    // ongoing animations — it advances frames without waiting for idle.
    await tester.pump(const Duration(seconds: 3));

    // App should have rendered a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify the widget tree built without crashing — the Scaffold
    // from HubScreen should be present
    expect(find.byType(Scaffold), findsWidgets);
  });
}
