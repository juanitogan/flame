import 'dart:math';

import 'package:pogo/game_engine.dart';

void main() async {
  GestureInitializer.detectTaps = true;

  await Assets.rasterCache.load('chopper.png');

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}

class MainEntity extends GameEntity with GestureArea, TapDetector {

  // Predefine some animation components.
  final animation = AnimationComponent.fromRaster(
      Assets.rasterCache.get('chopper.png'),
      frameCount: 4,
      frameWidth: 48,
      frameHeight: 48,
      frameDuration: 0.1,
  );
  final animationReversed = AnimationComponent.fromRaster(
      Assets.rasterCache.get('chopper.png'),
      frameCount: 4,
      frameWidth: 48,
      frameHeight: 48,
      frameDuration: 0.1,
      reverse: true,
  );

  // Entity constructor.
  MainEntity() {
    // Instantiate some animation entities.
    AnimationPrefab(
        animation,
        position: Vector2(Screen.size.width * 0.3, 100),
        rotationDeg: -90.0,
        scale:    Vector2(2.0, 2.0),
    );

    AnimationPrefab(
        animationReversed,
        position: Vector2(Screen.size.width * 0.7, 100),
        rotationDeg: 90.0,
        scale:    Vector2(2.0, 2.0),
    );
  }

  @override
  void onTapDown(TapDownDetails details) {
    addAnimation(details.globalPosition);
  }

  @override
  void onTapUp(TapUpDetails details) {}

  @override
  void onTapCancel() {}

  void addAnimation(Offset position) {
    AnimationPrefab(
        AnimationComponent.fromRaster(
            Assets.rasterCache.get('chopper.png'),
            frameCount: 4,
            frameWidth: 48,
            frameHeight: 48,
            frameDuration: 0.2,
            loop: false,
        ),
        //position: Vector2(screenSize.width / 2, screenSize.height / 2),
        position: Vector2(position.dx, position.dy),
        rotation: Random().nextDouble() * 2 * pi,
        scale:    Vector2(3, 3) * (Random().nextDouble() + 0.1),
        destroyOnFinish: true
    );
  }

}
