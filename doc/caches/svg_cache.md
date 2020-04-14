# SvgCache class

Handles [Svg](/doc/images/svg.md) image caching.

You can cache your SVG images for faster access in an `SvgCache` with the `load()` or `loadAll()` methods.  Pogo provides a static `SvgCache` for general use in the [`Assets` static class](statics/assets.md).

```dart
await Assets.svgCache.loadAll(["enemy.svg", "player.svg"], scale: 0.75);
```

Or, you can instantiate your own copy of an `SvgCache` if needed.  But, given that you can clear and reload the static cache, the use case of needing your own cache may not be common.

## Methods

| | |
| :-- | :-- |
| clear         | Clears all data from the cache. |
| get           | Returns an image, by filename, from the cache. |
| load          | Loads a single file into the cache.  Takes an optional scale factor for adapting the SVG's units to the app's units (default: `1.0`).  Returns an Svg Future. |
| loadAll       | Loads a List of files into the cache.  Takes an optional scale factor for adapting the SVG's units to the app's units (default: `1.0`).  Returns a List<Svg> Future. |
| remove        | Removes a single image, by filename, from the cache. |
| setSubPath    | Override the default subdirectory for SVG files.  Must specify a path underneath `assets/` (or set to empty for `assets/` root).  Default: `svgs/`. |

----

For an overview of how to setup your assets, see the [getting started guide](/README.md#asset-files).
