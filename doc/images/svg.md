# Svg class

The `Svg` class is a [`SpriteImage`](sprite_image.md) that is a wrapper to the flutter_svg [`DrawableRoot` class](https://pub.dev/documentation/flutter_svg/latest/flutter_svg/DrawableRoot-class.html) for rendering SVG files in Flutter.

Drawing an `Svg` on the `GameCanvas` is typically handled for you by passing it to a component such as `SpriteComponent` or `AnimationComponent`.

## Properties

| | |
| :-- | :-- |
| height         | Read-only.  Scaled height of the source image (the height that will be drawn). |
| scale          | A scale factor can be provided to adapt the SVG's units to the app's units.  Default: `1.0`. |
| source         | Read-only.  Reference to the source DrawableRoot object. |
| unscaledHeight | Read-only.  Unscaled height of the source image. |
| unscaledWidth  | Read-only.  Unscaled width of the source image. |
| width          | Read-only.  Scaled width of the source image (the width that will be drawn). |

## Methods

| | |
| :-- | :-- |
| draw   | Draws the SVG on the given Canvas at the set scale.  (`frameRect`, `drawRect`, and `paint` are currently ignored.) |
| loaded | Returns whether the source is loaded yet or not. |

----

See the [SvgCache reference](/doc/caches/svg_cache.md).

For an overview of how to setup your assets, see the [getting started guide](/README.md#asset-files).
