# Raster class

The `Raster` class is a [`SpriteImage`](sprite_image.md) that is a wrapper to Dart's [`Image` class](https://api.flutter.dev/flutter/dart-ui/Image-class.html).

Only PNG files have been tested thus far, but the types supported by Dart are: JPEG, PNG, GIF, Animated GIF, WebP, Animated WebP, BMP, and WBMP.

Drawing a `Raster` on the `GameCanvas` is typically handled for you by passing it to a component such as `SpriteComponent` or `AnimationComponent`.

## Properties

| | |
| :-- | :-- |
| height    | Read-only.  Height of the source image (as a double). |
| intHeight | Read-only.  Height of the source image (as an integer). |
| intWidth  | Read-only.  Width of the source image (as an integer). |
| source    | Read-only.  Reference to the source Image object. |
| width     | Read-only.  Width of the source image (as a double). |

## Methods

| | |
| :-- | :-- |
| draw   | Draws the given `frameRect` of the image at the given `drawRect` size on the given Canvas. |
| loaded | Returns whether the source is loaded yet or not. |

----

See the [RasterCache reference](/doc/caches/raster_cache.md).

For an overview of how to setup your assets, see the [getting started guide](/README.md#asset-files).
