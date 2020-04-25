# System class

The `System` static class provides central access to static data and methods.

## Properties

| | |
| :-- | :-- |
| defaultPivot | Sets the default [Pivot](/doc/pivot.md) point for newly-created [components](/doc/components.md) (including [GestureArea](/doc/input.md#gestureArea-mixin)).  Default: `Pivot.center`. |
| defaultPaint | Sets the default [Paint](https://api.flutter.dev/flutter/dart-ui/Paint-class.html) properties for newly-created [components](/doc/components.md).  Default color is white with all other properties left at their Flutter defaults.  A common use of this is that low-res games will likely want to set `isAntiAlias = false` (the default is true).  Note that not all components use this Paint (yet).  For example, TextComponent doesn't use a Paint.  Thus, the challenge of [pixelated fonts](https://namethattech.wordpress.com/2017/03/22/how-to-make-a-snap-to-grid-in-fontforge/) probably still needs to be solved.  Default: `Paint()..color = const Color(0xFFFFFFFF)`. |
