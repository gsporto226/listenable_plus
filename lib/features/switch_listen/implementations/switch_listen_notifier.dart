import 'package:flutter/foundation.dart';
import 'package:listenable_plus/features/_implementations/source_mapped_value_listenable.dart';

/// A [ValueNotifier] that switches between inner [ValueListenable]s produced by
/// the [mapper] as the source changes, always tracking the latest inner one.
///
/// This is the listenable-only counterpart of `switchMap`: when the source
/// emits a new value, the previous inner listenable is unsubscribed and the
/// inner produced for the new value is subscribed, emitting its current value
/// immediately. Updates from a superseded inner are dropped.
class SwitchListenNotifier<R, T> extends SourceMappedValueListenable<T, R> {
  /// Creates a [SwitchListenNotifier] that listens to the [source] and tracks
  /// the inner listenable produced by [_mapper] for the current source value.
  SwitchListenNotifier(super.value, {required this._mapper, required super.source});

  final ValueListenable<R> Function(T value) _mapper;
  ValueListenable<R>? _inner;
  VoidCallback? _innerListener;

  @override
  void onSourceChanged() {
    _detachInner();
    final inner = _mapper(source.value);
    _inner = inner;
    _innerListener = () => value = inner.value;
    inner.addListener(_innerListener!);
    value = inner.value;
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _detachInner();
    }
  }

  @override
  void dispose() {
    _detachInner();
    super.dispose();
  }

  void _detachInner() {
    final inner = _inner;
    final listener = _innerListener;
    if (inner != null && listener != null) {
      inner.removeListener(listener);
    }
    _inner = null;
    _innerListener = null;
  }
}
