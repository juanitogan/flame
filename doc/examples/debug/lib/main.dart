import 'package:pogo/game_engine.dart';

void main() async {
  Game().debugMode = true;
  runApp(Game().widget);

  await Assets.svgCache.load('android.svg', scale: 1.0);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {
  final TextConfig fpsTextConfig = const TextConfig(color: const Color(0xFFFFFFFF));
  TextPrefab fpsText;

  MainEntity() {
    // Instantiate some androids (var assignment not really needed in this simple demo).
    final android1 = Android(Vector2(100, 400), 1, 1);
    final android2 = Android(Vector2(100, 400), 1, -1);
    final android3 = Android(Vector2(100, 400), -1, 1);

    fpsText = TextPrefab(
      TextComponent("", textConfig: fpsTextConfig, pivot: Pivot.topLeft),
      position: Vector2(0, 50),
      enabled: false,
    );
  }

  @override
  void update() {
    fpsText.enabled = Game().debugMode;
    if (fpsText.enabled) {
      fpsText.textComponent.text = Game().fps(120).toStringAsFixed(1);
    }
  }
}


class Android extends SpritePrefab {
  static const int speed = 150;
  int xDirection = 1;
  int yDirection = 1;

  Android(Vector2 position, this.xDirection, this.yDirection) : super(
    SpriteComponent.fromSvgCache('android.svg'),
    position: position,
  );

  @override
  void update() {

    position.x += xDirection * speed * Time.deltaTime;

    if ((position.x - spriteComponent.frameWidth / 2 <= 0 && xDirection == -1) ||
        (position.x + spriteComponent.frameWidth / 2 >= Screen.size.width && xDirection == 1))
    {
      xDirection *= -1;
    }

    position.y += yDirection * speed * Time.deltaTime;

    if ((position.y - spriteComponent.frameHeight / 2 <= 0 && yDirection == -1) ||
        (position.y + spriteComponent.frameHeight / 2 >= Screen.size.height && yDirection == 1))
    {
      yDirection *= -1;
    }
  }
}
