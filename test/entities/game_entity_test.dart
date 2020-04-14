import 'package:pogo/game_engine.dart';
import 'package:test/test.dart';

void main() {
  group("GameEntity intrinsic components test", () {

    test("test get/set position", () {
      final GameEntity e = SpritePrefab(SpriteComponent.empty());
      e.position.x = 2.2;
      e.position.y = 3.4;
      expect(e.position.x, 2.2);
      expect(e.position.y, 3.4);

      e.position = Vector2(1.0, 0.0);
      expect(e.position.x, 1.0);
      expect(e.position.y, 0.0);
    });

    test("test get/set zOrder", () {
      final GameEntity e = SpritePrefab(SpriteComponent.empty(), zOrder: 1);
      expect(e.zOrder, 1);
    });

    test("test get/set rotation", () {
      final GameEntity e = SpritePrefab(SpriteComponent.empty());
      e.rotation = 1.0;
      expect(e.rotationDeg, 1.0 * radians2Degrees);

      e.rotationDeg = 90.0;
      expect(e.rotationDeg, 90.0 * degrees2Radians);
    });

    test("test get/set scale", () {
      final GameEntity e = SpritePrefab(SpriteComponent.empty());
      e.scale.x = 2.2;
      e.scale.y = 3.4;
      expect(e.scale.x, 2.2);
      expect(e.scale.y, 3.4);

      e.scale = Vector2(1.0, 0.0);
      expect(e.scale.x, 1.0);
      expect(e.scale.y, 0.0);
    });

  });
}
