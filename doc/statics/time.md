# System class

The `System` static class provides central access to time-related values with the game engine.

All times are in seconds with decimal precision chopped to the microsecond.

## Properties

| | |
| :-- | :-- |
| unscaledNow | Read-only.  Seconds since start of game.  Ignores time scaling.  Remains constant during each frame. |
| now         | Read-only.  Seconds since start of game, adjusted by time scaling.  Remains constant during each frame. |
| deltaTime   | Read-only.  Seconds since the last frame. |
| frameCount  | Read-only.  Number of frames since start of game. |

**Note: Time scaling is not yet a feature.  No estimates as to when it might arrive.  In other words: `timeScaleFeatureAdd.timeScale = 0.0;`**

## Methods

| | |
| :-- | :-- |
| tick | For internal use. |
