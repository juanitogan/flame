import 'package:flutter/widgets.dart';
import 'package:pogo/src/game/game_core.dart';

/// Static class for presetting gesture features that the game's widget will
/// turn on when instantiated.
///
/// Note that Tap is different from SingleTap.  Tap contains the typical events
/// `onTapDown`, `onTapUp`, and `onTapCancel`, with tap location details.
/// SingleTap likely would only be wanted when also using DoubleTap in a very
/// basic game interface.
///
/// Note that SingleTap, DoubleTap, and LongPress have no location info and,
/// thus, cannot be limited to the gesture zone of a game entity.
///
/// Note: Because games run in a single widget, there are limitations on multiple
/// gesture detections within a game (this is game-wide, regardless of which
/// game entities use which gestures):
///
/// 1. Both horizontal and vertical drag cannot be enabled.
/// ~~Trying to do so should generate an error.~~
/// The current workaround is to use pan instead, with your own code to
/// determine direction of movement.
///
/// 2. Both pan and scale cannot be enabled.
/// Trying to do so should generate an error.
/// Scale is considered a superset of pan and should be used instead.
///
/// 3. The Flutter source code does not match the rules stated in the Flutter
/// docs, so expect variations on the above as things evolve.
/// Such as, no error if trying to use both horizontal and vertical drag unless
/// also using both of them with pan or scale.
///
/// 4. Avoid enabling more gestures than needed as it can slow down gesture
/// recognition in the _gesture arena_.
///
/// If needing many types of gestures in your game, it may be best to not use
/// Flutter's [GestureDetector] and implement your own pointer [Listener]
/// instead:
/// [Flutter Deep Dive: Gestures](https://medium.com/flutter-community/flutter-deep-dive-gestures-c16203b3434f).
///
/// TODO: Add built-in support for the low-level pointer events:
/// `onPointerDown`, `onPointerUp`, `onPointerMove`, and `onPointerCancel`.
class GestureInitializer {
  static bool detectTaps = false;
  static bool detectSecondaryTaps = false;
  static bool detectSingleTaps = false;
  static bool detectDoubleTaps = false;
  static bool detectLongPresses = false;
  static bool detectVerticalDrags = false;
  static bool detectHorizontalDrags = false;
  static bool detectPans = false;
  static bool detectScales = false;
}


class WidgetBuilder {
  Offset offset = Offset.zero;

  Widget build(GameCore game) {
    return GestureDetector(

      onTapDown:   GestureInitializer.detectTaps ? (TapDownDetails d) => game.onTapDown(d) : null,
      onTapUp:     GestureInitializer.detectTaps ? (TapUpDetails d) => game.onTapUp(d) : null,
      onTapCancel: GestureInitializer.detectTaps ? () => game.onTapCancel() : null,
      //onTap:       GestureInitializer.detectTaps ? () => null : null,

      onSecondaryTapDown:   GestureInitializer.detectSecondaryTaps ? (TapDownDetails d) => game.onSecondaryTapDown(d) : null,
      onSecondaryTapUp:     GestureInitializer.detectSecondaryTaps ? (TapUpDetails d) => game.onSecondaryTapUp(d) : null,
      onSecondaryTapCancel: GestureInitializer.detectSecondaryTaps ? () => game.onSecondaryTapCancel() : null,

      onTap:       GestureInitializer.detectSingleTaps ? () => game.onSingleTap() : null,

      onDoubleTap: GestureInitializer.detectDoubleTaps ? () => game.onDoubleTap() : null,

      onLongPress: GestureInitializer.detectLongPresses ? () => game.onLongPress() : null,

      onVerticalDragStart:  GestureInitializer.detectVerticalDrags ? (DragStartDetails d) => game.onVerticalDragStart(d) : null,
      onVerticalDragUpdate: GestureInitializer.detectVerticalDrags ? (DragUpdateDetails d) => game.onVerticalDragUpdate(d) : null,
      onVerticalDragEnd:    GestureInitializer.detectVerticalDrags ? (DragEndDetails d) => game.onVerticalDragEnd(d) : null,

      onHorizontalDragStart:  GestureInitializer.detectHorizontalDrags ? (DragStartDetails d) => game.onHorizontalDragStart(d) : null,
      onHorizontalDragUpdate: GestureInitializer.detectHorizontalDrags ? (DragUpdateDetails d) => game.onHorizontalDragUpdate(d) : null,
      onHorizontalDragEnd:    GestureInitializer.detectHorizontalDrags ? (DragEndDetails d) => game.onHorizontalDragEnd(d) : null,

      onPanStart:  GestureInitializer.detectPans ? (DragStartDetails d) => game.onPanStart(d) : null,
      onPanUpdate: GestureInitializer.detectPans ? (DragUpdateDetails d) => game.onPanUpdate(d) : null,
      onPanEnd:    GestureInitializer.detectPans ? (DragEndDetails d) => game.onPanEnd(d) : null,

      onScaleStart:  GestureInitializer.detectScales ? (ScaleStartDetails d) => game.onScaleStart(d) : null,
      onScaleUpdate: GestureInitializer.detectScales ? (ScaleUpdateDetails d) => game.onScaleUpdate(d) : null,
      onScaleEnd:    GestureInitializer.detectScales ? (ScaleEndDetails d) => game.onScaleEnd(d) : null,

      child: Container(
          color: game.backgroundColor(),
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: EmbeddedGameWidget(game))),
    );
  }
}

class OverlayGameWidget extends StatefulWidget {
  final Widget gameChild;
  final HasWidgetsOverlay game;

  OverlayGameWidget({this.gameChild, this.game});

  @override
  State<StatefulWidget> createState() => _OverlayGameWidgetState();
}

class _OverlayGameWidgetState extends State<OverlayGameWidget> {
  final Map<String, Widget> _overlays = {};

  @override
  void initState() {
    super.initState();
    widget.game.widgetOverlayController.stream.listen((overlay) {
      setState(() {
        if (overlay.widget == null) {
          _overlays.remove(overlay.name);
        } else {
          _overlays[overlay.name] = overlay.widget;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child:
            Stack(children: [widget.gameChild, ..._overlays.values.toList()]));
  }
}

class OverlayWidgetBuilder extends WidgetBuilder {
  OverlayWidgetBuilder();

  @override
  Widget build(GameCore game) {
    final container = super.build(game);

    return OverlayGameWidget(gameChild: container, game: game);
  }
}
