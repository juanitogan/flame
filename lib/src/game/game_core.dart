import 'dart:ui';
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide WidgetBuilder;
//import 'package:pogo/src/game/camera_static.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/screen_static.dart';
//import 'package:pogo/src/game/system_static.dart';
import 'package:pogo/src/game/time_static.dart';
import 'package:pogo/src/game/widget_builder.dart';
//import 'package:pogo/src/vector_math.dart';

export 'dart:ui';
export 'dart:async';
export 'package:flutter/widgets.dart' show runApp, WidgetsFlutterBinding, GestureDetector;
export 'package:pogo/src/game/camera_static.dart';
export 'package:pogo/src/game/game_canvas_static.dart';
export 'package:pogo/src/game/screen_static.dart';
export 'package:pogo/src/game/system_static.dart';
export 'package:pogo/src/game/time_static.dart';
export 'package:pogo/src/game/widget_builder.dart' show GestureInitializer;
export 'package:pogo/src/vector_math.dart';

/// Represents a bare or proto game loop for building your own game system upon.
///
/// Subclass this to implement the [update] and [render] methods.
/// The engine will call these methods when the game's widget is rendered.
abstract class GameCore {

  /// Sets whether this [GameCore] is in debug mode or not.  Default is `false`.
  ///
  /// In debug mode, the [debugUpdate] method gets called in addition to [update].
  bool debugMode = false;

  // Widget Builder for this Game
  final builder = WidgetBuilder();

  /// Returns the game background color.
  /// By default it will return a black color.
  /// It cannot be changed at runtime, because the game widget does not get rebuilt when this value changes.
  Color backgroundColor() => const Color(0xFF000000);

  /// Implement this method to update the game state.
  void update();

  /// Implement this method to render the current game state in the [GameCanvas.main].
  //void render();

  /// This is the resize hook; every time the game widget is resized, this hook is called.
  ///
  /// The default implementation does nothing; override to use the hook.
  //void resize();

  /// This is the lifecycle state change hook; every time the game is resumed, paused or suspended, this is called.
  ///
  /// The default implementation does nothing; override to use the hook.
  /// Check [AppLifecycleState] for details about the events received.
  void lifecycleStateChange(AppLifecycleState state) {}

  /// Used for debugging.
  /// This is a hook that comes from the RenderBox.
  void debugUpdate();

  /// Returns the game widget. Put this in your structure to start rendering and updating the game.
  /// You can add it directly to the runApp method or inside your widget structure (if you use vanilla screens and widgets).
  Widget get widget => builder.build(this);

  // Called when the Game widget is attached
  void onAttach() {}

  // Called when the Game widget is detached
  @mustCallSuper
  void onDetach() {
    // Keeping this here, because if we leave this on HasWidgetsOverlay
    // and somebody overrides this and forgets to call the stream close
    // we can face some leaks.
    if (this is HasWidgetsOverlay) {
      (this as HasWidgetsOverlay).widgetOverlayController.close();
    }
  }

  /// Gesture callbacks.
	void onTapDown(TapDownDetails details);
	void onTapUp(TapUpDetails details);
  void onTapCancel();
  void onSecondaryTapDown(TapDownDetails details);
  void onSecondaryTapUp(TapUpDetails details);
  void onSecondaryTapCancel();
  void onSingleTap();
  void onDoubleTap();
  void onLongPress();
  void onVerticalDragStart(DragStartDetails details);
  void onVerticalDragUpdate(DragUpdateDetails details);
  void onVerticalDragEnd(DragEndDetails details);
  void onHorizontalDragStart(DragStartDetails details);
  void onHorizontalDragUpdate(DragUpdateDetails details);
  void onHorizontalDragEnd(DragEndDetails details);
  void onPanStart(DragStartDetails details);
  void onPanUpdate(DragUpdateDetails details);
  void onPanEnd(DragEndDetails details);
  void onScaleStart(ScaleStartDetails details);
  void onScaleUpdate(ScaleUpdateDetails details);
  void onScaleEnd(ScaleEndDetails details);

}


class OverlayWidget {
  final String name;
  final Widget widget;

  OverlayWidget(this.name, this.widget);
}


mixin HasWidgetsOverlay on GameCore {
  @override
  final builder = OverlayWidgetBuilder();

  final StreamController<OverlayWidget> widgetOverlayController =
      StreamController();

  void addWidgetOverlay(String overlayName, Widget widget) {
    widgetOverlayController.sink.add(OverlayWidget(overlayName, widget));
  }

  void removeWidgetOverlay(String overlayName) {
    widgetOverlayController.sink.add(OverlayWidget(overlayName, null));
  }
}


/// This a widget to embed a game inside the Widget tree. You can use it in pair with [PseudoGame] or any other more complex [GameCore], as desired.
///
/// It handles for you positioning, size constraints and other factors that arise when your game is embedded within the component tree.
/// Provide it with a [GameCore] instance for your game and the optional size of the widget.
/// Creating this without a fixed size might mess up how other components are rendered with relation to this one in the tree.
/// You can bind Gesture Recognizers immediately around this to add controls to your widgets, with easy coordinate conversions.
class EmbeddedGameWidget extends LeafRenderObjectWidget {
  final GameCore game;
  final Size size;

  EmbeddedGameWidget(this.game, {this.size});

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: GameRenderBox(context, game),
        additionalConstraints:
        		BoxConstraints.expand(width: size?.width, height: size?.height)
		);
  }

  @override
  void updateRenderObject(
      BuildContext context,
			RenderConstrainedBox renderBox
	) {
    renderBox
      ..child = GameRenderBox(context, game)
      ..additionalConstraints =
      		BoxConstraints.expand(width: size?.width, height: size?.height);
  }
}


class GameRenderBox extends RenderBox with WidgetsBindingObserver {
  BuildContext context;

  GameCore game;

  int _frameCallbackId;

  Duration previous = Duration.zero;

  GameRenderBox(this.context, this.game);

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();
    Screen.setSize(constraints.biggest);
		//Camera.rect ??= Rect.fromLTWH(0, 0, constraints.biggest.width, constraints.biggest.height);
    //game.resize(); //TODO why hit twice at startup?
    if (Screen.onResize != null) Screen.onResize();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    game.onAttach();

    _scheduleTick();
    _bindLifecycleListener();
  }

  @override
  void detach() {
    super.detach();
    game.onDetach();
    _unscheduleTick();
    _unbindLifecycleListener();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    if (!attached) {
      return;
    }
    _scheduleTick();
    //_update(timestamp);
    Time.tick(_computeDeltaT(timestamp));
    // Flutter: Mark this render object as having changed its visual appearance.
    markNeedsPaint();
  }

  /*void _update(Duration now) {
    final double dt = _computeDeltaT(now);
    Time.tick(dt);
    //game.update();
    //if (game.debugMode) game.debugUpdate();
  }*/

  double _computeDeltaT(Duration now) {
    Duration delta = now - previous;
    if (previous == Duration.zero) {
      delta = Duration.zero;
    }
    previous = now;
    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
      context.canvas.translate(
          game.builder.offset.dx + offset.dx,
          game.builder.offset.dy + offset.dy
      );
      GameCanvas.setMainCanvas(context.canvas);
      //game.render();
      //TODO would it matter much to move the delta calc here?
      game.update();
      if (game.debugMode) game.debugUpdate();
    context.canvas.restore();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    game.lifecycleStateChange(state);
  }
}
