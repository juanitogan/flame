import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/particle_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

//TODO prefab and component need more work to Pogo-ize; just some quick changes for now

/// A [GameEntity] containing a [ParticleComponent].
/// This gives components position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use entities.
class ParticlePrefab extends GameEntity {
  ParticleComponent particleComponent;

  ParticlePrefab(
      this.particleComponent,
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

  /// Returns progress of the child [ParticleComponent]
  /// so could be used by external code for something
  double get progress => particleComponent.progress;

  /// Passes update chain to child [ParticleComponent].
  @override
  void update() {
    particleComponent.update();
    // This [BasicGameEntity] will be automatically destroyed as soon as
    if (particleComponent.destroy()) {
      destroy();
    }
    particleComponent.render();
  }

  /// Passes rendering chain down to the inset
  /// [ParticleComponent] within this [GameEntity].
  /*@override
  void render() {
    super.render();
    particleComponent.render();
  }*/

}
