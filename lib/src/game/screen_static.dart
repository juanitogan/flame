import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:pogo/src/game/camera_static.dart';

export 'package:flutter/services.dart' show DeviceOrientation;

/// Static class for screen data and methods.
class Screen {

  /// Sets the app to be fullscreen (no top or bottom bars).
  ///
  /// Most games should probably be this way.
  static Future<void> setFullScreen() {
    return SystemChrome.setEnabledSystemUIOverlays([]);
  }

  /// Sets the preferred orientation (landscape or portrait) for the app.
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible) depending on the physical orientation of the device.
  static Future<void> setOrientation(DeviceOrientation orientation) {
    return SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[orientation],
    );
  }

  /// Sets the preferred orientations (landscape left, right, portrait up, or down) for the app.
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible) depending on the physical orientation of the device.
  static Future<void> setOrientations(List<DeviceOrientation> orientations) {
    return SystemChrome.setPreferredOrientations(orientations);
  }

  /// Sets the preferred orientation of the app to landscape only (left or right).
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible).
  static Future<void> setLandscape() {
    return setOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Sets the preferred orientation of the app to landscape left only.
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible).
  static Future<void> setLandscapeLeftOnly() {
    return setOrientation(DeviceOrientation.landscapeLeft);
  }

  /// Sets the preferred orientation of the app to landscape right only.
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible).
  static Future<void> setLandscapeRightOnly() {
    return setOrientation(DeviceOrientation.landscapeRight);
  }

  /// Sets the preferred orientation of the app to portrait only (up or down).
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible).
  static Future<void> setPortrait() {
    return setOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Sets the preferred orientation of the app to portrait up only.
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible).
  static Future<void> setPortraitUpOnly() {
    return setOrientation(DeviceOrientation.portraitUp);
  }

  /// Sets the preferred orientation of the app to portrait down only.
  ///
  /// When it opens, it will automatically change orientation to the preferred one (if possible).
  static Future<void> setPortraitDownOnly() {
    return setOrientation(DeviceOrientation.portraitDown);
  }

  /// Current screen/window size.  Updated whenever the game widget is resized.
  ///
  /// Note: Should not be set by user.
  static Size _size;
  static Size get size => _size;
  static void setSize(Size size) => _size = size; // deliberately wordy setter //TODO hide

  /// Set to a callback function you want called whenever the game widget is resized.
  /// Perhaps to change the [Camera].
  static void Function() onResize;


  /// Waits for the initial screen/window dimensions to be available.
  ///
  /// Because of flutter's issue #5259, when the app starts the size might be 0x0.
  /// This waits for the information to be properly updated.
  ///
  /// NOTE: A best practice would be to implement the resize hooks in your game
  /// and components and don't use this at all. Make sure your components are
  /// able to render and update themselves for any possible screen size.
  static Future<Size> waitForStartupSizing() async {
    // https://github.com/flutter/flutter/issues/5259
    // "In release mode we start off at 0x0 but we don't in debug mode"
    return await Future<Size>(() {
      if (window.physicalSize.isEmpty) {
        final completer = Completer<Size>();
        window.onMetricsChanged = () {
          if (!window.physicalSize.isEmpty && !completer.isCompleted) {
            completer.complete(window.physicalSize / window.devicePixelRatio);
          }
        };
        return completer.future;
      }
      final Size size = window.physicalSize / window.devicePixelRatio;
      setSize(size);
      // Set the camera default.
      //Camera.rect ??= Rect.fromLTWH(0, 0, size.width, size.height);
      // Fin.
      return size;
    });
  }
  //TODO Work this out versus the widget resize code, GameRenderBox.performResize().
  //  We shouldn't have conflicting practices. It is confusing.
  //  We should, for example, be able to set just the camera and not worry about the resizing, etc.

}
