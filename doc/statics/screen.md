# Screen class

The `Screen` static class provides central access to static data and methods.

## Properties

| | |
| :-- | :-- |
| size     | Read-only.  Current screen/window size.  Updated whenever the game widget is resized. |
| onResize | Set to a callback function you want called whenever the game widget is resized.  Perhaps to change the [Camera](/doc/statics/camera.md). |

## Methods

| | |
| :-- | :-- |
| setFullScreen         | Sets the app to be fullscreen (no top or bottom bars). |
| setLandscape          | Sets the preferred orientation of the app to landscape only (left or right). |
| setLandscapeLeftOnly  | Sets the preferred orientation of the app to landscape left only. |
| setLandscapeRightOnly | Sets the preferred orientation of the app to landscape right only. |
| setOrientation        | Sets the preferred orientation (landscape or portrait) for the app. |
| setOrientations       | Sets the preferred orientations (landscape left, right, portrait up, or down) for the app. |
| setPortrait           | Sets the preferred orientation of the app to portrait only (up or down). |
| setPortraitUpOnly     | Sets the preferred orientation of the app to portrait up only. |
| setPortraitDownOnly   | Sets the preferred orientation of the app to portrait down only. |
| waitForStartupSizing  | Waits for the initial screen/window dimensions to be available. |
| setSize               | For internal use.  Note: Should not be set by user. |

**Notes:**

* The orientation methods don't seem to work with my Android emulators so... dunno.
* Any use of the `setFullScreen()` method and/or the orientation methods will currently make a web app invisible.  I don't yet know if this is a bug, or just the way it is.  I would think they should just be ignored on platforms where they don't apply.  \[TODO: Since these are just wrapper methods, I should probably just remove them.  Or... maybe I can use these wrappers to check the platform and workaround/respond accordingly.\]
