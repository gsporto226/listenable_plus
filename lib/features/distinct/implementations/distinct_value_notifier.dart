import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

/// A [ValueNotifier] that listens to a source [ValueListenable] and updates its
/// value only when the source's value changes to a distinct value using the
/// provided equality function or `==` by default.
class DistinctValueNotifier<T> extends SourceMappedValueListenable<T, T> {
  /// Creates a [DistinctValueNotifier] that listens to the given [source] and
  /// updates its value only when the source's value changes to a distinct value.
  DistinctValueNotifier(super.value, {required super.source, bool Function(T previous, T next)? equals})
    : _equals = equals ?? ((a, b) => a == b);

  final bool Function(T previous, T next) _equals;

  @override
  void onSourceChanged() {
    final newValue = source.value;
    if (!_equals(value, newValue)) {
      value = newValue;
    }
  }
}
