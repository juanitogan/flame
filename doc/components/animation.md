# AnimationComponent class

The `AnimationComponent` class is a component for use in building a [`GameEntity`](/doc/game_entity.md).  It draws a List of frames (each `Frame` being a [`SpriteComponent`](/doc/components/sprite.md) plus a duration in seconds).

Works with both [`Raster`](/doc/images/raster.md) and [`Svg`](/doc/images/svg.md) sprite components.

Some support is provided for [Aseprite](https://github.com/aseprite/aseprite) animations data.  To use this feature, export the spritesheet's animation data to a JSON file.

_Note: Support is not yet provided for trimmed-spritesheet data (that is, data about tightly-packed frames of different sizes and/or rotations) such as sprites in TPS files._

## Constructors

| | |
| :-- | :-- |
| _\<default\>_    | Takes a List of Frames.  **(not common use)** |
| fromSpriteList   | Takes a List of SpriteComponents.  **(best practice for SVG)** |
| fromRaster       | Takes a cached Raster by reference.  **(best practice for raster)** |
| fromRasterCache  | Takes a cached Raster by filename. |
| fromRasterFile   | Takes a raster filename (cached or not).  Returns a Future. |
| fromAsepriteData | Takes an Aseprite PNG and JSON file pair.  Returns a Future. |

## Constructor optional parameters

Not all constructors use all parameters.

| | |
| :-- | :-- |
| firstFrame     | The frame in the sprite sheet that starts this animation (zero based).  Default: `0`. |
| frameCount   * | The number of frames this animation is composed of.  Default: `1`. |
| frameDuration  | The duration of each frame, in seconds.  Default: `0.1`. |
| frameDurations | List of duration values, one for each frame.  Overrides frameDuration, if both given. |
| frameHeight    | Height of each frame.  Default: `null`, that is, full height of the image. |
| frameLeft      | X position of the left edge of the first frame.  Default: `0`. |
| frameTop       | Y position of the top edge of the first frame.  Default: `0`. |
| frameWidth     | Width of each frame.  Default: `null`, that is, full width of the image. |
| loop         * | Loops the animation when set to true.  Default: `true`. |
| paused       * | Starts the animation in a paused state.  Default: `false`. |
| pivot          | Pivot point for rotation and anchor point for placement.  Default: `System.defaultPivot` which defaults to `Pivot.center`. |
| reverse      * | Reverses the playback direction when set to true.  Default: `false`. |

\* Also is a property.

## Properties

| | |
| :-- | :-- |
| currentFrame  | Index number of the current frame being drawn. |
| elapsed       | Read-only.  Seconds of elapsed time since start or last reset. |
| frameCount  * | Read-only.  The number of frames this animation is composed of. |
| frameElapsed  | Read-only.  Seconds of elapsed time since start of current frame. |
| frames      * | Read-only.  List of Frames in the animation. |
| isFinished    | Read-only.  If `loop` is false, returns whether the animation is finished (stopped after the final frame).  Always returns false otherwise. |
| isFirstFrame  | Read-only.  Whether the animation is on the first frame. |
| isLastFrame   | Read-only.  Whether the animation is on the last frame. |
| isSingleFrame | Read-only.  Whether the animation has only a single frame (and is, thus, a still image). |
| loop        * | Loops the animation when set to true.  Default: `true`. |
| paused      * | Pauses the animation when set to true.  Default: `false`. |
| pausedTime    | Read-only.  Seconds of elapsed time since paused.|
| reverse     * | Reverses the playback direction when set to true.  Default: `false`. |
| totalDuration | Read-only.  The total computed duration of this animation. |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| advance           | Advances the animation one frame, looping if allowed.  Obeys reverse if set. |
| getCurrentSprite  | Returns the current Frame's SpriteComponent. |
| loaded            | Returns whether the animation has loaded yet or not. |
| pause             | Pause the animation. |
| render            | Draws the current Frame's SpriteComponent.  To execute, call from a `GameEnity.update()`. |
| reset             | Resets the animation, like it had just been created. |
| resume            | Resume the animation. |
| setFrameDuration  | Sets the same duration to all frames. |
| setFrameDurations | Sets a different duration to each frame.  The length of the List must match `frames.length`. |
| update            | Updates the animation state.  To execute, call from a `GameEnity.update()`. |

----

See the [**animations** example app](/doc/examples/animations/lib/main.dart).

See the [**aseprite** example app](/doc/examples/aseprite/lib/main.dart).

See the [**spritesheet** example app](/doc/examples/spritesheet/lib/main.dart).

`AnimationComponent` can also be used as a widget.  See the [PogoWidget class](/doc/pogo_widget.md).
