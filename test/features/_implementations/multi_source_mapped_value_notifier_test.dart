import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/_implementations/multi_source_mapped_value_notifier.dart';

class _TestMultiMappedNotifier extends MultiSourceMappedValueNotifier<String> {
  _TestMultiMappedNotifier(List<ValueNotifier<int>> sources) : super('', sources: sources);

  int lastChangedIndex = -1;

  @override
  void onSourcesChanged(int changedSourceIndex) {
    lastChangedIndex = changedSourceIndex;
    final List<int> values = sources.map((s) => (s as ValueNotifier<int>).value).toList();
    value = values.join('-');
  }
}

void main() {
  group('MultiSourceMappedValueNotifier', () {
    test('subscribes to all sources immediately on creation', () {
      final source1 = ValueNotifier<int>(1);
      final source2 = ValueNotifier<int>(2);

      final mappedNotifier = _TestMultiMappedNotifier([source1, source2]);

      expect(mappedNotifier.value, '1-2');

      mappedNotifier.dispose();
      source1.dispose();
      source2.dispose();
    });

    test('updates value and passes correct index when a source changes', () {
      final source1 = ValueNotifier<int>(1);
      final source2 = ValueNotifier<int>(2);

      final mappedNotifier = _TestMultiMappedNotifier([source1, source2]);

      expect(mappedNotifier.lastChangedIndex, 1);

      source1.value = 10;
      expect(mappedNotifier.value, '10-2');
      expect(mappedNotifier.lastChangedIndex, 0);

      source2.value = 20;
      expect(mappedNotifier.value, '10-20');
      expect(mappedNotifier.lastChangedIndex, 1);

      mappedNotifier.dispose();
      source1.dispose();
      source2.dispose();
    });

    test('unsubscribes from all sources when disposed', () {
      final source1 = ValueNotifier<int>(1);
      final source2 = ValueNotifier<int>(2);

      _TestMultiMappedNotifier([source1, source2]).dispose();

      source1.dispose();
      source2.dispose();
    });
  });
}
