import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GestureInitializer.detectSingleTaps = true;
  GestureInitializer.detectDoubleTaps = true;
  GestureInitializer.detectTaps = true;
  GestureInitializer.detectPans = true;

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


class MainEntity extends GameEntity {
  MainEntity() {
    Box(Vector2(Screen.size.width / 2, Screen.size.height / 2));
  }
}


class Box extends GameEntity with
    SingleTapDetector, DoubleTapDetector, GestureZone, TapDetector, PanDetector
{
  final _whitePaint = Paint()..color = const Color(0xFFFFFFFF);
  final _redPaint = Paint()..color = const Color(0xFFFF0000);
  final _greenPaint = Paint()..color = const Color(0xFF00FF00);
  final _bluePaint = Paint()..color = const Color(0xFF0000FF);
  final _magentaPaint = Paint()..color = const Color(0xFFFF00FF);
  final _yellowPaint = Paint()..color = const Color(0xFFFFFF00);

  Paint _paint;

  final Rect _rect = const Rect.fromLTWH(0, 0, 50, 50);

  Box(Vector2 position) {
    this.position = position;
    gestureZoneOffset = _rect.topLeft;
    gestureZoneSize = _rect.size; // Should cheat bigger for pan objects.
    gestureZonePivot = Pivot.center;
    _paint = _whitePaint;
  }

  @override
  void update() {
    GameCanvas.main.drawRect(Pivot.center.translateRect(_rect), _paint);
  }

  // Note: It is probably not the best idea to try to use onSingleTap and
  // onDoubleTap in game development.  They are only included here for
  // demonstration purpose versus onTapDown/Up/Cancel.

  @override
  void onSingleTap() {
    _paint = _paint == _whitePaint ? _bluePaint : _whitePaint;
  }

  @override
  void onDoubleTap() {
    _paint = _greenPaint;
  }

  // TapDetector:
  @override
  void onTapDown(TapDownDetails details) {
    _paint = _yellowPaint;
  }
  @override
  void onTapUp(TapUpDetails details) {
    _paint = _redPaint; // Never happens because onSingleTap() wins.
  }
  @override
  void onTapCancel() {
    _paint = _magentaPaint;
  }

  // PanDetector:
  @override
  void onPanStart(DragStartDetails details) {
  }
  @override
  void onPanUpdate(DragUpdateDetails details) {
    position.x += details.delta.dx;
    position.y += details.delta.dy;
  }
  @override
  void onPanEnd(DragEndDetails details) {
  }

}
