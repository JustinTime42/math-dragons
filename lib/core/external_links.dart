import 'package:url_launcher/url_launcher.dart';

/// Every URL the app can open. All of them sit behind the parental gate
/// (App Store guideline 1.3: Kids Category apps may only link out from a
/// designated area behind a parental gate).
class ExternalLinks {
  static final Uri privacyPolicy = Uri.parse('https://playmathdragons.com/privacy');
  static final Uri support = Uri.parse('https://playmathdragons.com/support');
  static final Uri feedback = Uri.parse('https://playmathdragons.com/feedback');

  /// Opens a link in the system browser. Replaceable in tests.
  static Future<bool> Function(Uri uri) launcher =
      (uri) => launchUrl(uri, mode: LaunchMode.externalApplication);
}
