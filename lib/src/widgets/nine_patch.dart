import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:meta/meta.dart';
import 'package:pogo/src/components/sprite_component.dart';

//TODO replace this class with code that works more like (or with) Flutter's centerSlice property.
//TODO   https://api.flutter.dev/flutter/widgets/Image/centerSlice.html

class _Painter extends widgets.CustomPainter {
  final Image image;
  final int tileSize;
  final double destTileSize;

  _Painter({
    @required this.image,
    @required this.tileSize,
    @required this.destTileSize,
  });

  SpriteComponent _getSpriteTile(int x, int y) =>
      SpriteComponent.fromRaster(Raster(image), frameLeft: x, frameTop: y, frameWidth: tileSize, frameHeight: tileSize);

  @override
  void paint(Canvas canvas, Size size) {
    final topLeftCorner = _getSpriteTile(0, 0);
    final topRightCorner = _getSpriteTile(tileSize * 2, 0);

    final bottomLeftCorner = _getSpriteTile(0, 2 * tileSize);
    final bottomRightCorner = _getSpriteTile(tileSize * 2, 2 * tileSize);

    final topSide = _getSpriteTile(tileSize, 0);
    final bottomSide = _getSpriteTile(tileSize, tileSize * 2);

    final leftSide = _getSpriteTile(0, tileSize);
    final rightSide = _getSpriteTile(tileSize * 2, tileSize);

    final middle = _getSpriteTile(tileSize, tileSize);

    final horizontalWidget = size.width - destTileSize * 2;
    final verticalHeight = size.height - destTileSize * 2;

    // Middle
    middle.image.draw( //TODO hacky workaround to render() until refactoring with canvas.scale() etc.
        canvas,
        middle.frameRect,
        Rect.fromLTWH(destTileSize, destTileSize, horizontalWidget, verticalHeight,),
        middle.paint
    );

    // Top and bottom edge
    topSide.image.draw(
        canvas,
        topSide.frameRect,
        Rect.fromLTWH(destTileSize, 0, horizontalWidget, destTileSize),
        topSide.paint
    );
    bottomSide.image.draw(
        canvas,
        bottomSide.frameRect,
        Rect.fromLTWH(destTileSize, size.height - destTileSize, horizontalWidget, destTileSize),
        bottomSide.paint
    );

    // Left and right edge
    leftSide.image.draw(
        canvas,
        leftSide.frameRect,
        Rect.fromLTWH(0, destTileSize, destTileSize, verticalHeight),
        leftSide.paint
    );
    rightSide.image.draw(
        canvas,
        rightSide.frameRect,
        Rect.fromLTWH(size.width - destTileSize, destTileSize, destTileSize, verticalHeight),
        rightSide.paint
    );

    // Corners
    topLeftCorner.image.draw(
        canvas,
        topLeftCorner.frameRect,
        Rect.fromLTWH(0, 0, destTileSize, destTileSize),
        topLeftCorner.paint
    );
    topRightCorner.image.draw(
        canvas,
        topRightCorner.frameRect,
        Rect.fromLTWH(size.width - destTileSize, 0, destTileSize, destTileSize),
        topRightCorner.paint
    );

    bottomLeftCorner.image.draw(
        canvas,
        bottomLeftCorner.frameRect,
        Rect.fromLTWH(0, size.height - destTileSize, destTileSize, destTileSize),
        bottomLeftCorner.paint
    );
    bottomRightCorner.image.draw(
        canvas,
        bottomRightCorner.frameRect,
        Rect.fromLTWH(size.width - destTileSize, size.height - destTileSize, destTileSize, destTileSize),
        bottomRightCorner.paint
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class NinePatch extends widgets.StatelessWidget {
  final Image image;
  final int tileSize;
  final double destTileSize;
  final double width;
  final double height;

  final widgets.Widget child;

  final widgets.EdgeInsetsGeometry padding;

  NinePatch({
    @required this.image,
    @required this.tileSize,
    @required this.destTileSize,
    Key key,
    this.child,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  widgets.Widget build(widgets.BuildContext context) {
    return widgets.Container(
      width: width,
      height: height,
      child: widgets.CustomPaint(
        painter: _Painter(
          image: image,
          tileSize: tileSize,
          destTileSize: destTileSize,
        ),
        child: widgets.Container(
          child: child,
          padding: padding,
        ),
      ),
    );
  }
}
