import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

/// A [ValueNotifier] that is the result of mapping the value of another
/// [ValueListenable] through a mapping function. It updates its value whenever
/// the source [ValueListenable] changes.
class MappedValueListenable<R, T> extends SourceMappedValueListenable<T, R> {
  /// Creates a [MappedValueListenable] that listens to the [source] and updates
  /// its value by applying the [_mapper] function to the source's value.
  MappedValueListenable(
    super.value, {
    required this._mapper,
    required super.source,
  });

  final R Function(T value) _mapper;

  @override
  void onSourceChanged() {
    super.value = _mapper(source.value);
  }
}
