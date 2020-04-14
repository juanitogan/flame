import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/entities/mixins/single_child_particle.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/time_static.dart';
import 'package:pogo/src/particles/curved_particle.dart';

/// A particle serves as a container for basic
/// acceleration physics.
/// [Offset] unit is logical px per second.
/// speed = Offset(0, 100) is 100 logical pixels per second, down
/// acceleration = Offset(-40, 0) will accelerate to left at rate of 40 px/s
class AcceleratedParticle extends CurvedParticle with SingleChildParticle {
  @override
  ParticleComponent child;

  final Offset acceleration;
  Offset speed;
  Offset position;

  AcceleratedParticle({
    @required this.child,
    this.acceleration = Offset.zero,
    this.speed = Offset.zero,
    this.position = Offset.zero,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void render() {
    GameCanvas.main.save();
      GameCanvas.main.translate(position.dx, position.dy);
      super.render();
    GameCanvas.main.restore();
  }

  @override
  void update() {
    speed += acceleration * Time.deltaTime;
    position += speed * Time.deltaTime - (acceleration * pow(Time.deltaTime, 2)) / 2;

    super.update();
  }
}
