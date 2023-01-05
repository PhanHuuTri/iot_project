import 'dart:async';

class Debouncer<T> {
  final void Function(T)? callback;
  final Duration? delayTime;
  Timer? _waiter;

  void dispose() {
    cancel();
  }

  Debouncer({
    this.delayTime, // milisecond
    this.callback,
  });

  debounce({
    T? value,
    Function? beforeDuration,
    Function? afterDuration,
  }) {
    // Cancel previous timer
    _waiter?.cancel();
    if (beforeDuration != null) beforeDuration();
    // Start new timer
    _waiter = Timer(
        delayTime != null ? delayTime! : const Duration(milliseconds: 250), () {
      _waiter = null;
      if (callback != null) callback!(value!);
      if (afterDuration != null) afterDuration();
    });
  }

  void cancel() {
    _waiter?.cancel();
    _waiter = null;
  }
}
