import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/models/cosmetic_catalog.dart';

void main() {
  group('CosmeticCatalog', () {
    test('all catalog items have unique IDs', () {
      final allItems = [
        ...CosmeticCatalog.colors,
        ...CosmeticCatalog.accessories,
        ...CosmeticCatalog.backgrounds,
      ];
      final ids = allItems.map((item) => item.id).toSet();
      expect(ids.length, allItems.length);
    });

    test('CosmeticCatalog.colors has 8 items', () {
      expect(CosmeticCatalog.colors.length, 8);
    });

    test('CosmeticCatalog.accessories has 6 items', () {
      expect(CosmeticCatalog.accessories.length, 6);
    });

    test('findById returns correct color item', () {
      final item = CosmeticCatalog.findById('color_crimson');
      expect(item, isNotNull);
      expect(item!.name, 'Crimson');
      expect(item.type, CosmeticType.color);
    });

    test('findById returns correct accessory item', () {
      final item = CosmeticCatalog.findById('acc_crown');
      expect(item, isNotNull);
      expect(item!.name, 'Crown');
      expect(item.type, CosmeticType.accessory);
    });

    test('findById returns null for unknown ID', () {
      final item = CosmeticCatalog.findById('nonexistent');
      expect(item, isNull);
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

    test('all items have non-empty names', () {
      final allItems = [
        ...CosmeticCatalog.colors,
        ...CosmeticCatalog.accessories,
        ...CosmeticCatalog.backgrounds,
      ];
      for (final item in allItems) {
        expect(item.name, isNotEmpty, reason: '${item.id} should have a non-empty name');
      }
    });

    test('all items have imagePath set', () {
      final allItems = [
        ...CosmeticCatalog.colors,
        ...CosmeticCatalog.accessories,
        ...CosmeticCatalog.backgrounds,
      ];
      for (final item in allItems) {
        expect(item.imagePath, isNotNull, reason: '${item.id} should have an imagePath');
      }
    });

    test('color items have a previewColor set', () {
      for (final item in CosmeticCatalog.colors) {
        expect(item.previewColor, isNotNull,
            reason: '${item.id} should have a previewColor');
      }
    });

    test('color items cost between 50-200 scales', () {
      for (final item in CosmeticCatalog.colors) {
        expect(item.cost, inInclusiveRange(50, 200),
            reason: '${item.id} cost should be 50-200, got ${item.cost}');
      }
    });

    test('accessory items cost between 100-500 scales', () {
      for (final item in CosmeticCatalog.accessories) {
        expect(item.cost, inInclusiveRange(100, 500),
            reason: '${item.id} cost should be 100-500, got ${item.cost}');
      }
    });

    test('all accessories have a slot assigned', () {
      for (final item in CosmeticCatalog.accessories) {
        expect(item.slot, isNotNull,
            reason: '${item.id} should have a slot assigned');
      }
    });

    test('color items have no slot assigned', () {
      for (final item in CosmeticCatalog.colors) {
        expect(item.slot, isNull,
            reason: '${item.id} should not have a slot');
      }
    });

    test('each slot has at most 2 accessories', () {
      final slotCounts = <AccessorySlot, int>{};
      for (final item in CosmeticCatalog.accessories) {
        slotCounts[item.slot!] = (slotCounts[item.slot!] ?? 0) + 1;
      }
      for (final entry in slotCounts.entries) {
        expect(entry.value, lessThanOrEqualTo(2),
            reason: 'Slot ${entry.key} has ${entry.value} items, expected <= 2');
      }
    });

    test('CosmeticCatalog.backgrounds has 8 items', () {
      expect(CosmeticCatalog.backgrounds.length, 8);
    });

    test('all background items have CosmeticType.background', () {
      for (final item in CosmeticCatalog.backgrounds) {
        expect(item.type, CosmeticType.background);
      }
    });

    test('background items cost between 75-150 scales', () {
      for (final item in CosmeticCatalog.backgrounds) {
        expect(item.cost, inInclusiveRange(75, 150),
            reason: '${item.id} cost should be 75-150, got ${item.cost}');
      }
    });

    test('background items have no slot assigned', () {
      for (final item in CosmeticCatalog.backgrounds) {
        expect(item.slot, isNull,
            reason: '${item.id} should not have a slot');
      }
    });

    test('findById returns correct background item', () {
      final item = CosmeticCatalog.findById('bg_crimson');
      expect(item, isNotNull);
      expect(item!.name, 'Volcanic Landscape');
      expect(item.type, CosmeticType.background);
    });

    test('slot assignments match expected mapping', () {
      expect(CosmeticCatalog.findById('acc_crown')!.slot,
          AccessorySlot.headTop);
      expect(CosmeticCatalog.findById('acc_wizard_hat')!.slot,
          AccessorySlot.headTop);
      expect(CosmeticCatalog.findById('acc_scarf')!.slot,
          AccessorySlot.neck);
      expect(CosmeticCatalog.findById('acc_necklace')!.slot,
          AccessorySlot.neck);
      expect(CosmeticCatalog.findById('acc_battle_armor')!.slot,
          AccessorySlot.chest);
      expect(CosmeticCatalog.findById('acc_wing_decorations')!.slot,
          AccessorySlot.wings);
    });
  });
}
