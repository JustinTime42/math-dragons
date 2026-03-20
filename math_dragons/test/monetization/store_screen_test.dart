import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/models/cosmetic_catalog.dart';

void main() {
  group('CosmeticCatalog', () {
    test('all catalog items have unique IDs', () {
      final allItems = [...CosmeticCatalog.colors, ...CosmeticCatalog.accessories];
      final ids = allItems.map((item) => item.id).toSet();
      expect(ids.length, allItems.length);
    });

    test('CosmeticCatalog.colors has 8 items', () {
      expect(CosmeticCatalog.colors.length, 8);
    });

    test('CosmeticCatalog.accessories has 6 items', () {
      expect(CosmeticCatalog.accessories.length, 6);
    });

    test('color items cost between 50-200 scales', () {
      for (final item in CosmeticCatalog.colors) {
        expect(
          item.cost,
          inInclusiveRange(50, 200),
          reason: '${item.id} cost should be 50-200, got ${item.cost}',
        );
      }
    });

    test('accessory items cost between 100-500 scales', () {
      for (final item in CosmeticCatalog.accessories) {
        expect(
          item.cost,
          inInclusiveRange(100, 500),
          reason: '${item.id} cost should be 100-500, got ${item.cost}',
        );
      }
    });

    test('all items have non-empty names', () {
      final allItems = [...CosmeticCatalog.colors, ...CosmeticCatalog.accessories];
      for (final item in allItems) {
        expect(item.name, isNotEmpty, reason: '${item.id} should have a non-empty name');
      }
    });

    test('all items have non-empty previewEmoji', () {
      final allItems = [...CosmeticCatalog.colors, ...CosmeticCatalog.accessories];
      for (final item in allItems) {
        expect(
          item.previewEmoji,
          isNotEmpty,
          reason: '${item.id} should have a non-empty previewEmoji',
        );
      }
    });

    test('all color items have CosmeticType.color', () {
      for (final item in CosmeticCatalog.colors) {
        expect(item.type, CosmeticType.color);
      }
    });

    test('all accessory items have CosmeticType.accessory', () {
      for (final item in CosmeticCatalog.accessories) {
        expect(item.type, CosmeticType.accessory);
      }
    });

    test('color items have a previewColor set', () {
      for (final item in CosmeticCatalog.colors) {
        expect(
          item.previewColor,
          isNotNull,
          reason: '${item.id} should have a previewColor',
        );
      }
    });
  });
}
