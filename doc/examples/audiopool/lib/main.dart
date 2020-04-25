import 'package:pogo/game_engine.dart';

//TODO yeah... this and/or AudioPool needs work

void main() async {
  GestureInitializer.detectTaps = true;

  runApp(Game().widget);

  await Screen.waitForStartupSizing();
  MainEntity();
}


TextConfig regular = const TextConfig(color: const Color(0xFFFFFFFF));
AudioPool pool = AudioPool('sfx/laser.mp3');


class MainEntity extends GameEntity with GestureArea, TapDetector {

  MainEntity() {
    TextPrefab(
      TextComponent("hit me!", textConfig: regular),
      position: Vector2(Screen.size.width / 2, Screen.size.height / 2),
    );
  }

  @override
  void onTapDown(TapDownDetails details) {
    //print("hit");
    pool.start();
  }

  @override
  void onTapUp(TapUpDetails details) {}

  @override
  void onTapCancel() {}
}
