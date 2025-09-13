import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/common/utils/app_utils.dart';

void main() {
  group('isValidUrl Tests', () {
    test('When call isValidUrl with valid URL should return true', () {
      final result = AppUtils.isValidUrl('https://www.example.com');

      expect(result, true);
    });

    test('When call isValidUrl with invalid URL should return false', () {
      final result = AppUtils.isValidUrl('invalid-url');

      expect(result, false);
    });

    test('When call isValidUrl with empty string should return false', () {
      final result = AppUtils.isValidUrl('');

      expect(result, false);
    });
  });
}
