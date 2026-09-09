import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/debounce/_implementations/debounce_time.dart';

void main() {
  group('DebounceTimeValueNotifier', () {
    test('emits value immediately upon creation', () {
      final source = ValueNotifier<int>(0);
      final debounce = DebounceTimeValueNotifier<int>(
        source.value,
        source: source,
        duration: const Duration(milliseconds: 100),
      );

      expect(debounce.value, 0);
    });

    test('debounces state changes', () {
      fakeAsync((async) {
        final source = ValueNotifier<int>(0);
        final debounce = DebounceTimeValueNotifier<int>(
          source.value,
          source: source,
          duration: const Duration(milliseconds: 100),
        );

        final values = <int>[];
        debounce.addListener(() {
          values.add(debounce.value);
        });

        source
          ..value = 1
          ..value = 2
          ..value = 3;

        expect(values, isEmpty, reason: 'Should not emit immediately');

        async.elapse(const Duration(milliseconds: 150));

        expect(values, equals([3]), reason: 'Should emit only the last value after duration');
        expect(debounce.value, 3);
      });
    });

    test('cancels timer on dispose', () {
      fakeAsync((async) {
        final source = ValueNotifier<int>(0);
        final debounce = DebounceTimeValueNotifier<int>(
          source.value,
          source: source,
          duration: const Duration(milliseconds: 100),
        );

        final values = <int>[];
        debounce.addListener(() {
          values.add(debounce.value);
        });

        source.value = 1;

        debounce.dispose();

        async.elapse(const Duration(milliseconds: 150));

        expect(values, isEmpty, reason: 'Should not emit because it was disposed');
      });
    });
  });
}
