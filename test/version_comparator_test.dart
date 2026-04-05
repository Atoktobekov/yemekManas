import 'package:ManasYemek/features/update/domain/services/version_comparator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VersionComparator', () {
    const comparator = VersionComparator();

    test('returns true for newer major version', () {
      expect(comparator.isNewer('2.0.0', '1.9.9'), isTrue);
    });

    test('returns true for newer patch version', () {
      expect(comparator.isNewer('1.0.1', '1.0.0'), isTrue);
    });

    test('returns false for same version', () {
      expect(comparator.isNewer('1.0.0', '1.0.0'), isFalse);
    });

    test('returns false for invalid versions', () {
      expect(comparator.isNewer('abc', '1.0.0'), isFalse);
    });
  });
}
