import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart' hide Svg;
import 'package:pogo/src/game/assets_static.dart';
import 'package:pogo/src/components/sprite_image.dart';

/// Handles [Svg] image caching.
class SvgCache {
  final Map<String, Svg> _loadedFiles = {};
  String _subPath = "svgs/";

  /// Override the default subdirectory for SVG files.
  /// Must specify a path underneath `assets/` (or set to empty for `assets/` root).
  /// Default: `svgs/`
  ///
  /// `assets/` limitation due to AudioPlayers plugin.
  void setSubPath(String subPath) {
    _subPath = subPath;
  }

  Future<List<Svg>> loadAll(List<String> filenames, {double scale = 1.0}) async {
    return Future.wait(filenames.map((f) => load(f, scale: scale)));
  }

  Future<Svg> load(String filename, {double scale = 1.0}) async {
    if (!_loadedFiles.containsKey(filename)) {
      _loadedFiles[filename] = Svg(await _fetchToMemory(filename), scale: scale ?? 1.0);
    }
    return _loadedFiles[filename];
  }

  Future<DrawableRoot> _fetchToMemory(String filename) async {
    final String rawSvg = await Assets.bundle.loadString("assets/" + _subPath + filename);
    return await svg.fromSvgString(rawSvg, filename);
  }

  // Slightly more friendly overload to the map.
  Svg get(String filename) {
    return _loadedFiles[filename];
  }

  void remove(String filename) {
    _loadedFiles.remove(filename);
  }

  void clear() {
    _loadedFiles.clear();
  }

}
