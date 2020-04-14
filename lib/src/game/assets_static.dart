//library pogo; //TODO use when taking library making and library-level documentation seriously
// https://dart.dev/guides/libraries/create-library-packages

import 'package:flutter/services.dart';

import 'package:pogo/src/audio/bgm.dart';
import 'package:pogo/src/caches/audio_cache.dart';
import 'package:pogo/src/caches/raster_cache.dart';
import 'package:pogo/src/caches/svg_cache.dart';
import 'package:pogo/src/caches/text_file_cache.dart';


/// Static class for asset caching, etc.
///
/// Access shared instances of [AudioCache], [RasterCache] et al.
/// Most games should need only one instance of each, and should use this class to manage that reference.
class Assets {

  //TODO should maybe move caches to a singleton

  // Default asset bundle, defaults to root (used by various caches to locate assets)
  //TODO this creates a circular dependency; does it really help to make this static here?
  static AssetBundle _bundle;
  static AssetBundle get bundle => _bundle == null ? rootBundle : _bundle;
  static set bundle(AssetBundle bundle) => _bundle = bundle;

  /// Access a shared instance of the [RasterCache] class.
  static RasterCache rasterCache = RasterCache();

  /// Access a shared instance of the [SvgCache] class.
  static SvgCache svgCache = SvgCache();

  /// Access a shared instance of the [TextCache] class.
  /// Used by [AnimationComponent.fromAsepriteData].
  static TextCache textCache = TextCache();

  /// Access a shared instance of the [AudioCache] class.
  static AudioCache audioCache = AudioCache();

  /// Access a shared instance of the [Bgm] class. //TODO
  static Bgm _bgm;
  static Bgm get bgm => _bgm ??= Bgm();

}
