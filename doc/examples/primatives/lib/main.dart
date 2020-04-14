import 'dart:math' as math;

import 'package:pogo/game_engine.dart';

void main() async {
  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {
  static const speed = 0.25;

  Square square;

  MainEntity() {
    square = Square(64.0, pivot: Pivot.center)
      ..position = Vector2(Screen.size.width / 2, Screen.size.height / 2)
    ;
  }

  @override
  void update() {
    square.rotation += speed * Time.deltaTime;
    square.rotation %= 2 * math.pi; // trims the rotation value to keep it in bounds
  }

}


class Palette {
  static const PaletteEntry white = BasicPalette.white;
  static const PaletteEntry red = PaletteEntry(Color(0xFFFF0000));
  static const PaletteEntry blue = PaletteEntry(Color(0xFF0000FF));
}

class Square extends GameEntity {
  double width;
  double height;
  Pivot pivot;

  Square(double size, {this.pivot = Pivot.topLeft}) {
    width = height = size;
  }

  @override
  void update() {
    // Save the canvas before translating it for the pivot.
    GameCanvas.main.save();
      // Pivot is not a property of the game entity but a feature of some components.
      // Thus, when building your own components with a pivot, you must
      // implement the pivot yourself:
      final Offset o = pivot.translate(Size(height, width));
      GameCanvas.main.translate(o.dx, o.dy);

      // The main white square.
      GameCanvas.main.drawRect(Rect.fromLTWH(0, 0, width, height), Palette.white.paint);
      // A red square in the top-left corner of the white one.
      GameCanvas.main.drawRect(Rect.fromLTWH(0, 0, width / 3, height / 3), Palette.red.paint);
      // A blue square in the center, showing another way to use the Pivot class.
      GameCanvas.main.drawRect(Pivot.center.translateRect(
          Rect.fromLTWH(width / 2, height / 2, width / 3, height / 3)
      ), Palette.blue.paint);
    GameCanvas.main.restore();
  }

}
