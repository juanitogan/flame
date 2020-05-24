import 'package:pogo/src/components/particle_component.dart';

/// Implements basic behavior for nesting [ParticleComponent] instances
/// into each other.
///
/// ```dart
/// class BehaviorParticle extends Particle with SingleChildParticle {
///   Particle child;
///
///   BehaviorParticle({
///     @required this.child
///   });
///
///   @override
///   update() {
///     // Will ensure that child [Particle] is properly updated
///     super.update();
///
///     // ... Custom behavior
///   }
/// }
/// ```
mixin SingleChildParticle on ParticleComponent {
  ParticleComponent child;

  @override
  void setLifespan(double lifespan) {
    assert(child != null);

    super.setLifespan(lifespan);
    child.setLifespan(lifespan);
  }

  @override
  void render() {
    assert(child != null);

    child.render();
  }

  @override
  void update() {
    assert(child != null);

    super.update();
    child.update();
  }
}
