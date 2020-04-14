import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/entities/mixins/single_child_particle.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/particles/curved_particle.dart';

/// Statically offset given child [ParticleComponent] by given [Offset]
/// If you're looking to move the child, consider [MovingParticle]
class MovingParticle extends CurvedParticle with SingleChildParticle {
  @override
  ParticleComponent child;

  final Offset from;
  final Offset to;

  MovingParticle({
    @required this.child,
    @required this.to,
    this.from = Offset.zero,
    double lifespan,
    Curve curve = Curves.linear,
  }) : super(
          lifespan: lifespan,
          curve: curve,
        );

  @override
  void render() {
    GameCanvas.main.save();
      final Offset current = Offset.lerp(from, to, progress);
      GameCanvas.main.translate(current.dx, current.dy);
      super.render();
    GameCanvas.main.restore();
  }
}
