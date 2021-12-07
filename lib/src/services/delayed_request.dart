import 'dart:async';

class DelayedRequests {
  static const Duration duration = Duration(seconds: 2);
  static final Map<String, Timer> _jobs = {};

  static void add(String key, Future<void> Function() request) {
    if (_jobs.containsKey(key)) {
      _jobs[key]?.cancel();
    }

    _jobs[key] = Timer(duration, () {
      request();
      _jobs.remove(key);
    });
  }
}
