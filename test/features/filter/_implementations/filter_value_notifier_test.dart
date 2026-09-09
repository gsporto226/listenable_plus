import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/filter/_implementations/filter_value_notifier.dart';

void main() {
  group('FilterValueNotifier', () {
    test('passes values that meet the criteria', () {
      final source = ValueNotifier<int>(1);
      final filter = FilterValueNotifier<int, int>(
        source.value,
        source: source,
        filter: (val) => val.isEven ? FilterResult.pass(val) : FilterResult.fail(),
      );

      final values = <int>[];
      filter.addListener(() {
        values.add(filter.value);
      });

      source.value = 2;
      expect(filter.value, 2);
      expect(values, equals([2]));

      source.value = 3;
      expect(filter.value, 2);
      expect(values, equals([2]));

      source.value = 4;
      expect(filter.value, 4);
      expect(values, equals([2, 4]));
    });

    test('transforms values that meet the criteria', () {
      final source = ValueNotifier<int>(1);
      final filter = FilterValueNotifier<String, int>(
        'odd',
        source: source,
        filter: (val) => val.isEven ? FilterResult.pass(val.toString()) : FilterResult.fail(),
      );

      final values = <String>[];
      filter.addListener(() {
        values.add(filter.value);
      });

      source.value = 2;
      expect(filter.value, '2');
      expect(values, equals(['2']));

      source.value = 3;
      expect(filter.value, '2');
      expect(values, equals(['2']));

      source.value = 4;
      expect(filter.value, '4');
      expect(values, equals(['2', '4']));
    });

    test('initializes with the provided value', () {
      final source = ValueNotifier<int>(1);
      final filter = FilterValueNotifier<int, int>(
        0,
        source: source,
        filter: (val) => val.isEven ? FilterResult.pass(val) : FilterResult.fail(),
      );

      expect(filter.value, 0);
    });
  });
}
