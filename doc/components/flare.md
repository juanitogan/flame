# FlareComponent class

The `FlareComponent` class is a component for use in building a [`GameEntity`](/doc/game_entity.md).  It draws and controls a given [Flare](https://www.2dimensions.com/about-flare) animation.

## Constructors

| | |
| :-- | :-- |
| _<default>_ | Takes a FlutterActorArtboard by reference. |
| fromFile    | Takes a Flare filename (cached or not).  Returns a Future. |

**//TODO look into caching**

## Properties

| | |
| :-- | :-- |
| animationName * | Read-only.  Name of the currently playing animation. |
| artboard      * | Read-only.  Reference to the source FlutterActorArtboard object. |
| debugColor      | Color to draw debug-mode information.  Default: `Color(0xFFFF00FF)` magenta. |
| height          | Read-only.  Scaled height of the source artboard (the height that will be drawn). |
| pivot         * | [Pivot](/doc/pivot.md) point for rotation and anchor point for placement.  Default: `System.defaultPivot` which defaults to `Pivot.center`. |
| scale         * | A scale factor can be provided to adapt the Flare's units to the app's units.  Default: `1.0`. |
| unscaledHeight  | Read-only.  Unscaled height of the source artboard. |
| unscaledWidth   | Read-only.  Unscaled width of the source artboard. |
| width           | Read-only.  Scaled width of the source artboard (the width that will be drawn). |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| loaded       | Returns whether the animation has loaded yet or not. |
| render       | Draws the Flare, translated by the set Pivot, at the set scale.  To execute, call from a `GameEnity.update()`. |
| setAnimation | Sets a new animation for playback by animation name. |
| update       | Updates the animation state.  To execute, call from a `GameEnity.update()`. |

----

See the [**flare** example app](/doc/examples/flare/lib/main.dart).

See the [**particles** example app](/doc/examples/particles/lib/main.dart).
