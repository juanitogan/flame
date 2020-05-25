import 'package:pogo/src/entities/game_entity.dart';
import 'package:pogo/src/components/nine_patch_component.dart';

/// A [GameEntity] containing a [NinePatchComponent].
/// This gives components position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use entities.
class NinePatchPrefab extends GameEntity {
  NinePatchComponent ninePatchComponent;

  NinePatchPrefab(
      this.ninePatchComponent,
      {
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
  );

  @override
  void update() {
    ninePatchComponent.render();
  }

  /*@override
  void render() {
    super.render();
    ninePatchComponent.render();
  }*/

}
