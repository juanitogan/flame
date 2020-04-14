# RasterCache class

Handles [Raster](/doc/images/raster.md) image caching.

You can cache your raster images for faster access in a `RasterCache` with the `load()` or `loadAll()` methods.  Pogo provides a static `RasterCache` for general use in the [`Assets` static class](statics/assets.md).

```dart
await Assets.rasterCache.loadAll(['player.png', 'enemy.png']);
```

Or, you can instantiate your own copy of a `RasterCache` if needed.  But, given that you can clear and reload the static cache, the use case of needing your own cache may not be common.

## Methods

| | |
| :-- | :-- |
| clear         | Clears all data from the cache. |
| get           | Returns an image, by filename, from the cache. |
| load          | Loads a single file into the cache.  Returns a Raster Future. |
| loadAll       | Loads a List of files into the cache.  Returns a List<Raster> Future. |
| remove        | Removes a single image, by filename, from the cache. |
| setSubPath    | Override the default subdirectory for image files.  Must specify a path underneath `assets/` (or set to empty for `assets/` root).  Default: `images/`. |

----

For an overview of how to setup your assets, see the [getting started guide](/README.md#asset-files).
