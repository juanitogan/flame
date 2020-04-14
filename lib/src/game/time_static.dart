/// Static class for finding time-related values with the game engine.
///
/// All times are in seconds with decimal precision chopped to the microsecond.
class Time {

  static final DateTime _startTime = DateTime.now();

  /// Seconds since start of game.  Ignores time scaling.
  /// Remains constant during each frame.
  /// "Now" is always relative to something.
  /// Here, it is relative to game start and only ticks with each frame.
  ///
  /// Note: If no frames are ticking, this does not update even though this is "unscaled."
  static double _unscaledNow = 0.0; // Performance question: Duration or float seconds???
  static double get unscaledNow => _unscaledNow; // Seconds.

  /// Seconds since start of game, adjusted by time scaling.
  /// Remains constant during each frame.
  /// "Now" is always relative to something.
  /// Here, it is relative to game start and only ticks with each frame.
  static double get now => _unscaledNow; // Seconds.
  // TODO add a time scale feature for pause, etc

  /// Seconds since the last frame.
  static double _deltaTime = 0.0;
  static double get deltaTime => _deltaTime;

  /// Number of frames since start of game.
  static int _frameCount = -1; // tick to 0 before first update()
  static int get frameCount => _frameCount;

  //TODO how to hide this, if need be?
  static void tick(double deltaTime) {
    _deltaTime = deltaTime;
    _unscaledNow = DateTime.now().difference(_startTime).inMicroseconds / Duration.microsecondsPerSecond;
    _frameCount++;
  }


  // I can't say I want to add anything like this:
  // (and, if I did, it should delta from _startTime and not epoch)
  /*static double get realtimeNow =>
    DateTime.now().microsecondsSinceEpoch.toDouble() /
        Duration.microsecondsPerSecond;*/

}