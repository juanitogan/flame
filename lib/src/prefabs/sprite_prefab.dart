import 'package:pogo/src/components/sprite_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/sprite_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

/// A [GameEntity] containing a single [SpriteComponent].
/// This gives a sprite position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use sprites.
class SpritePrefab extends GameEntity {
  SpriteComponent spriteComponent;

  SpritePrefab(
      this.spriteComponent,
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

  SpritePrefab.empty();

  @override
  void update() {
    spriteComponent.render();
  }

  // WARNING: Call super FIRST on render() overrides, to handle entity transforms.
  /*@override
  void render() {
    super.render();
    spriteComponent.render();
  }*/

}
