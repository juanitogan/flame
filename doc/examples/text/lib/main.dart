import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  System.defaultPivot = Pivot.topLeft;

  runApp(Game().widget);

  await Screen.waitForStartupSizing();

  MainEntity();
}


TextConfig regular = TextConfig(color: BasicPalette.white.color);
TextConfig tiny    = regular.copyWith(fontSize: 12.0);

class MainEntity extends GameEntity {
  MessageBoxPrefab msgBox;

  MainEntity() {
    TextPrefab(
        TextComponent('Hello, Pogo!', textConfig: regular, pivot: Pivot.topCenter),
        position: Vector2(Screen.size.width / 2, 32.0)
    );

    TextPrefab(
        TextComponent('center', textConfig: tiny, pivot: Pivot.center),
        position: Vector2(Screen.size.width / 2, Screen.size.height / 2)
    );

    TextPrefab(
        TextComponent('bottomRight', textConfig: tiny, pivot: Pivot.bottomRight),
        position: Vector2(Screen.size.width, Screen.size.height)
    );

    msgBox = MessageBoxPrefab(
        MyMsgBox(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            pivot: Pivot.bottomLeft
        ),
        position: Vector2(0.0, Screen.size.height)
    );
  }

  @override
  void update() {
    // Redo the message box every few seconds.
    if (Time.frameCount != 0 && Time.frameCount % 600 == 0) {
      msgBox.messageBoxComponent = MyMsgBox(
          "Blah blah blah. Blah blah blah."
              " Blabber blabber blabber. Blabber blabber blabber."
              " Blah blah blah. Blah blah blah.",
          pivot: Pivot.bottomLeft
      );
    }
  }

}


class MyMsgBox extends MessageBoxComponent {
  MyMsgBox(String text, {Pivot pivot}) : super(
    text,
    maxWidth: 200.0,
    padding: 8,
    charDuration: 0.05,
    textConfig: tiny,
    pivot: pivot,
  );

  @override
  void drawBackground(Canvas c) {
    final Rect rect = Rect.fromLTWH(0, 0, currentWidth, currentHeight);
    // Draw a filled magenta rectangle the size of the message box.
    c.drawRect(rect, Paint()..color = const Color(0xFFFF00FF));
    // Draw an unfilled black rectangle inside the padding area.
    c.drawRect(
        rect.deflate(padding),
        Paint()
          ..color = BasicPalette.black.color
          ..style = PaintingStyle.stroke
    );
  }
}
