import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Assets.svgCache.load("android.svg", scale: 2.54);

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {

  MainEntity() {
    _start();
  }

  void _start() {
    // A SpriteComponent can contain either an SVG or a raster image.
    // Side Note: Because animations are a list of SpriteComponents,
    // an AnimationComponent can also be built up from SVGs.
    SpritePrefab(
      SpriteComponent.fromSvgCache("android.svg"),
      position: Vector2(Screen.size.width / 2, Screen.size.height / 2),
    );
  }
}
