import 'package:pogo/src/components/flare_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/flare_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

class FlarePrefab extends GameEntity {
  FlareComponent flareComponent;

  FlarePrefab(
      this.flareComponent,
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
    flareComponent.update();
    flareComponent.render();
  }

  /*@override
  void render() {
    super.render();
    flareComponent.render();
  }*/

}
