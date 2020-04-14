import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:pogo/src/components/particle_component.dart';
import 'package:pogo/src/game/game_canvas_static.dart';

/// A [ParticleComponent] which renders given [Image] on a [Canvas]
/// image is centered. If any other behavior is needed, consider
/// using [ComputedParticle].
class ImageParticle extends ParticleComponent {
  /// dart.ui [Image] to draw
  Image image;

  Rect src;
  Rect dest;

  ImageParticle({
    @required this.image,
    Size size,
    double lifespan,
  }) : super(lifespan: lifespan) {
    final srcWidth = image.width.toDouble();
    final srcHeight = image.height.toDouble();
    final destWidth = size?.width ?? srcWidth;
    final destHeight = size?.height ?? srcHeight;

    src = Rect.fromLTWH(0, 0, srcWidth, srcHeight);
    dest =
        Rect.fromLTWH(-destWidth / 2, -destHeight / 2, destWidth, destHeight);
  }

  @override
  void render() {
    GameCanvas.main.drawImageRect(image, src, dest, Paint());
  }
}
