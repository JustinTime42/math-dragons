import 'package:flutter_test/flutter_test.dart';
import 'package:math_dragons/storage/migration.dart';

void main() {
  group('MigrationRunner', () {
    test('currentVersion is 3', () {
      expect(MigrationRunner.currentVersion, 3);
    });
  });
}
