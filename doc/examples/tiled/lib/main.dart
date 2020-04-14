import 'package:pogo/game_engine.dart';
import 'package:tiled/tiled.dart' show ObjectGroup, TmxObject;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Assets.rasterCache.load('coins.png');

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {

  MainEntity() {
    final TiledComponent tiledMap = TiledComponent('map.tmx');
    TiledPrefab(tiledMap);
    _addCoinsInMap(tiledMap);
  }

  void _addCoinsInMap(TiledComponent tiledMap) async {
    final ObjectGroup obj =
        await tiledMap.getObjectGroupFromLayer("AnimatedCoins");
    if (obj == null) {
      return;
    }
    final coinAnim = AnimationComponent.fromRaster(
      Assets.rasterCache.get('coins.png'),
      frameCount: 8,
      frameWidth: 20,
      frameDuration: 0.1,
    );
    for (TmxObject obj in obj.tmxObjects) {
      AnimationPrefab(
          coinAnim,
          position: Vector2(obj.x.toDouble(), obj.y.toDouble()),
      );
    }
  }

}
