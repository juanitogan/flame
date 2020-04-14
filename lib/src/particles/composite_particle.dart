import 'package:pogo/src/components/particle_component.dart';
import 'package:flutter/foundation.dart';

/// A single [ParticleComponent] which manages multiple children
/// by proxying all lifecycle hooks.
class CompositeParticle extends ParticleComponent {
  final List<ParticleComponent> children;

  CompositeParticle({
    @required this.children,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void setLifespan(double lifespan) {
    super.setLifespan(lifespan);

    for (var child in children) {
      child.setLifespan(lifespan);
    }
  }

  @override
  void render() {
    for (var child in children) {
      child.render();
    }
  }

  @override
  void update() {
    super.update();

    for (var child in children) {
      child.update();
    }
  }
}
