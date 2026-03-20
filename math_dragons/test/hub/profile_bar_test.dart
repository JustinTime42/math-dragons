import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/hub/profile_bar.dart';

void main() {
  group('ProfileBar.formatScales', () {
    test('formats 0 correctly', () {
      expect(ProfileBar.formatScales(0), '0');
    });

    test('formats numbers under 1000 without commas', () {
      expect(ProfileBar.formatScales(1), '1');
      expect(ProfileBar.formatScales(42), '42');
      expect(ProfileBar.formatScales(999), '999');
    });

    test('formats 1000 with comma', () {
      expect(ProfileBar.formatScales(1000), '1,000');
    });

    test('formats 5 digits with comma', () {
      expect(ProfileBar.formatScales(12345), '12,345');
    });

    test('formats 7 digits with two commas', () {
      expect(ProfileBar.formatScales(1234567), '1,234,567');
    });
  });

  group('ProfileBar.evolutionNames', () {
    test('stage 0 is Egg', () {
      expect(ProfileBar.evolutionNames[0], 'Egg');
    });

    test('stage 1 is Hatchling', () {
      expect(ProfileBar.evolutionNames[1], 'Hatchling');
    });

    test('stage 2 is Fledgling', () {
      expect(ProfileBar.evolutionNames[2], 'Fledgling');
    });

    test('stage 3 is Young Dragon', () {
      expect(ProfileBar.evolutionNames[3], 'Young Dragon');
    });

    test('stage 4 is Adult Dragon', () {
      expect(ProfileBar.evolutionNames[4], 'Adult Dragon');
    });

    test('stage 5 is Elder Dragon', () {
      expect(ProfileBar.evolutionNames[5], 'Elder Dragon');
    });

    test('out of range stage is clamped', () {
      // This mirrors the clamping behavior in ProfileBar.build
      const stage = 6;
      final clamped = stage.clamp(0, ProfileBar.evolutionNames.length - 1);
      expect(ProfileBar.evolutionNames[clamped], 'Elder Dragon');
    });
  });
}
