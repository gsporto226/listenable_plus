import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/multi_source_mapped_value_notifier.dart';

/// Combines [ValueListenable]s into a single [ValueListenable] that updates
/// whenever any of the source [ValueListenable]s change.
///
/// This value notifier only listens to the source [ValueListenable]s when it
/// has listeners itself, and unsubscribes when it has no listeners.
class CombineLatestValueNotifier<R> extends MultiSourceMappedValueNotifier<R> {
  /// Creates a [CombineLatestValueNotifier] from the given [listenables] and a
  /// combiner closure that reads the current source values.
  CombineLatestValueNotifier(Iterable<ValueListenable<dynamic>> listenables, this._combiner)
    : super(_combiner(), sources: listenables.toList());

  final R Function() _combiner;

  @override
  void onSourcesChanged(int changedSourceIndex) {
    value = _combiner();
  }

  /// Combines multiple [ValueListenable]s into a single [ValueListenable].
  static CombineLatestValueNotifier<R> combine<T, R>(
    List<ValueListenable<T>> notifiers,
    R Function(List<T> values) combiner,
  ) => CombineLatestValueNotifier<R>(
    notifiers,
    () => combiner(notifiers.map((n) => n.value).toList()),
  );

  /// Combines two [ValueListenable]s
  static CombineLatestValueNotifier<R> combine2<A, B, R>(
    ValueListenable<A> $a,
    ValueListenable<B> $b,
    R Function(A a, B b) combiner,
  ) => CombineLatestValueNotifier<R>(
    [$a, $b],
    () => combiner($a.value, $b.value),
  );

  /// Combines three [ValueListenable]s
  static CombineLatestValueNotifier<R> combine3<A, B, C, R>(
    ValueListenable<A> $a,
    ValueListenable<B> $b,
    ValueListenable<C> $c,
    R Function(A a, B b, C c) combiner,
  ) => CombineLatestValueNotifier<R>(
    [$a, $b, $c],
    () => combiner($a.value, $b.value, $c.value),
  );

  /// Combines four [ValueListenable]s
  static CombineLatestValueNotifier<R> combine4<A, B, C, D, R>(
    ValueListenable<A> $a,
    ValueListenable<B> $b,
    ValueListenable<C> $c,
    ValueListenable<D> $d,
    R Function(A a, B b, C c, D d) combiner,
  ) => CombineLatestValueNotifier<R>(
    [$a, $b, $c, $d],
    () => combiner($a.value, $b.value, $c.value, $d.value),
  );

  /// Combines five [ValueListenable]s
  static CombineLatestValueNotifier<R> combine5<A, B, C, D, E, R>(
    ValueListenable<A> $a,
    ValueListenable<B> $b,
    ValueListenable<C> $c,
    ValueListenable<D> $d,
    ValueListenable<E> $e,
    R Function(A a, B b, C c, D d, E e) combiner,
  ) => CombineLatestValueNotifier<R>(
    [$a, $b, $c, $d, $e],
    () => combiner($a.value, $b.value, $c.value, $d.value, $e.value),
  );

  /// Combines six [ValueListenable]s
  static CombineLatestValueNotifier<R> combine6<A, B, C, D, E, F, R>(
    ValueListenable<A> $a,
    ValueListenable<B> $b,
    ValueListenable<C> $c,
    ValueListenable<D> $d,
    ValueListenable<E> $e,
    ValueListenable<F> $f,
    R Function(A a, B b, C c, D d, E e, F f) combiner,
  ) => CombineLatestValueNotifier<R>(
    [$a, $b, $c, $d, $e, $f],
    () => combiner($a.value, $b.value, $c.value, $d.value, $e.value, $f.value),
  );

  /// Specialization of [CombineLatestValueNotifier] using a type-safe signature.
  static CombineLatestValueNotifier<R> combine7<A, B, C, D, E, F, G, R>(
    ValueListenable<A> $a,
    ValueListenable<B> $b,
    ValueListenable<C> $c,
    ValueListenable<D> $d,
    ValueListenable<E> $e,
    ValueListenable<F> $f,
    ValueListenable<G> $g,
    R Function(A a, B b, C c, D d, E e, F f, G g) combiner,
  ) => CombineLatestValueNotifier<R>(
    [$a, $b, $c, $d, $e, $f, $g],
    () => combiner($a.value, $b.value, $c.value, $d.value, $e.value, $f.value, $g.value),
  );
}
