import 'package:pogo/src/game/assets_static.dart';

/// Handles text file caching.
///
/// Must specify a filename and path underneath `assets/`.
///
/// `assets/` limitation due to AudioPlayers plugin.
class TextCache {
  final Map<String, String> _loadedFiles = {};

  /// Reads a file from assets folder
  Future<String> load(String filename) async {
    if (!_loadedFiles.containsKey(filename)) {
      _loadedFiles[filename] = await _readFile(filename);
    }
    return _loadedFiles[filename];
  }

  Future<String> _readFile(String filename) async {
    return await Assets.bundle.loadString('assets/' + filename);
  }

  // Slightly more friendly overload to the map.
  String get(String filename) {
    return _loadedFiles[filename];
  }

  /// Removes the file from the cache
  void remove(String filename) {
    _loadedFiles.remove(filename);
  }

  /// Removes all the files from the cache
  void clear() {
    _loadedFiles.clear();
  }

}
