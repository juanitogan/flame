import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/animation_component.dart';
import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/vector_math.dart';

class AnimationParticle extends ParticleComponent {
  final AnimationComponent animation;
  final Vector2 size;
  final Paint paint;
  final bool alignAnimationTime;

  AnimationParticle({
    @required this.animation,
    this.size,
    this.paint,
    double lifespan,
    this.alignAnimationTime = true,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void setLifespan(double lifespan) {
    super.setLifespan(lifespan);

    if (alignAnimationTime && lifespan != null) {
      animation.setFrameDuration = lifespan / animation.frames.length;
      animation.reset();
    }
  }

  @override
  void render() {
    //TODO so something with size -- probably replace with scale if even relevant still
    animation.getCurrentSprite().render(paint: paint,);
  }

  @override
  void update() {
    super.update();
    animation.update();
  }
}
