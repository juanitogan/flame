//TODONE check lingo, var types, whatever; seconds? microseconds? looks like seconds
//TODO check for intel: https://api.flutter.dev/flutter/dart-core/Stopwatch-class.html
//TODO check for intel: https://api.flutter.dev/flutter/quiver.async/CountdownTimer-class.html

import 'package:pogo/src/game/time_static.dart';


// TODO Incremental or startTime pattern??  Current is incremental.
//  Possible u-sec drift??  Not if game loop built right and float resolution holds.
//  Some quick testing showed some differences on startup objects due to the
//  app loading lag (with startTime being ahead by 0.xx seconds) but the gap
//  after load seemed steady enough.
//  See AnimationComponent for pause logic with the starTime pattern.


/// Simple utility class that helps handling time counting (in seconds) and implementing interval like events.
///
/// Unlike other Dart or Flutter timers, this runs on the game engine [update] loop.
///
/// Creates a [TimerComponent] in stopped state with zero elapsed seconds.
///
/// The following example shows how to start a 10-second timer immediately after allocation.
///
/// ```dart
/// var timer = TimerComponent(10.0)..start();
/// ```
class TimerComponent {
  final double _duration;
  void Function() _callback;
  bool _repeat;
  double _elapsed = 0.0;
  bool _running = false;
  //TODO why so many privates? why not allow changing more vars after start?

  double get elapsed => _elapsed;
  /// A value between 0 and 1 indicating the timer progress
  double get progress => (_elapsed / _duration).clamp(0.0, 1.0);

  bool get isFinished => _elapsed >= _duration; // a bit confusing since != !_running, but does not change with stop()
  bool get isRunning => _running;


  TimerComponent(
      this._duration, // seconds
      {
        bool repeat = false,
        void Function() callback
      }
  ) {
    _repeat = repeat;
    _callback = callback;
  }


  void update() {
    if (_running) {
      _elapsed += Time.deltaTime;

      if (isFinished) {
        if (_repeat) {
          _elapsed -= _duration;
        } else {
          _running = false;
        }

        if (_callback != null) {
          _callback();
        }
      }
    }
  }

  void start() {
    _elapsed = 0.0;
    _running = true;
  }

  void stop() {
    _elapsed = 0.0;
    _running = false;
  }

  //TODO reset()?

}
