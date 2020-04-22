import 'dart:async';
import 'dart:ui';

import 'package:pogo/src/components/sprite_image.dart';
import 'package:pogo/src/game/assets_static.dart';
import 'package:pogo/src/game/game_canvas_static.dart';
import 'package:pogo/src/game/system_static.dart';
import 'package:tiled/tiled.dart' hide Image;

//TODO redux and pogo-ize this; is a pivot relevant?

class TiledComponent {
  String filename;
  TileMap map;
  //Image image; //TODO usage?
  Map<String, Raster> images = <String, Raster>{};
  Future future;
  bool _loaded = false;

  Paint paint = System.defaultPaint;

  TiledComponent(this.filename) {
    future = _load();
  }

  Future _load() async {
    map = await _loadMap();
    //image = await Pogo.rasterCache.load(map.tilesets[0].image.source); //TODO usage?
    images = await _loadImages(map);
    _loaded = true;
  }

  Future<TileMap> _loadMap() {
    return Assets.bundle.loadString('assets/tiles/' + filename).then((contents) {
      final parser = TileMapParser();
      return parser.parse(contents);
    });
  }

  Future<Map<String, Raster>> _loadImages(TileMap map) async {
    final Map<String, Raster> result = {};
    await Future.forEach(map.tilesets, (tileset) async {
      await Future.forEach(tileset.images, (tmxImage) async {
        result[tmxImage.source] = await Assets.rasterCache.load(tmxImage.source);
      });
    });
    return result;
  }

  bool loaded() => _loaded;

  void render() {
    if (!loaded()) {
      return;
    }

    map.layers.forEach((layer) {
      if (layer.visible) {
        _renderLayer(layer);
      }
    });
  }

  void _renderLayer(Layer layer) {
    layer.tiles.forEach((tile) {
      if (tile.gid == 0) {
        return;
      }

      final image = images[tile.image.source];

      final rect = tile.computeDrawRect();
      final src = Rect.fromLTWH(rect.left.toDouble(), rect.top.toDouble(),
          rect.width.toDouble(), rect.height.toDouble());
      final dst = Rect.fromLTWH(tile.x.toDouble(), tile.y.toDouble(),
          rect.width.toDouble(), rect.height.toDouble());

      GameCanvas.main.drawImageRect(image.source, src, dst, paint);
    });
  }

  Future<ObjectGroup> getObjectGroupFromLayer(String name) {
    return future.then((onValue) {
      return map.objectGroups
          .firstWhere((objectGroup) => objectGroup.name == name);
    });
  }

}
