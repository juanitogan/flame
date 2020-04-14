import 'dart:math';

import "package:flare_flutter/flare.dart";
import "package:flare_flutter/flare_actor.dart";
import 'package:pogo/src/components/text_config.dart';
import 'package:pogo/src/game/assets_static.dart';
import 'package:pogo/src/game/game_main.dart';
import 'package:pogo/src/game/time_static.dart';

export 'package:pogo/src/pivot.dart';

//TODO look at loading/caching and who knows what else...

class FlareComponent {
  final FlutterActorArtboard _artboard;
  FlutterActorArtboard get artboard => _artboard;

  String _animationName;
  String get animationName => _animationName;

  double scale; // build same as SVG scale

  Pivot pivot;

  double get width => _artboard.width * scale;
  double get height => _artboard.height * scale;

  double get unscaledWidth => _artboard.width;
  double get unscaledHeight => _artboard.height;

  final List<FlareAnimationLayer> _animationLayers = [];

  Picture _picture;


  FlareComponent(
      this._artboard,
      this._animationName,
      {
        this.scale = 1.0,
        this.pivot,
      }
  ) : assert (scale != null) {
    pivot ??= System.defaultPivot;
    setAnimation(_animationName);
  }

  static Future<FlareComponent> fromFile(
      String filename,
      String animationName,
      {
        double scale,
        Pivot pivot,
      }
  ) async {
    final actor = FlutterActor();
    await actor.loadFromBundle(Assets.bundle, filename);
    await actor.loadImages();

    final artboard = actor.artboard.makeInstance();
    artboard.makeInstance();
    artboard.initializeGraphics();
    artboard.advance(0.0);

    return FlareComponent(
        artboard,
        animationName,
        scale: scale,
        pivot: pivot,
    );
  }

  bool loaded() {
    return _artboard != null;
  }


  void setAnimation(String animationName) {
    _animationName = animationName;

    if (_animationName != null && _artboard != null) {
      _animationLayers.clear();

      final ActorAnimation animation = _artboard.getAnimation(_animationName);
      if (animation != null) {
        _animationLayers.add(FlareAnimationLayer()
          ..name = _animationName
          ..animation = animation
          ..mix = 1.0
          ..mixSeconds = 0.2);
        animation.apply(0.0, _artboard, 1.0);
        _artboard.advance(0.0);
      }
    }
  }


  void update() {
    int lastFullyMixed = -1;
    double lastMix = 0.0;

    final List<FlareAnimationLayer> completed = [];

    for (int i = 0; i < _animationLayers.length; i++) {
      final FlareAnimationLayer layer = _animationLayers[i];
      layer.mix += Time.deltaTime;
      layer.time += Time.deltaTime;

      lastMix = (layer.mixSeconds == null || layer.mixSeconds == 0.0)
          ? 1.0
          : min(1.0, layer.mix / layer.mixSeconds);
      if (layer.animation.isLooping) {
        layer.time %= layer.animation.duration;
      }
      layer.animation.apply(layer.time, _artboard, lastMix);
      if (lastMix == 1.0) {
        lastFullyMixed = i;
      }
      if (layer.time > layer.animation.duration) {
        completed.add(layer);
      }
    }

    if (lastFullyMixed != -1) {
      _animationLayers.removeRange(0, lastFullyMixed);
    }
    if (_animationName == null &&
        _animationLayers.length == 1 &&
        lastMix == 1.0) {
      // Remove remaining animations.
      _animationLayers.removeAt(0);
    }

    if (_artboard != null) {
      _artboard.advance(Time.deltaTime);
    }

    // Memory render frame
    final r = PictureRecorder();
    final c = Canvas(r);

    c.scale(scale, scale);
    _artboard.draw(c);

    _picture = r.endRecording();
  }

  void render() {
    if (!loaded() || _picture == null) {
      return;
    }
    final Offset o = pivot.translate(Size(width, height));
    GameCanvas.main.save();
      GameCanvas.main.translate(o.dx, o.dy);
      GameCanvas.main.drawPicture(_picture);
      //
      if (Game().debugMode) {
        _renderDebugMode();
      }
    GameCanvas.main.restore();
  }


  // DEBUG MODE ////////

  Color debugColor = const Color(0xFFFF00FF);

  Paint get _debugPaint => Paint()
    ..color = debugColor
    ..style = PaintingStyle.stroke
  ;

  TextConfig get _debugTextConfig => TextConfig(color: debugColor, fontSize: 12);

  void _renderDebugMode() {
    GameCanvas.main.drawRect(Rect.fromLTWH(0, 0, width, height), _debugPaint);
    final String text = "w:${width.toStringAsFixed(1)} h:${height.toStringAsFixed(1)}";
    final TextPainter tp = _debugTextConfig.getTextPainter(text);
    tp.paint(GameCanvas.main, const Offset(1, 1));
  }

}
