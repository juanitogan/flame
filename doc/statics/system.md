# System class

The `System` static class provides central access to static data and methods.

## Properties

| | |
| :-- | :-- |
| defaultPivot | Sets the default [Pivot](/doc/pivot.md) point for newly-created [components](/doc/components.md) (including [GestureZone](/doc/input.md#gesturezone-mixin)).  Default: `Pivot.center`. |
| defaultPaint | Sets the default [Paint](https://api.flutter.dev/flutter/dart-ui/Paint-class.html) properties for newly-created [components](/doc/components.md).  Default color is white with all other properties left at their Flutter defaults.  A common use of this is that low-res games will likely want to set `isAntiAlias = false` (its default is true).  Default: `Paint()..color = const Color(0xFFFFFFFF)`. |
