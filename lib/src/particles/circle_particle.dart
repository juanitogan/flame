import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/game/game_canvas_static.dart';

/// Plain circle with no other behaviors
/// Consider composing with other [ParticleComponent]
/// to achieve needed effects
class CircleParticle extends ParticleComponent {
  final Paint paint;
  final double radius;

  CircleParticle({
    @required this.paint,
    this.radius = 10.0,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void render() {
    GameCanvas.main.drawCircle(Offset.zero, radius, paint);
  }
}
