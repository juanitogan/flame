import 'package:pogo/game_engine.dart';

void main() async {
  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}

class MainEntity extends GameEntity {

  MainEntity() {
    final images = [
      ParallaxImage("bg.png", fill: LayerFill.height),
      ParallaxImage("mountain-far.png", fill: LayerFill.height),
      ParallaxImage("mountains.png", fill: LayerFill.height),
      ParallaxImage("trees.png", fill: LayerFill.height),
      ParallaxImage("foreground-trees.png", fill: LayerFill.height),
    ];

    final parallax = ParallaxComponent(images,
        baseSpeed: const Offset(20, 0),
        layerDelta: const Offset(30, 0)
    );

    ParallaxPrefab(parallax);
  }
}
