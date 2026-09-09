import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

/// A [ValueNotifier] that is the result of mapping the value of another
/// [ValueListenable] through a mapping function that returns a [Stream].
///
/// For each new value emitted by the source [ValueListenable], the previous
/// subscription to the stream is cancelled and a new subscription is created
/// to the stream returned by the mapping function. The value of this notifier
/// is updated with the latest value emitted by the currently active stream.
class SwitchMapNotifier<R, T> extends SourceMappedValueListenable<T, R> {
  /// Creates a [SwitchMapNotifier] that listens to the [source] and updates
  /// its value by applying the [_mapper] function to the source's value and
  /// listening to the resulting stream.
  SwitchMapNotifier(super.value, {required this._mapper, required super.source});

  final Stream<R> Function(T value) _mapper;
  StreamSubscription<R>? _subscription;

  @override
  void onSourceChanged() {
    _subscription?.cancel();
    _subscription = _mapper(source.value).listen((newValue) {
      value = newValue;
    });
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
