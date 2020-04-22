import 'package:flutter/material.dart';
import 'package:pogo/game_engine.dart';

void main() {
  GestureInitializer.detectSingleTaps = true;
  runApp(ExampleGame().widget);
}

class ExampleGame extends Game with HasWidgetsOverlay {
  bool isPaused = false;

  ExampleGame() : super.empty() {}

  @override
  void update() {
    GameCanvas.main.drawRect(const Rect.fromLTWH(100, 100, 100, 100),
        Paint()..color = const Color(0xFFFFFFFF)
    );
  }

  //TODO tapping throws an error:
  // The following StateError was thrown while handling a gesture:
  // Bad state: Cannot add event after closing

  @override
  void onSingleTap() {
    if (isPaused) {
      removeWidgetOverlay('PauseMenu');
      isPaused = false;
    } else {
      addWidgetOverlay(
          'PauseMenu',
          Center(
            child: Container(
              width: 100,
              height: 100,
              color: const Color(0xFFFF0000),
              child: const Center(child: const Text('Paused')),
            ),
          ));
      isPaused = true;
    }
  }
}
