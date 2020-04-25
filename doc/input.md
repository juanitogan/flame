# Input

Input is made available through a collection of [gesture-detector mixins](#gesture-detector-mixins) on a [GameEntity](game_entity.md).  Most of these also work through another mixin, [GestureArea](#gestureArea-mixin), that allows defining a gesture zone relative to the entity's position.

Note that Pogo goes a step beyond Flutter and divided the onTap events into two mixins: TapDetector and SingleTapDetector.  This allows Pogo to keep Flutter's gesture arena as simple as possible when setting up Flutter's [GestureDetector widget](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html).  Most games will want Pogo's TapDetector and not need SingleTapDetector.

[More on Flutter's gestures is found here](https://flutter.dev/docs/development/ui/advanced/gestures).

See also: [Gamepad](gamepad.md).


# GestureInitializer class

The GestureInitializer static class provides central access to static flags used to initialize the main [GestureDetector]((https://api.flutter.dev/flutter/widgets/GestureDetector-class.html)).

You must initialize all gestures that will be used anywhere in your game.  Do this in your `main()` before referencing `Game()`.

## Properties

| | |
| :-- | :-- |
| detectTaps            | Default: `false`. |
| detectSecondaryTaps   | Default: `false`. |
| detectSingleTaps      | Default: `false`. |
| detectDoubleTaps      | Default: `false`. |
| detectLongPresses     | Default: `false`. |
| detectVerticalDrags   | Default: `false`. |
| detectHorizontalDrags | Default: `false`. |
| detectPans            | Default: `false`. |
| detectScales          | Default: `false`. |

Note: Because games run in a single widget, there are limitations on multiple
gesture detections within a game (this is game-wide, regardless of which
game entities use which gestures):

1. Both horizontal and vertical drag cannot be enabled.
~~Trying to do so should generate an error.~~
The current workaround is to use pan instead, with your own code to
determine direction of movement.

2. Both pan and scale cannot be enabled.
Trying to do so should generate an error.
Scale is considered a superset of pan and should be used instead.

3. The Flutter source code does not match the rules stated in the Flutter
docs, so expect variations on the above as things evolve.
Such as, no error if trying to use both horizontal and vertical drag unless
also using both of them with pan or scale.

4. Avoid enabling more gestures than needed as it can slow down gesture
recognition in the _gesture arena_.

If needing many types of gestures in your game, it may be best to not use
Flutter's GestureDetector and implement your own pointer Listener
instead:
[Flutter Deep Dive: Gestures](https://medium.com/flutter-community/flutter-deep-dive-gestures-c16203b3434f).


# GestureArea mixin

## Properties

| | |
| :-- | :-- |
| gestureAreaOffset | Top-left corner of the zone relative to entity position.  Default: `Offset.zero`. |
| gestureAreaSize   | Sets the size of the rectangle that taps and drag-starts are limited to.  Set to `Size.zero` to disable zone sizing and respond to gestures anywhere in the game window.  Hint: small objects and drag/pan objects may need sizes larger than the visible components.  Default: `Size.zero`. |
| gestureAreaPivot  | Pivot of the zone.  Default: `System.defaultPivot` which defaults to `Pivot.center`. |


# Gesture-detector mixins

| Mixin | Required method overrides |
| :-- | :-- |
| TapDetector            * | onTapDown, onTapUp, onTapDown |
| SecondaryTapDetector   * | onSecondaryTapDown, onSecondaryTapUp, onSecondaryTapDown |
| SingleTapDetector        | onSingleTap |
| DoubleTapDetector        | onDoubleTap |
| LongPressDetector        | onLongPress |
| VerticalDragDetector   * | onVerticalDragStart, onVerticalDragUpdate, onVerticalDragEnd |
| HorizontalDragDetector * | onHorizontalDragStart, onHorizontalDragUpdate, onHorizontalDragEnd |
| PanDetector            * | onPanStart, onPanUpdate, onPanEnd |
| ScaleDetector          * | onScaleStart, onScaleUpdate, onScaleEnd |

\* Requires the [GestureArea](gesturearea-mixin) mixin as well.

Note that the detectors that do not require the GestureArea mixin cannot be limited by a zone and will trigger their events from gestures anywhere in the game window.  They will also have a slower response time by their very nature.

----

See the [**gestures** example app](/doc/examples/gestures/lib/main.dart).

See the [**animations** example app](/doc/examples/animations/lib/main.dart).

See the [main example app](/example/lib/main.dart).
