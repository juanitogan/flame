import 'dart:ui';

import 'package:flutter/material.dart';

export 'dart:ui';
export 'package:flutter/material.dart' show TextPainter;

/// A Text Config contains all typographical information required to render
/// texts; i.e., font size and color, family, etc.
///
/// It does not hold information regarding the position of the text to be
/// rendered, neither the text itself (the string).
/// To hold all that information, use [TextComponent] in a [GameEntity].
class TextConfig {

  /// The font family to be used. You can use available by default fonts for your platform (like Arial), or you can add custom fonts.
  ///
  /// To add custom fonts, add the following code to your pubspec.yml file:
  ///
  ///     flutter:
  ///       fonts:
  ///         - family: 5x5
  ///           fonts:
  ///             - asset: assets/fonts/5x5_pixel.ttf
  /// In this example we are adding a font family that's being named '5x5' provided in the specified ttf file.
  /// You must provide the full path of the ttf file (from root); you should put it into your assets folder, and preferably inside a fonts folder.
  /// You don't need to add this together with the other assets on the flutter/assets bit.
  /// The name you choose for the font family can be any name (it's not inside the TTF file and the filename doesn't need to match).
  final String fontFamily;

  /// The font size to be used, in points.
  final double fontSize;

  /// The font color to be used.
  ///
  /// Dart's [Color] class is just a plain wrapper on top of ARGB color (0xFFrrggbb).
  /// For example,
  ///
  ///     const TextConfig config = TextConfig(color: const Color(0xFF00FF00)); // green
  ///
  /// You can also use your Palette class to access colors used in your game.
  final Color color;
  // Maybe need not be final as this does not affect TextPainter.Size,
  // but final for now as it must be so for const declaration.

  /// The [TextAlign] to be used when creating the [TextPainter].
  ///
  /// Warning: It is recommended to leave this at the default value of [TextAlign.left].
  /// Use a [Pivot] to align otherwise.
  final TextAlign textAlign;

  /// The direction to render this text (left to right or right to left).
  ///
  /// Normally, leave this as is for most languages.
  /// For proper fonts of languages like Hebrew or Arabic, replace this with [TextDirection.rtl].
  final TextDirection textDirection;


  /// Creates a constant [TextConfig] with sensible defaults.
  ///
  /// Or, every/any parameter can be specified.
  const TextConfig({
    this.fontFamily    = 'Arial',
    this.fontSize      = 24.0,
    this.color         = const Color(0xFF000000),
    this.textAlign     = TextAlign.left,
    this.textDirection = TextDirection.ltr,
  });


  /// Returns a [TextPainter] that allows for text rendering and size measuring.
  ///
  /// A [TextPainter] has three important properties: paint, width and height (or size).
  ///
  /// Example usage:
  ///
  ///     const TextConfig config = TextConfig(fontSize: 48.0, fontFamily: 'Awesome Font');
  ///     final tp = config.toTextPainter('Score: $score');
  ///     tp.paint(c, Offset(size.width - p.width - 10, size.height - p.height - 10));
  ///
  TextPainter getTextPainter(String text) {
    final TextStyle style = TextStyle(
      color:      color,
      fontSize:   fontSize,
      fontFamily: fontFamily,
    );
    final TextSpan span = TextSpan(
      style: style,
      text:  text,
    );
    final TextPainter tp = TextPainter(
      text:          span,
      textAlign:     textAlign,
      textDirection: textDirection,
    );
    tp.layout();
    return tp;
  }


  // (questionable) HELPERS ////////

  // I would rather have a single deep-copy function that I then modify manually...
  // but, oh, these props are final... for good reason of needing to recalc
  // TextPainter with each change.
  //
  //TODONE Should maybe instead have a TextConfig.fromTextConfig/copy/copyWith constructor...
  //     or a clone/cloneWith method with optional parameters... or both like Vector2 has...
  //     or just the copyWith method like TextTheme and ThemeData have... yes, that.

  /// Returns a copy of this text config but with the given fields replaced with the new values.
  TextConfig copyWith({
    String        fontFamily,
    double        fontSize,
    Color         color,
    TextAlign     textAlign,
    TextDirection textDirection,
  }) {
    return TextConfig(
      fontFamily:    fontFamily    ?? this.fontFamily,
      fontSize:      fontSize      ?? this.fontSize,
      color:         color         ?? this.color,
      textAlign:     textAlign     ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
    );
  }

  /*
  /// Creates a new [TextConfig] changing only the [fontSize].
  ///
  /// This does not change the original (as it's immutable).
  TextConfig withFontSize(double fontSize) {
    return TextConfig(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }

  /// Creates a new [TextConfig] changing only the [color].
  ///
  /// This does not change the original (as it's immutable).
  TextConfig withColor(Color color) {
    return TextConfig(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }

  /// Creates a new [TextConfig] changing only the [fontFamily].
  ///
  /// This does not change the original (as it's immutable).
  TextConfig withFontFamily(String fontFamily) {
    return TextConfig(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }

  /// Creates a new [TextConfig] changing only the [textAlign].
  ///
  /// This does not change the original (as it's immutable).
  TextConfig withTextAlign(TextAlign textAlign) {
    return TextConfig(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }

  /// Creates a new [TextConfig] changing only the [textDirection].
  ///
  /// This does not change the original (as it's immutable).
  TextConfig withTextDirection(TextDirection textDirection) {
    return TextConfig(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      textAlign: textAlign,
      textDirection: textDirection,
    );
  }
  */

}
