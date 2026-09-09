import 'package:flutter/foundation.dart';

/// Base class for [ValueNotifier]s that derive their value from multiple source
/// [ValueListenable]s. Subclasses should implement [onSourcesChanged] to update
/// their value based on the sources' values.
abstract class MultiSourceMappedValueNotifier<R> extends ValueNotifier<R> {
  /// Creates a [MultiSourceMappedValueNotifier] that listens to the given [sources].
  MultiSourceMappedValueNotifier(super.value, {required this.sources}) {
    _listeners = List<VoidCallback>.generate(
      sources.length,
      (i) =>
          () => onSourcesChanged(i),
    );
    _subscribe();
  }

  /// The source [ValueListenable]s that this notifier listens to.
  /// Subclasses should update their value in response to changes in these sources.
  final List<ValueListenable<dynamic>> sources;
  late final List<VoidCallback> _listeners;

  /// Called when any of the source values change. Should contain
  /// the logic to update this notifier's value based on the sources' values.
  void onSourcesChanged(int changedSourceIndex);

  void _subscribe() {
    for (int i = 0; i < sources.length; i++) {
      sources[i].addListener(_listeners[i]);
      onSourcesChanged(i);
    }
  }

  void _unsubscribe() {
    for (int i = 0; i < sources.length; i++) {
      sources[i].removeListener(_listeners[i]);
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
