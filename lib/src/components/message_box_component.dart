import 'dart:math' as math;

import 'package:flutter/widgets.dart' as widgets;
import 'package:meta/meta.dart';
import 'package:pogo/src/components/text_config.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/system_static.dart';
import 'package:pogo/src/game/time_static.dart';

export 'package:pogo/src/components/text_config.dart';

//TODO rewrite

/// Multi-line message box that types out text at a rate controlled by [charDuration].
///
/// * [text]: string to draw (required)
/// * [maxWidth]: maximum width to allow for each line (required)
/// * [padding]: padding to add to all sides (default: 0.0)
/// * [charDuration]: seconds to pause between display of each character (default: 0.0, that is, instant display of all text)
/// * [endOfMessagePause]: seconds to pause after last character is displayed before setting the `isFinished` flag (default: 0.0)
/// * [textConfig]: [TextConfig] reference for setting font style, etc. (default: `TextConfig` default)
class MessageBoxComponent {

  static final Paint _highQualityPaint = System.defaultPaint
    ..filterQuality = FilterQuality.high; //TODO double-check this; author explains nothing; TextComponent doesn't use it

  final String _text;
  String get text => _text;

  double _maxWidth;
  double _padding; // all sides... it seems
  double _charDuration; // in seconds
  double _endOfMessagePause; // in seconds
  double get maxWidth          => _maxWidth;
  double get padding           => _padding;
  double get charDuration      => _charDuration;
  double get endOfMessagePause => _endOfMessagePause;

  TextConfig _config;
  TextConfig get textConfig => _config;

  Pivot pivot;

  final List<String> _lines = [];
  double _maxLineWidth = 0.0;
  double _lineHeight;

  final double _startTime = Time.now;
  double get elapsed => Time.now - _startTime;
  Image _cache;


  MessageBoxComponent(
      this._text,
      {
        @required double maxWidth,
        double padding = 0.0, // default was 8.0, but that's huge for low-res
        double charDuration = 0.0, // in seconds
        double endOfMessagePause = 0.0, // in seconds
        TextConfig textConfig = const TextConfig(),
        this.pivot,
      }
  ) {
    _maxWidth = maxWidth;
    _padding = padding;
    _charDuration = charDuration;
    _endOfMessagePause = endOfMessagePause;
    _config = textConfig;
    pivot ??= System.defaultPivot;

    text.split(" ").forEach((word) {
      String possibleLine;
      if (_lines.isEmpty) {
        _lines.add("");
        possibleLine = word;
      } else {
        possibleLine = _lines.last + " " + word;
      }
      final widgets.TextPainter tp = textConfig.getTextPainter(possibleLine);
      _lineHeight ??= tp.height;
      if (tp.width <= maxWidth - 2 * padding) {
        _lines.last = possibleLine;
        _updateMaxWidth(tp.width);
      } else {
        _lines.add(word);
        _updateMaxWidth(textConfig.getTextPainter(word).width);
      }
    });

    _redrawLater();
  }


  void _updateMaxWidth(double w) {
    if (w > _maxLineWidth) {
      _maxLineWidth = w;
    }
  }

  // Final width and height.
  double get width => _withPadding(_maxLineWidth);
  double get height => _withPadding(_lineHeight * _lines.length);

  double get totalCharDuration => text.length * charDuration;

  bool get isFinished => elapsed > totalCharDuration + endOfMessagePause;

  int _previousChar = -1;

  int get _currentChar => charDuration == 0.0
      ? text.length - 1
      : math.min(elapsed ~/ charDuration, text.length - 1);

  int get _currentLine {
    int totalCharCount = 0;
    final int currentChar = _currentChar;
    for (int i = 0; i < _lines.length; i++) {
      totalCharCount += _lines[i].length + 1; // +1 for the space removed between lines
      if (totalCharCount > currentChar) {
        return i;
      }
    }
    return _lines.length - 1; // always 0
  }

  double _withPadding(double size) => size + 2 * padding;

  double get currentWidth => _currentWidth ?? 0.0;
  double get currentHeight => _currentHeight ?? 0.0;

  double _getLineWidth(String line, int charCount) {
    return _withPadding(textConfig
        .getTextPainter(line.substring(0, math.min(charCount, line.length)))
        .width);
  }

  double get _currentWidth {
    int i = 0;
    int totalCharCount = 0;
    final int currentChar = _currentChar;
    final int currentLine = _currentLine;
    return _lines.sublist(0, currentLine + 1).map((line) {
      final int charCount =
          (i < currentLine) ? line.length : currentChar - totalCharCount + 1;
      totalCharCount += line.length;
      i++;
      return _getLineWidth(line, charCount);
    }).reduce(math.max);
  }

  double get _currentHeight => _withPadding((_currentLine + 1) * _lineHeight);


  void update() {
    if (_currentChar != _previousChar) {
      _redrawLater();
      _previousChar = _currentChar;
    }
  }

  void render() {
    if (_cache == null) {
      return;
    }
    final Offset o = pivot.translate(Size(currentWidth, currentHeight));
    GameCanvas.main.save();
      GameCanvas.main.translate(o.dx, o.dy);
      GameCanvas.main.drawImage(_cache, Offset.zero, _highQualityPaint);
    GameCanvas.main.restore();
  }


  void drawBackground(Canvas c) {}

  Future<Image> _redrawCache() {
    final PictureRecorder recorder = PictureRecorder();
    //TODO why currentWidth/Height limitation???
    //TODO must it be on its own canvas? author left no notes explaining anything (just what I've added)
    final Canvas c = Canvas(
        recorder, Rect.fromLTWH(0.0, 0.0, currentWidth, currentHeight));
    _fullRender(c);
    return recorder.endRecording().toImage(currentWidth.toInt(), currentHeight.toInt());
  }

  void _fullRender(Canvas c) {
    drawBackground(c);

    final int currentLine = _currentLine;
    int charCount = 0;
    double dy = padding;
    // Paint fully-typed out lines (but not last line).
    for (int line = 0; line < currentLine; line++) {
      charCount += _lines[line].length + 1; // +1 for the space removed between lines
      textConfig
          .getTextPainter(_lines[line])
          .paint(c, Offset(padding, dy));
      dy += _lineHeight;
    }
    // Paint partial line or last line.
    final int max =
        math.min(_currentChar - charCount + 1, _lines[currentLine].length);
    textConfig
        .getTextPainter(_lines[currentLine].substring(0, max))
        .paint(c, Offset(padding, dy));
  }

  void _redrawLater() async {
    _cache = await _redrawCache();
  }

}
