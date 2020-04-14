import 'package:pogo/game_engine.dart';

import 'package:flutter/services.dart';

class MainEntity extends GameEntity {
  static final Paint paint = Paint()..color = const Color(0xFFFFFFFF);

  var movingLeft = false;
  var movingRight = false;
  var movingUp = false;
  var movingDown = false;

  MainEntity() {
    _start();
  }

  void _start() {
    RawKeyboard.instance.addListener((RawKeyEvent e) {
      final bool isKeyDown = e is RawKeyDownEvent;

      final keyLabel = e.data.logicalKey.keyLabel;

      if (keyLabel == "a") {
        movingLeft = isKeyDown;
      }

      if (keyLabel == "d") {
        movingRight = isKeyDown;
      }

      if (keyLabel == "w") {
        movingUp = isKeyDown;
      }

      if (keyLabel == "s") {
        movingDown = isKeyDown;
      }
    });
  }

  @override
  void update() {
    if (movingLeft) {
      position.x -= 100 * Time.deltaTime;
    } else if (movingRight) {
      position.x += 100 * Time.deltaTime;
    }

    if (movingUp) {
      position.y -= 100 * Time.deltaTime;
    } else if (movingDown) {
      position.y += 100 * Time.deltaTime;
    }

    GameCanvas.main.drawRect(Rect.fromLTWH(position.x, position.y, 100, 100), paint);
  }
}
