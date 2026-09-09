import 'package:flutter/foundation.dart';

/// Base class for [ValueNotifier]s that derive their value from a single source
/// [ValueListenable]. Subclasses should implement [onSourceChanged] to update
/// their value based on the source's value.
abstract class SourceMappedValueNotifier<T, R> extends ValueNotifier<R> {
  /// Creates a [SourceMappedValueNotifier] that listens to the given [source].
  SourceMappedValueNotifier(super.value, {required this.source}) {
    _subscribe();
  }

  /// The source [ValueListenable] that this notifier listens to.
  /// Subclasses should update their value in response to changes in this source.
  @protected
  final ValueNotifier<T> source;

  /// Called when the source value changes, should contain
  /// the logic to update this notifier's value based on the source's value.
  @protected
  void onSourceChanged();

  void _subscribe() {
    source.addListener(onSourceChanged);
    onSourceChanged();
  }

  void _unsubscribe() {
    source.removeListener(onSourceChanged);
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
