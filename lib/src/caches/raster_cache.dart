import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:pogo/src/game/assets_static.dart';
import 'package:pogo/src/components/sprite_image.dart';

/// Handles [Raster] image caching.
class RasterCache {
  final Map<String, Raster> _loadedFiles = {};
  String _subPath = "images/";

  /// Override the default subdirectory for image files.
  /// Must specify a path underneath `assets/` (or set to empty for `assets/` root).
  /// Default: `images/`
  ///
  /// `assets/` limitation due to AudioPlayers plugin.
  void setSubPath(String subPath) {
    _subPath = subPath;
  }

  Future<List<Raster>> loadAll(List<String> filenames) async {
    return Future.wait(filenames.map(load));
  }

  Future<Raster> load(String filename) async {
    if (!_loadedFiles.containsKey(filename)) {
      _loadedFiles[filename] = Raster(await _fetchToMemory(filename));
    }
    return _loadedFiles[filename]; //TODO consider no return and enforcing pre-caching
  }

  Future<Image> _fetchToMemory(String filename) async {
    final ByteData data = await Assets.bundle.load("assets/" + _subPath + filename);
    final Uint8List bytes = Uint8List.view(data.buffer);
    final Completer<Image> completer = Completer();
    decodeImageFromList(bytes, (image) => completer.complete(image));
    return completer.future;
  }

  // Slightly more friendly overload to the map.
  Raster get(String filename) {
    return _loadedFiles[filename];
  }

  void remove(String filename) {
    _loadedFiles[filename].source.dispose();
    _loadedFiles.remove(filename);
  }

  void clear() {
    _loadedFiles.forEach((f, r) => r.source.dispose());
    _loadedFiles.clear();
  }

}
