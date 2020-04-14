import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Screen.setFullScreen();
  await Screen.setPortrait();

  GestureInitializer.detectSingleTaps = true;
  GestureInitializer.detectDoubleTaps = true;

  Game().debugMode = true;
  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {
  final TextConfig fpsTextConfig = TextConfig(color: BasicPalette.white.color);
  TextPrefab fpsText;

  MainEntity() {
    Player(Vector2(Screen.size.width / 2, Screen.size.height / 2));
    fpsText = TextPrefab(
        TextComponent("", textConfig: fpsTextConfig, pivot: Pivot.topLeft),
        position: Vector2(0, 20),
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


class Player extends GameEntity with SingleTapDetector, DoubleTapDetector {
  Size screenSize;

  final List<String> _animations = ["Stand", "Wave", "Jump", "Dance"];
  int _currentAnimation = 0;
  FlarePrefab flareAnim;

  bool loaded = false;

  Player(Vector2 position) {
    this.position = position;
    FlareComponent.fromFile("assets/Bob_Minion.flr", "Stand", scale: 0.33)
        .then((comp) => flareAnim = FlarePrefab(comp, parent: this))
    ;
  }

  @override
  void onSingleTap() {
    cycleAnimation();
  }

  @override
  void onDoubleTap() {
    flareAnim.scale.x += 0.1;
    flareAnim.scale.y += 0.1;
    flareAnim.position.y += 20;
  }

  void cycleAnimation() {
    if (_currentAnimation == _animations.length - 1) {
      _currentAnimation = 0;
    } else {
      _currentAnimation++;
    }
    flareAnim.flareComponent.setAnimation(_animations[_currentAnimation]);
  }

}
