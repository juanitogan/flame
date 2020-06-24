import 'package:pogo/game_engine.dart';

// Note that this doesn't always work well in the in the emulators
// but works fine on a device.

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
    pool.init();
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
