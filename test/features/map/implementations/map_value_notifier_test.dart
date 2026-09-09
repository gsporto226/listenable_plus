import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/map/implementations/map_value_notifier.dart';

void main() {
  group('MappedValueNotifier', () {
    test('maps source value correctly', () {
      final source = ValueNotifier<int>(1);
      final mapped = MappedValueNotifier<String, int>(
        source.value.toString(),
        source: source,
        reverseMapper: (current, value) => int.parse(value),
        mapper: (value) => value.toString(),
      );

      expect(mapped.value, '1');

      source.value = 2;
      expect(mapped.value, '2');

      source.value = 10;
      expect(mapped.value, '10');

      mapped.dispose();
      source.dispose();
    });
  });
}
