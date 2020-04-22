import 'dart:math';

import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Screen.setFullScreen();
  await Screen.setPortrait();

  GestureInitializer.detectTaps = true;

  await Assets.svgCache.load("planet.svg", scale: 2.0);
  await Assets.svgCache.load("moon.svg", scale: 0.27 * 2.0);

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {

  static const double rotationFactor  = 4.0;
  static const double stretchFactor   = 0.25;
  static const double moonScaleFactor = 0.5;
  static const double moonDistance    = 200.0;

  double startTime = Time.now;

  GameEntity planet;
  Moon moon;
  Vector2 moonCenter = Vector2.zero();

  // Construct the MainEntity and other entities and content.
  MainEntity() {
    // Create some sprite entities, in various ways.
    planet = SpritePrefab(
      SpriteComponent.fromSvgCache("planet.svg"),
      position: Vector2(Screen.size.width / 2, Screen.size.height / 2),
      zOrder: 100,
    );

    moonCenter = Vector2(Screen.size.width / 2, Screen.size.height / 2);

    moon = Moon(moonCenter.clone(), 0);
  }

  // Main game loop.
  @override
  void update() {
    // Rotate the moon (on the wrong axis... this is 2D so why not?).
    moon.rotation += moon.spinDirection * rotationFactor * Time.deltaTime;
    moon.rotation %= 2 * pi; // trims the rotation value to keep it in bounds

    // Set up for the next trick: clock-based transformations.
    double delta = Time.now - startTime;
    if (delta >= 4.0) {
      delta -= 4.0;
      startTime += 4.0; // reset the sequence start time
    }

    // Do more scientifically-wrong stuff while showing off more features
    // like scaling and dynamic Z ordering!
    if (delta < 1.0 || delta >= 4.0) {
      planet.scale.x  = 1 + delta * stretchFactor;
      planet.scale.y  = 1 - delta * stretchFactor;
      moon.scale.x    = moon.scale.y = 1 + sin((1 - delta) * pi / 2) * moonScaleFactor;
      moon.position.y = moonCenter.y - moonDistance * cos((1 - delta) * pi / 2);
    } else if (delta < 2.0) {
      delta -= 1.0;
      planet.scale.x  = 1 + (1 - delta) * stretchFactor;
      planet.scale.y  = 1 - (1 - delta) * stretchFactor;
      moon.scale.x    = moon.scale.y = 1 - sin(delta * pi / 2) * moonScaleFactor;
      moon.position.y = moonCenter.y - moonDistance * cos(delta * pi / 2);
      moon.zOrder     = 200;
    } else if (delta < 3.0) {
      delta -= 2.0;
      planet.scale.x  = 1 - delta * stretchFactor;
      planet.scale.y  = 1 + delta * stretchFactor;
      moon.scale.x    = moon.scale.y = 1 - sin((1 - delta) * pi / 2) * moonScaleFactor;
      moon.position.y = moonCenter.y + moonDistance * cos((1 - delta) * pi / 2);
    } else if (delta < 4.0) {
      delta -= 3.0;
      planet.scale.x  = 1 - (1 - delta) * stretchFactor;
      planet.scale.y  = 1 + (1 - delta) * stretchFactor;
      moon.scale.x    = moon.scale.y = 1 + sin(delta * pi / 2) * moonScaleFactor;
      moon.position.y = moonCenter.y + moonDistance * cos(delta * pi / 2);
      moon.zOrder     = 0;
    }
  }

}


class Moon extends GameEntity with GestureZone, TapDetector {
  SpriteComponent moonSprite;
  int spinDirection = -1;

  Moon(Vector2 position, int zOrder) {
    moonSprite = SpriteComponent.fromSvgCache("moon.svg");
    this.position = position;
    this.zOrder = zOrder;
    gestureZoneSize = moonSprite.frameSize;
  }

  @override
  void update() {
    moonSprite.render();
  }

  @override
  void onTapDown(TapDownDetails details) {
    // Toggle the spin direction.
    spinDirection *= -1;
  }

  @override
  void onTapUp(TapUpDetails details) {
  }

  @override
  void onTapCancel() {
  }

}