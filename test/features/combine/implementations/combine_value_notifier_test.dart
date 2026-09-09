import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/combine/implementations/combine_value_notifier.dart';

void main() {
  group('CombineLatestValueNotifier', () {
    test('combine multiple notifiers', () {
      final source1 = ValueNotifier<int>(1);
      final source2 = ValueNotifier<int>(2);
      final source3 = ValueNotifier<int>(3);

      final combined = CombineLatestValueNotifier.combine(
        [source1, source2, source3],
        (values) => values.fold(0, (sum, val) => sum + val),
      );

      expect(combined.value, 6);

      source1.value = 10;
      expect(combined.value, 15);

      source2.value = 20;
      expect(combined.value, 33);

      source3.value = 30;
      expect(combined.value, 60);

      combined.dispose();
      source1.dispose();
      source2.dispose();
      source3.dispose();
    });

    test('combine2 combines two notifiers', () {
      final source1 = ValueNotifier<int>(1);
      final source2 = ValueNotifier<int>(2);

      final combined = CombineLatestValueNotifier.combine2(
        source1,
        source2,
        (a, b) => a + b,
      );

      expect(combined.value, 3);

      source1.value = 10;
      expect(combined.value, 12);

      source2.value = 20;
      expect(combined.value, 30);

      combined.dispose();
      source1.dispose();
      source2.dispose();
    });

    test('combine3 combines three notifiers', () {
      final source1 = ValueNotifier<int>(1);
      final source2 = ValueNotifier<int>(2);
      final source3 = ValueNotifier<int>(3);

      final combined = CombineLatestValueNotifier.combine3(
        source1,
        source2,
        source3,
        (a, b, c) => a + b + c,
      );

      expect(combined.value, 6);

      source2.value = 10;
      expect(combined.value, 14);

      combined.dispose();
      source1.dispose();
      source2.dispose();
      source3.dispose();
    });
  });
}
