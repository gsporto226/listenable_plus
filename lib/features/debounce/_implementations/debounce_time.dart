import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

/// A [ValueListenable] that emits the latest value from the source [ValueListenable]
/// after a specified duration has passed since the last source value change.
class DebounceTimeValueNotifier<T> extends SourceMappedValueListenable<T, T> {
  /// Creates a [DebounceTimeValueNotifier] that emits the latest value from the source [ValueListenable]
  DebounceTimeValueNotifier(super.value, {required super.source, required this.duration});

  Timer? _timer;

  /// The duration to wait after the last source value change before emitting the new value.
  final Duration duration;

  @override
  void onSourceChanged() {
    _timer?.cancel();
    _timer = Timer(duration, () {
      value = source.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
