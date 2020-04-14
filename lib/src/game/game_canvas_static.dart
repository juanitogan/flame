import 'dart:ui';

/// Static class for [Canvas] refs and data.
///
// Would rather call this the Canvas class and ref the main canvas with
// Canvas.main, but "Canvas" is already flooded with use in Dart.
// Did rename from Graphics.canvas to GameCanvas.main though.
class GameCanvas {

  /// Ref to the main [Canvas] for the game.
  ///
  /// Accessing this object outside of render() may lead to unexpected results.
  static Canvas _main;
  static Canvas get main => _main;
  static void setMainCanvas(Canvas canvas) => _main = canvas; // deliberately wordy setter


  /* Not needed with Pogo game entities:
  /// Utility method to render stuff on a specific place.
  ///
  /// Some render methods don't allow to pass an offset.
  /// This method translate the canvas, draws what you want, and then translate back.
  ///
  // `drawWhere`: a very simple function that manually applies an offset to the `Canvas`,
  // render stuff given via a function and then reset the `Canvas`, without using the
  // `Canvas`' built-in `save`/`restore` functionality.
  // This might be useful because `BasicGame` uses the state of the canvas, and you should not mess with it.
  //
  static void drawWhere(Canvas c, Vector2 position, void Function(Canvas) fn) {
    Graphics.canvas.translate(position.x, position.y);
    fn(c);
    Graphics.canvas.translate(-position.x, -position.y);
  }*/


}