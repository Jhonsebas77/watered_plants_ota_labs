import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:watered_plants_ota_labs/core/utils/utils.dart';

void main() {
  group('toDateTime', () {
    test('parses dd/MM/yyyy dates', () {
      expect(toDateTime('15/10/2026'), DateTime(2026, 10, 15));
    });

    test('returns null instead of throwing for empty or invalid dates', () {
      expect(toDateTime(''), isNull);
      expect(toDateTime('not a date'), isNull);
      expect(toDateTime('31/02/2026'), isNull);
    });
  });

  group('decodeBase64Image', () {
    test('returns the same bytes instance for the same value', () {
      String encoded = base64Encode(Uint8List.fromList(<int>[1, 2, 3, 4]));
      Uint8List? first = decodeBase64Image(encoded);
      Uint8List? second = decodeBase64Image(encoded);
      expect(first, isNotNull);
      expect(identical(first, second), isTrue);
    });

    test('supports data URIs and rejects URLs', () {
      String encoded = base64Encode(Uint8List.fromList(<int>[9, 8, 7]));
      expect(decodeBase64Image('data:image/jpeg;base64,$encoded'), <int>[
        9,
        8,
        7,
      ]);
      expect(isBase64Image('https://example.com/plant.png'), isFalse);
    });
  });
}
