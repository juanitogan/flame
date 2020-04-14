import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Assets.audioCache.disableLog();
  await Assets.audioCache.load('boin.mp3');

  final game = Game();
  runApp(game.widget);

  await Screen.waitForStartupSizing();
  MainEntity();
}


class MainEntity extends GameEntity {
  
  Ball ball;

  MainEntity() {
    _start();
  }

  void _start() async {
    Assets.audioCache.loop('music.mp3', volume: 0.4);

    ball = Ball(100, 100)
      ..position.x = 0
      ..position.y = (Screen.size.height / 2) - 50
    ;
  }

  @override
  void update() {
    ball.position.x += (ball.forward ? 1 : -1) * 100 * Time.deltaTime;

    if (ball.position.x <= 0 || ball.position.x + ball.width >= Screen.size.width) {
      if (ball.forward) {
        ball.position.x = Screen.size.width - ball.width - 1;
      } else {
        ball.position.x = 1;
      }

      ball.forward = !ball.forward;
      print('boin');
      Assets.audioCache.play('boin.mp3', volume: 1.0);
    }
  }

}


class Ball extends GameEntity {
  final double width;
  final double height;
  final paint = Paint()..color = const Color(0xFFFFFFFF);
  bool forward = true;

  Ball(this.width, this.height);

  @override
  void update() {
    GameCanvas.main.drawOval(Rect.fromLTWH(0, 0, width, height), paint);
  }
}
