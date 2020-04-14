import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/flare_component.dart';
import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/game/game_canvas_static.dart';

class FlareParticle extends ParticleComponent {
  final FlareComponent flare;

  FlareParticle({
    @required this.flare,
    double lifespan,
  }) : super(
          lifespan: lifespan,
        );

  @override
  void render() {
    GameCanvas.main.save();
      GameCanvas.main.translate(-flare.width / 2, -flare.height / 2);
      flare.render();
    GameCanvas.main.restore();
  }

  @override
  void update() {
    super.update();
    flare.update();
  }
}
