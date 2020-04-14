import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/components/sprite_component.dart';
import 'package:pogo/src/vector_math.dart';

class SpriteParticle extends ParticleComponent {
  final SpriteComponent sprite;
  final Vector2 size;
  final Paint paint;

  SpriteParticle({
    @required this.sprite,
    this.size,
    this.paint,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void render() {
    //TODO so something with size^^^ -- probably replace with scale if even relevant still
    sprite.render(paint: paint);
  }
}
