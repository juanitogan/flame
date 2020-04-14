import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Assets.rasterCache.load('spritesheet.png');

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {

  MainEntity() {

    final SpriteImage spritesheet = Assets.rasterCache.get('spritesheet.png');
    const spriteWidth  = 16;
    const spriteHeight = 18;

    final vampireComponent = AnimationComponent.fromRaster(
      spritesheet,
      frameWidth:    spriteWidth,
      frameHeight:   spriteHeight,
      frameCount:    8,
      frameDuration: 0.1,
    );
    final ghostComponent = AnimationComponent.fromRaster(
      spritesheet,
      frameTop:      spriteHeight * 1,
      frameWidth:    spriteWidth,
      frameHeight:   spriteHeight,
      frameCount:    8,
      frameDuration: 0.1,
    );

    final vampire = AnimationPrefab(
      vampireComponent,
      position: Vector2(150, 100),
      scale:    Vector2(5, 5),
    );
    final ghost = AnimationPrefab(
      ghostComponent,
      position: Vector2(150, 220),
      scale:    Vector2(5, 5),
    );

    // Slice out some non-animated sprites from the same sheet.
    SpritePrefab(
      SpriteComponent.fromRaster(
        spritesheet,
        frameLeft:     spriteWidth  * 5,
        frameTop:      spriteHeight * 0,
        frameWidth:    spriteWidth,
        frameHeight:   spriteHeight,
      ),
      position: Vector2(50, 100),
      scale:    Vector2(5, 5),
    );

    SpritePrefab(
      SpriteComponent.fromRaster(
        spritesheet,
        frameLeft:     spriteWidth  * 3,
        frameTop:      spriteHeight * 1,
        frameWidth:    spriteWidth,
        frameHeight:   spriteHeight,
      ),
      position: Vector2(50, 220),
      scale:    Vector2(5, 5),
    );

  }
}
