# Camera class

The `Camera` static class provides central access to static data and methods.

## Properties

| | |
| :-- | :-- |
| height | Shortcut getter/setter to `rect.height`. |
| left   | Shortcut getter/setter to `rect.left`. |
| offset | Shortcut getter/setter to `rect.topLeft`.  Use `offset` to pan around a map, for example.  Scales according to size/scale. |
| rect   | The main Rect that sets the main camera position and size/scale.  Default: `Rect.zero`. |
| scale  | Inverse of `size`, basically.  Set one or the other, not both. |
| size   | Shortcut getter/setter to `rect.size`.  Leave `size` at zero for default behavior of camera equaling the whole screen/window at native resolution.  Set to a low value for low-res game support with low-res coordinates and art. |
| top    | Shortcut getter/setter to `rect.top`. |
| width  | Shortcut getter/setter to `rect.width`. |
