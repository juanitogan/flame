//import 'dart:ui';

//import 'package:pogo/src/entities/game_entity.dart';
//import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/game_core.dart';
//import 'package:pogo/src/pivot.dart';

import 'package:flutter/gestures.dart';

export 'package:flutter/gestures.dart' show
          TapDownDetails, TapUpDetails,
          DragStartDetails, DragUpdateDetails, DragEndDetails,
          ScaleStartDetails, ScaleUpdateDetails, ScaleEndDetails;
//export 'dart:ui' show Offset, Size;

////////////////////////////////////////////////////////////////////////////////
/// Mixin class to [GameEntity] providing gesture zone setup for the entity.
///
/// [gestureZoneSize] : Sets the size of the rectangle that taps and
/// drag-starts are limited to.  Set to `Size.zero` (the default) to disable
/// zone sizing and respond to gestures anywhere in the game window.
///
/// Note the [globalPosition] getter in this class that the base class
/// needs to collect and provide access to.
///
/// Note that SingleTap, DoubleTap, and LongPress have no location info and,
/// thus, cannot be limited to the gesture zone of a game entity.
/// Consequently, they also do not require this [GestureZone] mixin.
///
/// Note that there are no prefabs with the [GestureZone] mixin (or any
/// <Gesture>Detector mixin), as that would not be useful without access to
/// the tap methods (and lead to too many prefabs regardless).
/// It is possible to extend a prefab with gesture mixins but this is not
/// considered best practice versus extending [GameEntity] --
/// but not considered bad practice either.  It's a style choice.
///
mixin GestureZone { //on BasicGameEntity {

  // Data for the gesture components/mixins.
  // (Mixins are for methods, primarily, not data. Oh well. Can't "construct"
  // data unless duping in base and "getting" here. Passing on that for now.)
  // These values are relative to the entity's position.
  Offset gestureZoneOffset = Offset.zero; // Most use cases likely will not reset.
  Size   gestureZoneSize   = Size.zero;   // Unlike Image width and height (ints). Unlike Canvas rect too.//TODO add rect probably
  Pivot  gestureZonePivot  = System.defaultPivot;

  Vector2 get globalPosition;

  bool _inGestureZone(Offset o) {
    //if (tapZoneSize == null) {
    //  throw StateError("$runtimeType: tapZoneSize must be set before Tappable use.");
    //}
    // Assume size of zero means the whole game window.
    if (gestureZoneSize == Size.zero) {
      return true;
    }
    // NOTE: GE has it's own globalPosition -- do not confuse with TapDetails.globalPosition.
    final double left   = (globalPosition.x + gestureZoneOffset.dx
        - (gestureZonePivot.offsetFactor.dx * gestureZoneSize.width)
        - Camera.rect.left)
        * Camera.scale.dx;
    final double top    = (globalPosition.y + gestureZoneOffset.dy
        - (gestureZonePivot.offsetFactor.dy * gestureZoneSize.height)
        - Camera.rect.top)
        * Camera.scale.dy;
    final double right  = left + gestureZoneSize.width  * Camera.scale.dx;
    final double bottom = top  + gestureZoneSize.height * Camera.scale.dy;
    return o.dx >= left && o.dx < right && o.dy >= top && o.dy < bottom;
  }

}


////////////////////////////////////////////////////////////////////////////////
/// Mixin class for [GestureZone] that adds tap handlers (and adds the
/// entity to the list of tappable entities to process by the tap system).
mixin TapDetector on GestureZone {

  void onTapDown(TapDownDetails details);
  void onTapUp(TapUpDetails details);
  void onTapCancel();

  // Used to fake keeping the gesture local to this entity's gesture zone.
  bool _localTap = false;

  void handleTapDown(TapDownDetails details) {
    if (_inGestureZone(details.globalPosition)) {
      onTapDown(details);
      _localTap = true;
    }
  }

  void handleTapUp(TapUpDetails details) {
    if (_localTap) {
      if (_inGestureZone(details.globalPosition)) {
        onTapUp(details);
        _localTap = false;
      } else {
        handleTapCancel();
      }
    }
  }

  void handleTapCancel() {
    if (_localTap) {
      onTapCancel();
      _localTap = false;
    }
  }

}


////////////////////////////////////////////////////////////////////////////////
mixin SecondaryTapDetector on GestureZone {

  void onSecondaryTapDown(TapDownDetails details);
  void onSecondaryTapUp(TapUpDetails details);
  void onSecondaryTapCancel();

  // Used to fake keeping the gesture local to this entity's gesture zone.
  bool _localSecondaryTap = false;

  void handleSecondaryTapDown(TapDownDetails details) {
    if (_inGestureZone(details.globalPosition)) {
      onSecondaryTapDown(details);
    }
  }

  void handleSecondaryTapUp(TapUpDetails details) {
    if (_localSecondaryTap) {
      if (_inGestureZone(details.globalPosition)) {
        onSecondaryTapUp(details);
        _localSecondaryTap = false;
      } else {
        handleSecondaryTapCancel();
      }
    }
  }

  void handleSecondaryTapCancel() {
    if (_localSecondaryTap) {
      onSecondaryTapCancel();
      _localSecondaryTap = false;
    }
  }

}


////////////////////////////////////////////////////////////////////////////////
mixin SingleTapDetector {
  void onSingleTap(); // Note: intentional rename from onTap().
  void handleSingleTap() {
    onSingleTap();
  }
}


////////////////////////////////////////////////////////////////////////////////
mixin DoubleTapDetector {
  void onDoubleTap();
  void handleDoubleTap() {
    onDoubleTap();
  }
}


////////////////////////////////////////////////////////////////////////////////
mixin LongPressDetector {
  void onLongPress();
  void handleLongPress() {
    onLongPress();
  }
}


////////////////////////////////////////////////////////////////////////////////
mixin VerticalDragDetector on GestureZone {

  void onVerticalDragStart(DragStartDetails details);
  void onVerticalDragUpdate(DragUpdateDetails details);
  void onVerticalDragEnd(DragEndDetails details);

  // Used to fake keeping the gesture local to this entity's gesture zone.
  bool _localVerticalDrag = false;

  void handleVerticalDragStart(DragStartDetails details) {
    if (_inGestureZone(details.globalPosition)) {
      onVerticalDragStart(details);
      _localVerticalDrag = true;
    }
  }

  void handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_localVerticalDrag) {
      //if (_inGestureZone(details.globalPosition)) {
        onVerticalDragUpdate(details);
      /*} else {
        // Fake the drag end event. //TODO validate velocity calcs
        handleVerticalDragEnd(DragEndDetails(
            velocity: Velocity(pixelsPerSecond: details.delta / (details.sourceTimeStamp.inMicroseconds / Duration.microsecondsPerSecond)),
            primaryVelocity: details.primaryDelta / (details.sourceTimeStamp.inMicroseconds / Duration.microsecondsPerSecond)
        ));
      }*/ //TODO decide on which behavior: always in bounds or just start in bounds?
    }
  }

  void handleVerticalDragEnd(DragEndDetails details) {
    if (_localVerticalDrag) {
      onVerticalDragEnd(details);
      _localVerticalDrag = false;
    }
  }

}


////////////////////////////////////////////////////////////////////////////////
mixin HorizontalDragDetector on GestureZone {

  void onHorizontalDragStart(DragStartDetails details);
  void onHorizontalDragUpdate(DragUpdateDetails details);
  void onHorizontalDragEnd(DragEndDetails details);

  // Used to fake keeping the gesture local to this entity's gesture zone.
  bool _localHorizontalDrag = false;

  void handleHorizontalDragStart(DragStartDetails details) {
    if (_inGestureZone(details.globalPosition)) {
      onHorizontalDragStart(details);
      _localHorizontalDrag = true;
    }
  }

  void handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (_localHorizontalDrag) {
      //if (_inGestureZone(details.globalPosition)) {
        onHorizontalDragUpdate(details);
      /*} else {
        // Fake the drag end event. //TODO validate velocity calcs
        handleHorizontalDragEnd(DragEndDetails(
            velocity: Velocity(pixelsPerSecond: details.delta / (details.sourceTimeStamp.inMicroseconds / Duration.microsecondsPerSecond)),
            primaryVelocity: details.primaryDelta / (details.sourceTimeStamp.inMicroseconds / Duration.microsecondsPerSecond)
        ));
      }*/ //TODO decide on which behavior: always in bounds or just start in bounds?
    }
  }

  void handleHorizontalDragEnd(DragEndDetails details) {
    if (_localHorizontalDrag) {
      onHorizontalDragEnd(details);
      _localHorizontalDrag = false;
    }
  }

}


////////////////////////////////////////////////////////////////////////////////
mixin PanDetector on GestureZone {

  void onPanStart(DragStartDetails details);
  void onPanUpdate(DragUpdateDetails details);
  void onPanEnd(DragEndDetails details);

  // Used to fake keeping the gesture local to this entity's gesture zone.
  bool _localPan = false;

  void handlePanStart(DragStartDetails details) {
    if (_inGestureZone(details.globalPosition)) {
      onPanStart(details);
      _localPan = true;
    }
  }

  void handlePanUpdate(DragUpdateDetails details) {
    if (_localPan) {
      //if (_inGestureZone(details.globalPosition)) {
        onPanUpdate(details);
      /*} else {
        // Fake the drag end event. //TODO validate velocity calcs
        handlePanEnd(DragEndDetails(
            velocity: Velocity(pixelsPerSecond: details.delta / (details.sourceTimeStamp.inMicroseconds / Duration.microsecondsPerSecond)),
            primaryVelocity: details.primaryDelta / (details.sourceTimeStamp.inMicroseconds / Duration.microsecondsPerSecond)
        ));
      }*/ //TODO decide on which behavior: always in bounds or just start in bounds?
    }
  }

  void handlePanEnd(DragEndDetails details) {
    if (_localPan) {
      onPanEnd(details);
      _localPan = false;
    }
  }

}


////////////////////////////////////////////////////////////////////////////////
mixin ScaleDetector on GestureZone {

  void onScaleStart(ScaleStartDetails details);
  void onScaleUpdate(ScaleUpdateDetails details);
  void onScaleEnd(ScaleEndDetails details);

  // Used to fake keeping the gesture local to this entity's gesture zone.
  bool _localScale = false;

  void handleScaleStart(ScaleStartDetails details) {
    if (_inGestureZone(details.focalPoint)) {
      onScaleStart(details);
      _localScale = true;
    }
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    if (_localScale) {
      onScaleUpdate(details);
    }
  }

  void handleScaleEnd(ScaleEndDetails details) {
    if (_localScale) {
      onScaleEnd(details);
      _localScale = false;
    }
  }

}
