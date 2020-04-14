import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ninePatch = SpriteComponent(await Assets.rasterCache.load('nine_tile_box.png'));
  final dashbook = Dashbook();

  dashbook.storiesOf('NinePatch').decorator(CenterDecorator()).add(
      'as a widget!',
      (ctx) => Container(
          width: ctx.numberProperty('width', 200),
          height: ctx.numberProperty('height', 200),
          child: PogoWidget.fromEntity(
            NinePatchPrefab(
                NinePatchComponent(
                    ninePatch, 200, 200,
                    patchSize: 16,
                    destPatchSize: 50
                ),
            ),
            const Size(200, 200),
            /*child: const Center( //TODO who wrote this? there are no children to game widgets yet, if ever (not even NineTileBox as found)
              child: const Text(
                'Cool label',
                style: const TextStyle(
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),*/
          ),
      ),
  );

  runApp(dashbook);
}
