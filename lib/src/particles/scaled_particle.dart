import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/entities/mixins/single_child_particle.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/particles/curved_particle.dart';

/// A particle which rotates its child over the lifespan
/// between two given bounds in radians
class ScaledParticle extends CurvedParticle with SingleChildParticle {
  @override
  ParticleComponent child;

  final double scale;

  ScaledParticle({
    @required this.child,
    this.scale = 1.0,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void render() {
    GameCanvas.main.save();
      GameCanvas.main.scale(scale);
      super.render();
    GameCanvas.main.restore();
  }
}
