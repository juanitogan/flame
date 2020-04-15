# FAQ

### Where do I go for audio/music/sound-related problems?

Pogo provides a thin wrapper over the [audioplayers](https://github.com/luanpotter/audioplayers) library. Please make extra sure the problem you are having is with Pogo. If you have a low-level or hardware-related audio problem, it's probably something related to audioplayers, so please head to that repository to search for your problem or open an issue. If you indeed have a problem with the Pogo audio wrapper, then open an issue here.

### How do I draw over the notch on Android?

In order to draw over the notch, you must add the following line to your `styles.xml` file:

```xml
<item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
```

For more details, please check [this PR](https://github.com/impulse/flutters/commit/25d4ce726cd18e426483e605fe3668ec68b3c12c) from [impulse](https://github.com/impulse).

### How do I fix the ServicesBinding.defaultBinaryMessenger error?

Starting with Flutter 1.10.x, when using some of the `Screen` methods before the `runApp` statement (like the methods for enforcing the device orientation) the following exception can occur:

```text
E/flutter (16523): [ERROR:flutter/lib/ui/ui_dart_state.cc(151)] Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
E/flutter (16523): If you're running an application and need to access the binary messenger before `runApp()` has been called (for example, during plugin initialization), then you need to explicitly call the `WidgetsFlutterBinding.ensureInitialized()` first.
E/flutter (16523): If you're running a test, you can call the `TestWidgetsFlutterBinding.ensureInitialized()` as the first line in your test's `main()` method to initialize the binding.
```

To prevent this exception from occurring, add this line before calling those utilities methods:

```dart
WidgetsFlutterBinding.ensureInitialized();
```

### How do I run the examples?

See the [main example README](/example).

### How does the Camera work?

See the [Camera documentation](/doc/statics/camera.md).

### How do I handle touch events in my game?

See the [Gesture documentation](/doc/input.md).
