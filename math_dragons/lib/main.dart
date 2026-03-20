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
  final storage = LocalStorage();
  await storage.initialize();

  runApp(MathDragonsApp(storage: storage));
}
