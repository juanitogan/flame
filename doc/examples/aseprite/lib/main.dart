import 'package:pogo/game_engine.dart';

void main() async {
  runApp(Game().widget);
  await Screen.waitForStartupSizing();
  MainEntity();
}

class MainEntity extends GameEntity {

  MainEntity() {
    _start();
  }

  void _start() async {
    final animation = await AnimationComponent.fromAsepriteData(
        'chopper.png', 'images/chopper.json'
    );
    AnimationPrefab(
        animation,
        position: Vector2(Screen.size.width / 2, Screen.size.height / 2),
        scale:    Vector2(4, 4),
    );
  }
}
