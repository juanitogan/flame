import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/entities/mixins/single_child_particle.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/particles/curved_particle.dart';

/// A particle which rotates its child over the lifespan
/// between two given bounds in radians
class RotatingParticle extends CurvedParticle with SingleChildParticle {
  @override
  ParticleComponent child;

  final double from;
  final double to;

  RotatingParticle({
    @required this.child,
    this.from = 0,
    this.to = 2 * pi,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  double get angle => lerpDouble(from, to, progress);

  @override
  void render() {
    GameCanvas.main.save();
      GameCanvas.main.rotate(angle);
      super.render();
    GameCanvas.main.restore();
  }
}
