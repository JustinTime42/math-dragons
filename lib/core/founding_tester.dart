import '../storage/local_storage.dart';

/// Records whether this device belongs to a "founding family": anyone who
/// installed Math Dragons during the free beta. Beta families get any future
/// paid unlock free (decision 2026-10-19, see marketing/PLAN.md).
///
/// The flag lives only on this device, in the app_meta box. Nothing is sent
/// anywhere. When paid features ship, the unlock itself must go through the
/// stores' own mechanisms (StoreKit AppTransaction / Apple offer codes,
/// Google Play promo codes), never a self-issued code (App Store 3.1.1).
class FoundingTester {
  static const String flagKey = 'founding_tester';
  static const String sinceKey = 'founding_tester_since';

  /// Installs before this instant count as founding. Placeholder far in the
  /// future while everything is free; set it to the real paid-launch date in
  /// the release that introduces paid features.
  static final DateTime cutoff = DateTime.utc(2099, 1, 1);

  /// Marks this device as founding if it qualifies. Safe to call on every
  /// launch: once set, the flag is never cleared or re-dated.
  ///
  /// A device qualifies if it is launched before [cutoff], or if its profile
  /// was created before [cutoff] (so beta installs that first open the app
  /// after launch day still count).
  static Future<bool> record(
    LocalStorage storage, {
    DateTime? now,
    DateTime? cutoffOverride,
  }) async {
    if (isFounding(storage)) return true;

    final limit = cutoffOverride ?? cutoff;
    final current = (now ?? DateTime.now()).toUtc();
    final createdAt = storage.getProfile().createdAt.toUtc();

    if (current.isBefore(limit) || createdAt.isBefore(limit)) {
      await storage.setMeta(flagKey, true);
      await storage.setMeta(sinceKey, current.toIso8601String());
      return true;
    }
    return false;
  }

  static bool isFounding(LocalStorage storage) =>
      storage.getMeta(flagKey) == true;
}
