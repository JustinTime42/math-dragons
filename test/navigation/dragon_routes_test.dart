import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/navigation/dragon_routes.dart';
import 'package:math_dragons/games/dragon_runes/dragon_runes_game.dart';
import 'package:math_dragons/games/fire_trail/fire_trail_game.dart';
import 'package:math_dragons/games/dragon_eggs/dragon_eggs_game.dart';
import 'package:math_dragons/games/dragons_feast/dragons_feast_game.dart';

void main() {
  group('DragonPageRoute.gameScreenForId', () {
    test('returns DragonRunesScreen for dragon_runes', () {
      final widget = DragonPageRoute.gameScreenForId('dragon_runes');
      expect(widget, isA<DragonRunesScreen>());
    });

    test('returns FireTrailScreen for fire_trail', () {
      final widget = DragonPageRoute.gameScreenForId('fire_trail');
      expect(widget, isA<FireTrailScreen>());
    });

    test('returns DragonEggsScreen for dragon_eggs', () {
      final widget = DragonPageRoute.gameScreenForId('dragon_eggs');
      expect(widget, isA<DragonEggsScreen>());
    });

    test('returns DragonsFeastScreen for dragons_feast', () {
      final widget = DragonPageRoute.gameScreenForId('dragons_feast');
      expect(widget, isA<DragonsFeastScreen>());
    });

    test('throws ArgumentError for unknown game ID', () {
      expect(
        () => DragonPageRoute.gameScreenForId('unknown_game'),
        throwsArgumentError,
      );
    });
  });
}
