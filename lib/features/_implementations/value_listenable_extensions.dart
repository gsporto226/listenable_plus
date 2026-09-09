import 'package:flutter/foundation.dart';

import 'package:listenable_plus/features/combine/implementations/combine_value_notifier.dart';
import 'package:listenable_plus/features/debounce/_implementations/debounce_time.dart';
import 'package:listenable_plus/features/distinct/implementations/distinct_value_notifier.dart';
import 'package:listenable_plus/features/filter/_implementations/filter_value_notifier.dart';
import 'package:listenable_plus/features/map/implementations/map_value_listenable.dart';
import 'package:listenable_plus/features/map/implementations/map_value_notifier.dart';
import 'package:listenable_plus/features/switch_listen/implementations/switch_listen_notifier.dart';
import 'package:listenable_plus/features/switch_map/implementations/switch_map_notifier.dart';

/// Extension methods on [ValueListenable] to provide convenient ways to transform
/// and combine listenables.
extension ValueListenableExtension<T> on ValueListenable<T> {
  // Transforms the value of this [ValueListenable] using the provided [mapper] function.
  ///
  /// The returned [ValueListenable] will emit the transformed value whenever the original
  /// [ValueListenable] emits a new value.
  ValueListenable<R> map<R>(R Function(T value) mapper) =>
      MappedValueListenable<R, T>(mapper(value), mapper: mapper, source: this);

  /// Selects a member of the source value — a semantic alias for [map] used to
  /// derive field-level listenables (e.g. `$model.select((m) => m.title)`).
  ValueListenable<R> select<R>(R Function(T value) selector) => map(selector);

  /// Filters the values of this [ValueListenable] and optionally transforms them.
  ///
  /// The returned [ValueListenable] will emit a new value only when the [filter]
  /// function returns a [Pass] result.
  ValueListenable<R> where<R>(R initialValue, FilterResult<R> Function(T value) filter) =>
      FilterValueNotifier<R, T>(initialValue, source: this, filter: filter);

  /// Transforms the value of this [ValueListenable] into a new [Stream] of values
  /// using the provided [mapper] function, and emits the values of the stream.
  ValueListenable<R> switchMap<R>(R initialValue, Stream<R> Function(T value) mapper) =>
      SwitchMapNotifier<R, T>(initialValue, mapper: mapper, source: this);

  /// Switches between inner [ValueListenable]s produced by [mapper] as this
  /// [ValueListenable] changes, always tracking the latest inner one.
  ///
  /// The listenable-only counterpart of [switchMap]: when the source emits a
  /// new value, the previous inner listenable is unsubscribed and the inner
  /// produced for the new value is subscribed, emitting its current value
  /// immediately. Updates from a superseded inner are dropped.
  ValueListenable<R> switchListen<R>(R initialValue, ValueListenable<R> Function(T value) mapper) =>
      SwitchListenNotifier<R, T>(initialValue, mapper: mapper, source: this);

  /// Emits values that are distinct from the previous value.
  ///
  /// The optional [equals] function can be used to determine whether two values are distinct.
  ValueListenable<T> distinct([bool Function(T previous, T next)? equals]) =>
      DistinctValueNotifier<T>(value, source: this, equals: equals);

  /// Emits the latest value from the source [ValueListenable] after a specified duration has passed
  /// since the last source value change and no new value has been emitted.
  ValueListenable<T> debounceTime(Duration duration) =>
      DebounceTimeValueNotifier<T>(value, source: this, duration: duration);

  /// Combines this [ValueListenable] with another [ValueListenable].
  ValueListenable<R> combineWith<O, R>(
    ValueListenable<O> other,
    R Function(T value, O otherValue) combiner,
  ) => CombineLatestValueNotifier.combine2<T, O, R>(this, other, combiner);
}

/// Extension methods on [ValueNotifier] to provide convenient ways to transform them.
extension ValueNotifierExtension<T> on ValueNotifier<T> {
  /// Transforms the value of this [ValueNotifier] using the provided [mapper] function.
  ///
  /// The returned [ValueNotifier] will emit the transformed value whenever the original
  /// [ValueNotifier] emits a new value.
  ValueNotifier<R> map<R>(
    R Function(T value) mapper,
    T Function(T current, R value) reverseMapper,
  ) => MappedValueNotifier<R, T>(
    mapper(value),
    mapper: mapper,
    reverseMapper: reverseMapper,
    source: this,
  );
}
