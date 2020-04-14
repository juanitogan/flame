import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/vector_math.dart';
import 'package:pogo/src/entities/game_entity.dart';

class EntityParticle extends ParticleComponent {
  final GameEntity entity;
  final Vector2 size;
  final Paint overridePaint;

  EntityParticle({
    @required this.entity,
    this.size,
    this.overridePaint,
    double lifespan,
  }) : super(
    lifespan: lifespan,
  );

  @override
  void update() {
    super.update();
    entity.update();
  }

  /*@override
  void render() {
    entity.render();
  }*/
}
