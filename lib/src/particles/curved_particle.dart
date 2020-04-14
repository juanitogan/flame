import 'package:flutter/animation.dart';

import 'package:pogo/src/components/particle_component.dart';

/// A [ParticleComponent] which applies certain [Curve] for
/// easing or other purposes to its [progress] getter.
class CurvedParticle extends ParticleComponent {
  final Curve curve;

  CurvedParticle({
    this.curve = Curves.linear,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  double get progress => curve.transform(super.progress);
}
