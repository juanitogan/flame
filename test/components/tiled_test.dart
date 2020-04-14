import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show CachingAssetBundle, rootBundle;
import 'package:pogo/game_engine.dart';
import 'package:test/test.dart';

void main() {
  test('my first widget test', () async {
    //await Assets.init(bundle: TestAssetBundle());
    Assets.bundle = TestAssetBundle();
    final tiled = TiledComponent('x');
    await tiled.future;
    expect(1, equals(1));
  });
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => File('assets/map-level1.png')
      .readAsBytes()
      .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      File('assets/map.tmx').readAsString();
}
