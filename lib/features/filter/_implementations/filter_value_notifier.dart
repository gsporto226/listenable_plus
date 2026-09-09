import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

/// A [FilterValueNotifier] that maps values of type [T] to an optional value of
/// type [R] using a provided filter function.
class FilterValueNotifier<R, T> extends SourceMappedValueListenable<T, R> {
  /// Creates a [FilterValueNotifier] that maps values of type [T] to an optional value of type [R] using the provided [_filter] function.
  FilterValueNotifier(super.value, {required super.source, required this._filter});

  final FilterResult<R> Function(T value) _filter;

  @override
  void onSourceChanged() {
    final optionalResult = _filter(source.value);
    switch (optionalResult) {
      case Pass(:final value):
        this.value = value;
      case Fail():
        break;
    }
  }
}

/// The result of applying a filter to a value, which can either be a [Pass] containing
/// the value that passed the filter criteria, or a [Fail] indicating that the value did
/// not pass the filter criteria.
sealed class FilterResult<T> {
  const FilterResult();

  factory FilterResult.pass(T value) = Pass<T>;

  factory FilterResult.fail() = Fail<T>;
}

/// Represents a successful filter result containing a value of type [T].
@immutable
class Pass<T> extends FilterResult<T> {
  /// Creates a [Pass] instance containing the provided [value], indicating that the filter criteria were met.
  const Pass(this.value);

  /// The value that passed the filter criteria.
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Pass<T> && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => Object.hashAll(['Some', value]);
}

/// Represents a failed filter result,
/// indicating that the value did not pass the filter criteria.
@immutable
class Fail<T> extends FilterResult<T> {
  /// Creates a [Fail] instance indicating that the filter criteria were not met.
  const Fail();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Fail<T>;

  @override
  int get hashCode => Object.hashAll(['None']);
}
