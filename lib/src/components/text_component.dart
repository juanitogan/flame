import 'package:pogo/src/components/text_config.dart';
import 'package:pogo/src/game/system_static.dart';
import 'package:pogo/src/game/game_canvas_static.dart';

export 'package:pogo/src/components/text_config.dart';
export 'package:pogo/src/pivot.dart';

class TextComponent {

  String _text;
  String get text => _text;
  set text(String text) {
    _text = text;
    _textPainter = _textConfig.getTextPainter(text);
  }

  TextConfig _textConfig;
  TextConfig get textConfig => _textConfig;
  set textConfig(TextConfig textConfig) {
    _textConfig = textConfig;
    _textPainter = _textConfig.getTextPainter(text);
  }

  Pivot pivot;

  TextPainter _textPainter;

  Size get size => _textPainter.size;
  double get width => _textPainter.width;
  double get height => _textPainter.height;


  TextComponent(
      this._text, // don't call setter yet
      {
        TextConfig textConfig,
        this.pivot,
      }
  ) {
    this.textConfig = textConfig ?? const TextConfig(); // now call setter
    pivot ??= System.defaultPivot;
  }


  void render() {
    final Offset o = pivot.translate(_textPainter.size);
    GameCanvas.main.save();
      GameCanvas.main.translate(o.dx, o.dy);
      _textPainter.paint(GameCanvas.main, Offset.zero);
    GameCanvas.main.restore();
    //textConfig.render(text, Offset.zero, pivot: pivot);
  }

}
