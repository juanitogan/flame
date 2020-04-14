import 'package:pogo/src/entities/game_entity.dart';
import 'package:pogo/src/components/timer_component.dart';

export 'package:pogo/src/entities/game_entity.dart';
export 'package:pogo/src/components/timer_component.dart';

/// Simple entity which wraps a [TimerComponent] instance allowing it to be easily used inside a [Game] game.
///
/// A [GameEntity] containing a [ParticleComponent].
///
/// This creates a prefabricated entity intended for single-use entities.
class TimerPrefab extends GameEntity {
  TimerComponent timerComponent;
  //TODO after expanding timer for resetting, etc:
  //TODO bool destroyOnFinish;

  TimerPrefab(
      this.timerComponent,
      {
        Vector2 position,
        int     zOrder = 0,
        double  rotation,
        double  rotationDeg,
        Vector2 scale,
        bool    enabled = true,
        GameEntity parent,
        //TODO this.destroyOnFinish = false,
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
    timerComponent.update();
    //TODO if (destroyOnFinish && timer.isFinished) {
    if (timerComponent.isFinished) {
      destroy();
    }
  }

}
