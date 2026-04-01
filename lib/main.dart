import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF1A1A2E),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize persistent storage before building widget tree
  try {
    final storage = LocalStorage();
    await storage.initialize();
    runApp(MathDragonsApp(storage: storage));
  } catch (e, stackTrace) {
    debugPrint('Fatal error during app initialization: $e');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const _InitErrorApp());
  }
}

/// Fallback app shown when initialization fails critically.
class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.white70, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Math Dragons failed to start.\nPlease try reinstalling the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
