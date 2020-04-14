import 'dart:async';
import 'dart:ui';

import 'package:pogo/src/game/assets_static.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/screen_static.dart';
import 'package:pogo/src/game/time_static.dart';
import 'package:flutter/painting.dart';

export 'dart:async';
export 'dart:ui';


//TODO Pogo-ize to allow SVGs... etc.
//TODO Do we event need/want this? Yeah... a ton of this needs to change if we do.

/// How to fill the screen with the image, always proportionally scaled.
enum LayerFill { height, width, none }

/// Specifications with a path to an image and how it should be drawn in
/// relation to the device screen
class ParallaxImage {
  /// The filename of the image
  final String filename;

  /// If and how the image should be repeated on the canvas
  final ImageRepeat repeat;

  /// How to align the image in relation to the screen
  final Alignment alignment;

  /// How to fill the screen with the image, always proportionally scaled.
  final LayerFill fill;

  ParallaxImage(
      this.filename,
      {
        this.repeat = ImageRepeat.repeatX,
        this.alignment = Alignment.bottomLeft,
        this.fill = LayerFill.height
      }
  );
}

/// Represents one layer in the parallax, draws out an image on a canvas in the
/// manner specified by the parallaxImage
class ParallaxLayer {
  final ParallaxImage parallaxImage;
  Future<Image> future;

  Image _image;
  //Size _screenSize;
  Rect _paintArea;
  Offset _scroll;
  Offset _imageSize;
  double _scale = 1.0;

  ParallaxLayer(this.parallaxImage) {
    future = _load(parallaxImage.filename);
  }

  bool loaded() => _image != null;

  Offset currentOffset() => _scroll;

  void resize() {
    if (!loaded()) {
      //_screenSize = Screen.size;
      return;
    }

    double scale(LayerFill fill) {
      switch (fill) {
        case LayerFill.height:
          return _image.height / Screen.size.height;
        case LayerFill.width:
          return _image.width / Screen.size.width;
        default:
          return _scale;
      }
    }

    _scale = scale(parallaxImage.fill);

    // The image size so that it fulfills the LayerFill parameter
    _imageSize = Offset(_image.width / _scale, _image.height / _scale);

    // Number of images that can fit on the canvas plus one
    // to have something to scroll to without leaving canvas empty
    final countX = 1 + Screen.size.width / _imageSize.dx;
    final countY = 1 + Screen.size.height / _imageSize.dy;

    // Percentage of the image size that will overflow
    final overflowX = (_imageSize.dx * countX - Screen.size.width) / _imageSize.dx;
    final overflowY = (_imageSize.dy * countY - Screen.size.height) / _imageSize.dy;

    // Align image to correct side of the screen
    final alignment = parallaxImage.alignment;
    final marginX = alignment.x == 0 ? overflowX / 2 : alignment.x;
    final marginY = alignment.y == 0 ? overflowY / 2 : alignment.y;
    _scroll ??= Offset(marginX, marginY);

    // Size of the area to paint the images in
    final rectWidth = countX * _imageSize.dx;
    final rectHeight = countY * _imageSize.dy;
    _paintArea = Rect.fromLTWH(0, 0, rectWidth, rectHeight);
  }

  void update(Offset delta) {
    if (!loaded()) {
      return;
    }

    // Scale the delta so that images that are larger don't scroll faster
    _scroll += delta.scale(1 / _imageSize.dx, 1 / _imageSize.dy);
    switch (parallaxImage.repeat) {
      case ImageRepeat.repeat:
        _scroll = _scroll % 1;
        break;
      case ImageRepeat.repeatX:
        _scroll = Offset(_scroll.dx % 1, _scroll.dy);
        break;
      case ImageRepeat.repeatY:
        _scroll = Offset(_scroll.dx, _scroll.dy % 1);
        break;
      case ImageRepeat.noRepeat:
        break;
    }

    final dx = _scroll.dx * _imageSize.dx;
    final dy = _scroll.dy * _imageSize.dy;

    _paintArea = Rect.fromLTWH(-dx, -dy, _paintArea.width, _paintArea.height);
  }

  void render() {
    if (!loaded()) {
      return;
    }

    paintImage(
      canvas: GameCanvas.main,
      image: _image,
      rect: _paintArea,
      repeat: parallaxImage.repeat,
      scale: _scale,
      alignment: parallaxImage.alignment,
    );
  }

  Future<Image> _load(filename) {
    return Assets.rasterCache.load(filename).then((image) {
      _image = image.source;
      //if (_screenSize != null) {
        resize();
      //}
      return _image;
    });
  }
}

/// A full parallax, several layers of images drawn out on the screen and each
/// layer moves with different speeds to give an effect of depth.
class ParallaxComponent {
  Offset baseSpeed;
  Offset layerDelta;
  List<ParallaxLayer> _layers;
  bool _loaded = false;

  ParallaxComponent(
      List<ParallaxImage> images,
      {
        this.baseSpeed = Offset.zero,
        this.layerDelta = Offset.zero
      }
  ) {
    _load(images);
  }

  void _load(List<ParallaxImage> images) {
    _layers = images.map((image) => ParallaxLayer(image)).toList();
    Future.wait(_layers.map((layer) => layer.future))
        .then((_) => _loaded = true);
  }

  bool loaded() => _loaded;

  /// The base offset of the parallax, can be used in an outer update loop
  /// if you want to transition the parallax to a certain position.
  Offset currentOffset() => _layers[0].currentOffset();

  void update() {
    if (!loaded()) {
      return;
    }
    _layers.forEach((layer) => layer
        .update(baseSpeed * Time.deltaTime + layerDelta * (_layers.indexOf(layer) * Time.deltaTime)));
  }

  void render() {
    if (!loaded()) {
      return;
    }
    GameCanvas.main.save(); //TODO not the place for this
    _layers.forEach((layer) => layer.render());
    GameCanvas.main.restore(); //TODO not the place for this
  }

  void resize() {
    if (!loaded()) {
      return;
    }
    _layers.forEach((layer) => layer.resize());
  }

}
