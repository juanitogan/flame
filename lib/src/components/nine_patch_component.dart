import 'dart:ui';

import 'package:pogo/src/components/sprite_component.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/system_static.dart';

//TODO !!URGENT!! replace this class with code that works more like (or with) Flutter's centerSlice property.
//TODO   https://api.flutter.dev/flutter/widgets/Image/centerSlice.html
//TODO   https://api.flutter.dev/flutter/dart-ui/Canvas/drawImageNine.html

/// This allows you to create a rectangle textured with a 9-patch image.
///
/// How it works is that you have a template image in a 3x3 grid, made up of 9 tiles,
/// and a new rectangle can be draw by keeping the 4 corners, expanding the 4 sides only
/// in the direction in which they are located and expanding the center in both directions.
/// That allows you to have non-distorted borders.
class NinePatchComponent {
  /// The sprite used to render the box, must be a 3x3 grid of square tiles.
  SpriteComponent sprite; //TODO replace with Raster, probably

  //TODO added this temp fix
  double width;
  double height;

  /// The size of each tile in the source sprite image.
  int patchSize;

  /// The size each tile becomes when rendered (optionally used to scale the src image).
  int destPatchSize;

  /// Creates a nine-box instance.
  ///
  /// [sprite] is the 3x3 grid and [patchSize] is the size of each tile.
  /// The src sprite must a square of size 3*[patchSize].
  ///
  /// If [patchSize] is not provided, the width of the sprite is assumed as the size.
  /// Otherwise the width and height properties of the sprite are ignored.
  ///
  /// If [destPatchSize] is not provided, the evaluated [patchSize] is used instead
  /// (so no scaling happens).
  NinePatchComponent(this.sprite, this.width, this.height, {int patchSize, int destPatchSize}) {
    this.patchSize = patchSize ?? sprite.frameRect.width.toInt();
    this.destPatchSize = destPatchSize ?? patchSize;
  }

  /// Renders this nine box with the dimensions provided by [rect].
  /*void drawRect(Canvas c, Rect rect) {
    draw(c, rect.left, rect.top, rect.width, rect.height);
  }*/
  //TODO hacky temp fix
  /// Renders this sprite with its pivot at local position zero.
  /// Renders actual size according to instance frame width and height.
  /// Has an optional [paint] parameter for rendering with a different palette.
  void render({Paint paint}) {
    //final Offset o = pivot.translate(frameRect.size);
    GameCanvas.main.save();
      //Graphics.canvas.translate(o.dx, o.dy);
      draw(0.0, 0.0, width, height);
    GameCanvas.main.restore();
  }

  /// Renders this nine box as a rectangle of coordinates ([x], [y]) and size ([width], [height]).
  void draw(double x, double y, double width, double height) {
    if (!sprite.loaded()) {
      return;
    }

    // corners
    _drawTile(_getDest(x, y), 0, 0);
    _drawTile(_getDest(x, y + height - destPatchSize), 0, 2);
    _drawTile(_getDest(x + width - destPatchSize, y), 2, 0);
    _drawTile(_getDest(x + width - destPatchSize, y + height - destPatchSize), 2, 2);

    // horizontal sides
    final mx = width - 2 * destPatchSize;
    _drawTile(_getDest(x + destPatchSize, y, width: mx), 1, 0);
    _drawTile(_getDest(x + destPatchSize, y + height - destPatchSize, width: mx), 1, 2);

    // vertical sides
    final my = height - 2 * destPatchSize;
    _drawTile(_getDest(x, y + destPatchSize, height: my), 0, 1);
    _drawTile(_getDest(x + width - destPatchSize, y + destPatchSize, height: my), 2, 1);

    // center
    _drawTile(_getDest(x + destPatchSize, y + destPatchSize, width: mx, height: my), 1, 1);
  }

  Rect _getDest(double x, double y, {double width, double height}) {
    final w = width ?? _destTileSizeDouble;
    final h = height ?? _destTileSizeDouble;
    return Rect.fromLTWH(x, y, w, h);
  }

  double get _tileSizeDouble => patchSize.toDouble();

  double get _destTileSizeDouble => destPatchSize.toDouble();

  void _drawTile(Rect dest, int i, int j) {
    final xSrc = sprite.frameRect.left + _tileSizeDouble * i;
    final ySrc = sprite.frameRect.top + _tileSizeDouble * j;
    final src = Rect.fromLTWH(xSrc, ySrc, _tileSizeDouble, _tileSizeDouble);
    GameCanvas.main.drawImageRect(sprite.image.source, src, dest, System.defaultPaint);
  }
}
