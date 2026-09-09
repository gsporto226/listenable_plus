import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/_implementations/value_listenable_extensions.dart';
import 'package:listenable_plus/features/switch_listen/implementations/switch_listen_notifier.dart';

void main() {
  group('SwitchListenNotifier', () {
    test('emits the initial inner value and tracks inner updates', () {
      final source = ValueNotifier<int>(1);
      final inner1 = ValueNotifier<String>('one');

      final switched = SwitchListenNotifier<String, int>(
        'initial',
        source: source,
        mapper: (_) => inner1,
      );

      expect(switched.value, 'one', reason: 'construction emits the inner current value');

      int notifyCount = 0;
      switched.addListener(() => notifyCount++);

      inner1.value = 'one again';
      expect(switched.value, 'one again');
      expect(notifyCount, 1);

      switched.dispose();
      source.dispose();
    });

    test('switches inner listenables and drops superseded updates', () {
      final source = ValueNotifier<int>(1);
      final inner1 = ValueNotifier<String>('from 1');
      final inner2 = ValueNotifier<String>('from 2');

      final switched = SwitchListenNotifier<String, int>(
        'initial',
        source: source,
        mapper: (v) => v == 1 ? inner1 : inner2,
      );

      expect(switched.value, 'from 1');

      source.value = 2;
      expect(switched.value, 'from 2', reason: 'switching emits the new inner current value');

      // update from the superseded inner is dropped
      inner1.value = 'from 1 again — should be ignored';
      expect(switched.value, 'from 2');

      // updates from the active inner propagate
      inner2.value = 'from 2 again';
      expect(switched.value, 'from 2 again');

      switched.dispose();
      source.dispose();
    });

    test('detaches the inner when the last listener is removed', () {
      final source = ValueNotifier<int>(1);
      final inner = ValueNotifier<String>('one');

      final switched = SwitchListenNotifier<String, int>(
        'initial',
        source: source,
        mapper: (_) => inner,
      );

      // construction subscribed to the inner
      inner.value = 'two';
      expect(switched.value, 'two');

      void noop() {}
      switched.addListener(noop);

      switched.removeListener(noop);

      inner.value = 'three';
      expect(switched.value, 'two', reason: 'inner detached after last outer listener removed');

      switched.dispose();
      source.dispose();
    });

    test('does not update after dispose', () {
      final source = ValueNotifier<int>(1);
      final inner = ValueNotifier<String>('one');

      final switched = SwitchListenNotifier<String, int>(
        'initial',
        source: source,
        mapper: (_) => inner,
      );

      switched.dispose();
      expect(() => inner.value = 'changed', returnsNormally,
          reason: 'inner listener detached on dispose');

      source.dispose();
    });
  });

  group('select', () {
    test('derives a field listenable and tracks updates', () {
      final model = ValueNotifier<_FakeModel>(const _FakeModel(title: 'a', count: 1));

      final $title = model.select((m) => m.title);
      expect($title.value, 'a');

      int notifyCount = 0;
      $title.addListener(() => notifyCount++);

      model.value = model.value.copyWith(count: 2);
      expect(notifyCount, 0, reason: 'selected field did not change');

      model.value = model.value.copyWith(title: 'b');
      expect($title.value, 'b');
      expect(notifyCount, 1);

      model.dispose();
    });
  });
}

class _FakeModel {
  const _FakeModel({required this.title, required this.count});

  final String title;
  final int count;

  _FakeModel copyWith({String? title, int? count}) =>
      _FakeModel(title: title ?? this.title, count: count ?? this.count);
}
