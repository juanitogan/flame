import 'package:flutter/material.dart';
import 'package:pogo/game_engine.dart';

void main() {
  GestureInitializer.detectSingleTaps = true;
  GestureInitializer.detectDoubleTaps = true;

  runApp(GameWidget());
}

class GameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/': (BuildContext context) => Column(children: [
            RaisedButton(
                child: const Text("Example 1"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/ex1");
                }),
            RaisedButton(
                child: const Text("Example 2"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/ex2");
                })
          ]),
      '/ex1': (BuildContext context) {Game(); Example1(); return Game().widget;},
      '/ex2': (BuildContext context) {Game(); Example2(); return Game().widget;}
    });
  }
}


class Example1 extends GameEntity with SingleTapDetector {
  final TextConfig textConfig = const TextConfig(color: const Color(0xFFFFFFFF));
  TextPrefab countdownText;
  TextPrefab intervalText;
  TimerComponent countdown;
  TimerComponent interval;

  int elapsedSecs = 0;

  Example1() {
    TextPrefab(
        TextComponent("Tap me!", textConfig: textConfig, pivot: Pivot.topLeft),
        position: Vector2(10, 30)
    );

    countdownText = TextPrefab(
        TextComponent("", textConfig: textConfig, pivot: Pivot.topLeft),
        position: Vector2(10, 100)
    );
    intervalText = TextPrefab(
        TextComponent("", textConfig: textConfig, pivot: Pivot.topLeft),
        position: Vector2(10, 150)
    );

    countdown = TimerComponent(2);
    interval = TimerComponent(1,
        repeat: true,
        callback: () {elapsedSecs += 1;}
    );
    interval.start();
  }

  @override
  void onSingleTap() {
    countdown.start();
  }

  @override
  void update() {
    countdown.update();
    interval.update();
    countdownText.textComponent.text = "Countdown: ${countdown.elapsed.toString()}";
    intervalText.textComponent.text = "Elapsed time: $elapsedSecs";
  }
}


class Example2 extends GameEntity with SingleTapDetector, DoubleTapDetector {
  RenderedTimer timer1;
  RenderedTimer timer5;

  Example2() {
    TextPrefab(
        TextComponent(
            "Tap or double-tap me!",
            textConfig: const TextConfig(color: const Color(0xFFFFFFFF)),
            pivot: Pivot.topLeft
        ),
        position: Vector2(10, 30)
    );
  }

  @override
  void onSingleTap() {
    //TODO These currently auto-destroy. Fix this when that default changes.
    RenderedTimer(TimerComponent(1)..start(), Vector2(10, 150));
  }

  @override
  void onDoubleTap() {
    //TODO These currently auto-destroy. Fix this when that default changes.
    RenderedTimer(TimerComponent(5)..start(), Vector2(10, 200));
  }
}


class RenderedTimer extends TimerPrefab {
  final TextConfig textConfig = const TextConfig(color: const Color(0xFFFFFFFF));
  TextComponent textComp;

  RenderedTimer(
      TimerComponent timer,
      Vector2 position
  ) : super(
      timer,
      position: position
  ) {
    textComp = TextComponent("", textConfig: textConfig, pivot: Pivot.topLeft);
  }

  @override
  void update() {
    super.update();
    textComp.text = "Elapsed time: ${timerComponent.elapsed}";
    textComp.render();
  }
}
