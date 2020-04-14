import 'package:pogo/src/components/animation_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/animation_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

/// A [GameEntity] containing a single [AnimationComponent] sprite.
/// This gives a sprite position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use sprites.
class AnimationPrefab extends GameEntity {
  AnimationComponent animationComponent;
  bool destroyOnFinish;

  AnimationPrefab(
      this.animationComponent,
      {
        Vector2 position,
        int     zOrder = 0,
        double  rotation,
        double  rotationDeg,
        Vector2 scale,
        bool    enabled = true,
        GameEntity parent,
        this.destroyOnFinish = false,
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

  //AnimationPrefab.empty();

  @override
  void update() {
    animationComponent.update();
    if (destroyOnFinish && animationComponent.isFinished) {
      destroy();
    }
    animationComponent.render();
  }

  // WARNING: Call super FIRST on render() overrides, to handle entity transforms.
  /*@override
  void render() {
    super.render();
    animationComponent.render();
  }*/

}
