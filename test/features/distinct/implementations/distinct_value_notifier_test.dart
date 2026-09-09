import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/distinct/implementations/distinct_value_notifier.dart';

void main() {
  group('DistinctValueNotifier', () {
    test('updates value only when distinct', () {
      final source = ValueNotifier<int>(1);
      final distinct = DistinctValueNotifier<int>(source.value, source: source);

      int notifies = 0;
      distinct.addListener(() {
        notifies++;
      });

      expect(distinct.value, 1);
      expect(notifies, 0);

      source.value = 1;
      expect(distinct.value, 1);
      expect(notifies, 0);

      source.value = 2;
      expect(distinct.value, 2);
      expect(notifies, 1);

      distinct.dispose();
      source.dispose();
    });

    test('uses custom equals function', () {
      final source = ValueNotifier<String>('a');
      final distinct = DistinctValueNotifier<String>(
        source.value,
        source: source,
        equals: (prev, next) => prev.toLowerCase() == next.toLowerCase(),
      );

      int notifies = 0;
      distinct.addListener(() {
        notifies++;
      });

      source.value = 'A';
      expect(distinct.value, 'a');
      expect(notifies, 0);

      source.value = 'b';
      expect(distinct.value, 'b');
      expect(notifies, 1);

      distinct.dispose();
      source.dispose();
    });
  });
}
