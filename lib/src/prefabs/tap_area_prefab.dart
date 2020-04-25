import 'package:pogo/src/entities/game_entity.dart';
import 'package:pogo/src/entities/mixins/gesture_mixins.dart';

export 'package:pogo/src/entities/game_entity.dart';
export 'package:pogo/src/entities/mixins/gesture_mixins.dart' show TapDownDetails, TapUpDetails;

/// A [GameEntity] containing a [GestureArea] and [TapDetector] with event callbacks.
/// This gives components position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use entities.
class TapAreaPrefab extends GameEntity with GestureArea, TapDetector {
  Function() tapDownCallback;
  Function() tapCancelCallback;
  Function() tapUpCallback;

  TapAreaPrefab(
      {
        Size    gestureAreaSize,
        Pivot   gestureAreaPivot,
        this.tapDownCallback,
        this.tapCancelCallback,
        this.tapUpCallback,
        Vector2 position,
        int     zOrder = 0,
        double  rotation,
        double  rotationDeg,
        Vector2 scale,
        bool    enabled = true,
        GameEntity parent,
      }
  ) : super(
    position:    position,
    zOrder:      zOrder,
    rotation:    rotation,
    rotationDeg: rotationDeg,
    scale:       scale,
    enabled:     enabled,
    parent:      parent,
  ) {
    this.gestureAreaSize = gestureAreaSize ?? Size.zero;
    this.gestureAreaPivot = gestureAreaPivot ?? System.defaultPivot;

    assert((Game().widget as GestureDetector).onTapDown != null,
    "To use TapAreaPrefab, 'GestureInitializer.detectTaps = true' must be set before BasicGame() instantiation."
    );
  }

  @override
  void onTapDown(TapDownDetails details) {
    if (tapDownCallback != null) {
      tapDownCallback();
    }
  }

  @override
  void onTapCancel() {
    if (tapCancelCallback != null) {
      tapCancelCallback();
    }
  }

  @override
  void onTapUp(TapUpDetails details) {
    if (tapUpCallback != null) {
      tapUpCallback();
    }
  }

}
