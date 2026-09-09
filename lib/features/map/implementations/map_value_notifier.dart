import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_notifier.dart';

/// A [ValueNotifier] that is the result of mapping the value of another
/// [ValueListenable] through a mapping function. It updates its value whenever
/// the source [ValueListenable] changes.
class MappedValueNotifier<R, T> extends SourceMappedValueNotifier<T, R> {
  /// Creates a [MappedValueNotifier] that listens to the [source] and updates
  /// its value by applying the [_mapper] function to the source's value.
  MappedValueNotifier(
    super.value, {
    required this._reverseMapper,
    required this._mapper,
    required super.source,
  });

  final R Function(T value) _mapper;
  final T Function(T current, R value) _reverseMapper;

  @override
  void onSourceChanged() {
    super.value = _mapper(source.value);
  }

  @override
  set value(R newValue) {
    super.value = newValue;
    source.removeListener(onSourceChanged);
    source.value = _reverseMapper(source.value, newValue);
    source.addListener(onSourceChanged);
  }
}
