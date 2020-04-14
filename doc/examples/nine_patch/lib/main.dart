import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Assets.rasterCache.load('nine-box.png');

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}

class MainEntity extends GameEntity {

  MainEntity() {
    final sprite = SpriteComponent(Assets.rasterCache.get('nine-box.png'));
    final NinePatchComponent patch = NinePatchComponent(sprite, 200, 300, patchSize: 8, destPatchSize: 24);
    NinePatchPrefab(patch,
        position: Vector2((Screen.size.width - patch.width) / 2, (Screen.size.height - patch.height) / 2)
    );
  }

}
