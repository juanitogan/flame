import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/entities/mixins/single_child_particle.dart';
import 'package:pogo/src/game/game_canvas_static.dart';

/// Statically offset given child [ParticleComponent] by given [Offset]
/// If you're looking to move the child, consider [MovingParticle]
class TranslatedParticle extends ParticleComponent with SingleChildParticle {
  @override
  ParticleComponent child;
  Offset offset;

  TranslatedParticle({
    @required this.child,
    @required this.offset,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void render() {
    GameCanvas.main.save();
      GameCanvas.main.translate(offset.dx, offset.dy);
      super.render();
    GameCanvas.main.restore();
  }
}
