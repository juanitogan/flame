# Assets class

The `Assets` static class provides central access to static data and methods.  This primarily holds the asset-related caches.

## Properties

| | |
| :-- | :-- |
| audioCache  | Access a shared instance of the [AudioCache](/doc/caches/audio_cache.md) class. |
| bgm         | Access a shared instance of the [Bgm](/doc/audio/bgm.md) class.  **//TODO haven't looked at this** |
| bundle      | Reference to the default [AssetBundle](https://api.flutter.dev/flutter/services/AssetBundle-class.html) (used by various caches to locate assets).  Defaults to root. |
| rasterCache | Access a shared instance of the [RasterCache](/doc/caches/raster_cache.md) class. |
| svgCache    | Access a shared instance of the [SvgCache](/doc/caches/svg_cache.md) class. |
| textCache   | Access a shared instance of the [TextCache](/doc/caches/text_file_cache.md) class. |
