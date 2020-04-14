import 'package:pogo/src/components/tiled_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/tiled_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

/// A [GameEntity] containing a [TiledComponent].
/// This gives components position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use entities.
class TiledPrefab extends GameEntity {
  TiledComponent tiledComponent;

  TiledPrefab(
      this.tiledComponent,
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
    tiledComponent.render();
  }

  /*@override
  void render() {
    super.render();
    tiledComponent.render();
  }*/

}
