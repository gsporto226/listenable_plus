import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenable_plus/features/switch_map/implementations/switch_map_notifier.dart';

void main() {
  group('SwitchMapNotifier', () {
    test('switches inner streams properly', () async {
      final source = ValueNotifier<int>(1);

      final controller1 = StreamController<String>.broadcast();
      final controller2 = StreamController<String>.broadcast();

      Stream<String> mapper(int value) {
        if (value == 1) return controller1.stream;
        return controller2.stream;
      }

      final switchMapped = SwitchMapNotifier<String, int>(
        'initial',
        source: source,
        mapper: mapper,
      );

      expect(switchMapped.value, 'initial');

      int notifyCount = 0;
      switchMapped.addListener(() {
        notifyCount++;
      });

      await controller1.addStream(Stream.value('from 1'));
      expect(switchMapped.value, 'from 1');
      expect(notifyCount, 1);

      source.value = 2;

      await controller1.addStream(Stream.value('from 1 again - should be completely ignored'));
      expect(switchMapped.value, 'from 1');

      await controller2.addStream(Stream.value('from 2'));
      expect(switchMapped.value, 'from 2');

      switchMapped.dispose();
      source.dispose();
      await controller1.close();
      await controller2.close();
    });

    test('it cleans up subscription when disposed or unused', () async {
      final source = ValueNotifier<int>(1);

      final controller = StreamController<String>.broadcast();
      final switchMapped = SwitchMapNotifier<String, int>(
        'initial',
        source: source,
        mapper: (_) => controller.stream,
      );

      void noop() {}

      switchMapped.addListener(noop);
      await controller.addStream(Stream.value('data'));
      expect(switchMapped.value, 'data');

      switchMapped.dispose();
      source.dispose();

      expect(controller.hasListener, isFalse);

      await controller.close();
    });
  });
}
