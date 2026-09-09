import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

class _TestMappedNotifier extends SourceMappedValueListenable<int, String> {
  _TestMappedNotifier(ValueNotifier<int> source) : super(source.value.toString(), source: source);

  @override
  void onSourceChanged() {
    value = source.value.toString();
  }
}

void main() {
  group('SourceMappedValueNotifier', () {
    test('subscribes to source immediately on creation', () {
      final sourceNotifier = ValueNotifier<int>(1);
      final mappedNotifier = _TestMappedNotifier(sourceNotifier);

      expect(mappedNotifier.value, '1');

      mappedNotifier.dispose();
      sourceNotifier.dispose();
    });

    test('updates value when source changes', () {
      final sourceNotifier = ValueNotifier<int>(1);
      final mappedNotifier = _TestMappedNotifier(sourceNotifier);

      sourceNotifier.value = 2;
      expect(mappedNotifier.value, '2');

      mappedNotifier.dispose();
      sourceNotifier.dispose();
    });

    test('unsubscribes from source when disposed', () {
      final sourceNotifier = ValueNotifier<int>(1);
      _TestMappedNotifier(sourceNotifier).dispose();

      sourceNotifier.dispose();
    });
  });
}
