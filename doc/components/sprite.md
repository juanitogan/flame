# SpriteComponent class

The `SpriteComponent` class is a component for use in building a [`GameEntity`](/doc/game_entity.md).  It draws a given [`SpriteImage`](/doc/images/sprite_image.md) (or a single frame from the given `SpriteImage`).

Works with both [`Raster`](/doc/images/raster.md) and [`Svg`](/doc/images/svg.md).

## Constructors

| | |
| :-- | :-- |
| _\<default\>_   | Takes a cached Raster by reference.  (Same as `fromRaster()` except the frame parameters take a double instead of an int.) |
| fromRaster      | Takes a cached Raster by reference.  **(best practice)** |
| fromRasterCache | Takes a cached Raster by filename. |
| fromRasterFile  | Takes a raster filename (cached or not).  Returns a Future. |
| fromSvg         | Takes a cached Svg by reference.  **(best practice)** |
| fromSvgCache    | Takes a cached Svg by filename. |
| fromSvgFile     | Takes an SVG filename (cached or not).  Also takes an optional `scale` parameter.  Returns a Future. |

## Properties

| | |
| :-- | :-- |
| debugColor    | Color to draw debug-mode information.  Default: `Color(0xFFFF00FF)` magenta. |
| frameHeight * | Read-only.  Height of each frame.  Default: `null`, that is, full height of the image. |
| frameLeft   * | Read-only.  X position of the left edge of the first frame.  Default: `0`. |
| frameOffset   | Read-only.  X,Y position of the top/left corner of the first frame.  Default: `Offset.zero`. |
| frameRect     | Read-only.  Rect of the offset and size of the first frame.  Default: `Rect.fromLTWH(0, 0, image.width, image.height)`. |
| frameSize     | Read-only.  Width and height of each frame.  Default: `Size(image.width, image.height)`. |
| frameTop    * | Read-only.  Y position of the top edge of the first frame.  Default: `0`. |
| frameWidth  * | Read-only.  Width of each frame.  Default: `null`, that is, full width of the image. |
| image       * | Read-only.  Reference to the source SpriteImage object. |
| paint         | The [Paint](https://api.flutter.dev/flutter/dart-ui/Paint-class.html) to use when drawing the image. |
| pivot       * | [Pivot](/doc/pivot.md) point for rotation and anchor point for placement.  Default: `System.defaultPivot` which defaults to `Pivot.center`. |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| loaded | Returns whether the image has loaded yet or not. |
| render | Draws the image (or frame from the image), translated by the set Pivot, with the given or set Paint.  To execute, call from a `GameEnity.update()`. |

----

See the [**spritesheet** example app](/doc/examples/spritesheet/lib/main.dart).

See the [**svg** example app](/doc/examples/svg/lib/main.dart).

See the [main example app](/example/lib/main.dart).

`SpriteComponent` can also be used as a widget.  See the [PogoWidget class](/doc/pogo_widget.md).
