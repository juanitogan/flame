import 'dart:convert';

import 'package:pogo/src/components/sprite_component.dart';
import 'package:pogo/src/game/time_static.dart';
import 'package:pogo/src/game/assets_static.dart';

export 'package:pogo/src/components/sprite_component.dart';

/// Represents a single animation frame.
class Frame {
  /// The [SpriteComponent] to be displayed.
  SpriteComponent sprite;

  /// Seconds to display this frame.
  double duration;

  /// Creates a frame from a [SpriteComponent] and duration time in seconds.
  Frame(this.sprite, this.duration);
}

/// Represents an animation, that is, a list of sprites that change with time.
class AnimationComponent {
  List<Frame> _frames;
  /// The frames that compose this animation.
  List<Frame> get frames => _frames;

  double _startTime = Time.now;
  /// Seconds of elapsed time since start or last reset.
  double get elapsed => _paused ? _pauseStartTime - _startTime : Time.now - _startTime;
  //double elapsed = 0.0;

  double _frameStartTime = Time.now;
  /// Seconds of elapsed time since start of current frame.
  double get frameElapsed => _paused ? _pauseStartTime - _frameStartTime : Time.now - _frameStartTime;
  //double frameElapsed = 0.0;

  double _pauseStartTime = Time.now; // set time for instantiating paused
  /// Seconds of elapsed time since paused.
  double get pausedTime => _paused ? Time.now - _pauseStartTime : 0.0;

  /// Index of the current frame that should be displayed.
  int currentFrame = 0;

  /// Whether the animation runs forwards or in reverse. Should respond to mid-animation toggling.
  bool reverse = false;

  /// Whether the animation loops after the last sprite of the list, going back to the first, or keeps returning the last when done.
  bool loop = true;

  /// Pauses the animation.
  bool _paused = false;
  bool get paused => _paused;
  set paused(bool b) => b ? pause() : resume();


  /// Creates an animation given a list of frames.
  ///
  /// [reverse]: reverses the animation frames if set to true (default: false)
  /// [loop]: whether the animation loops (default: true)
  /// [paused]: returns the animation in a paused state (default: false)
  AnimationComponent(
      this._frames,
      {
        this.loop = true,
        this.reverse = false,
        paused = false,
      }
  ) {
    currentFrame = reverse ? frames.length - 1 : 0;
    _paused = paused;
  }

  /// Creates an empty animation
  AnimationComponent.empty();

  /// Creates an animation given a list of [SpriteComponents] ([Raster] or [Svg] based).
  ///
  /// [frameDuration]: the duration of each frame, in seconds (default: 0.1)
  /// [frameDurations]: list of duration values, one for each frame (overrides frameDuration if given)
  /// [reverse]: reverses the animation frames if set to true (default: false)
  /// [loop]: whether the animation loops (default: true)
  /// [paused]: returns the animation in a paused state (default: false)
  AnimationComponent.fromSpriteList(
      List<SpriteComponent> sprites,
      {
        double frameDuration = 0.1,   //TODO consider making this
        List<double> frameDurations,  //TODO or this required
        this.reverse = false,
        this.loop = true,
        paused = false,
      }
  ) {
    if (sprites.isEmpty) {
      throw Exception('You must have at least one frame!');
    }
    _frames = List<Frame>(sprites.length);
    for (var i = 0; i < frames.length; i++) {
      frames[i] = Frame(sprites[i], frameDurations == null ? frameDuration : frameDurations[i] ?? frameDuration);
    }
    currentFrame = reverse ? frames.length - 1 : 0;
    _paused = paused;
  }

  /// Creates an animation from a [Raster] sprite sheet.
  ///
  /// From a single image source, it creates multiple sprites based on the parameters:
  /// [frameLeft]: x position in the image to start slicing from (default: 0)
  /// [frameTop]: x position in the image to start slicing from (default: 0)
  /// [frameWidth]: width of each frame (default: null, that is, full width of the sprite sheet)
  /// [frameHeight]: height of each frame (default: null, that is, full height of the sprite sheet)
  /// [firstFrame]: which frame in the sprite sheet starts this animation (zero based, default: 0)
  /// [frameCount]: how many sprites this animation is composed of (default: 1)
  /// [frameDuration]: the duration of each frame, in seconds (default: 0.1)
  /// [frameDurations]: list of duration values, one for each frame (overrides frameDuration if both given)
  /// [reverse]: reverses the animation frames when set to true (default: false)
  /// [loop]: loops the animation when set to true (default: true)
  /// [paused]: returns the animation in a paused state (default: false)
  /// [pivot]: pivot point for rotation and anchor point for placement (default: Pivot.center or current default)
  ///
  /// For example, if you have a 320x320 sprite sheet filled with 32x32 frames (10x10 columns/rows),
  /// this will grab 8 frames of animation from the start of the third row:
  ///     Animation.fromImage(image, frameWidth: 32, frameHeight: 32, firstFrame: 20, frameCount: 8);
  /// Alternatively, so will this:
  ///     Animation.fromImage(image, frameTop: 32 * 2, frameWidth: 32, frameHeight: 32, firstFrame: 0, frameCount: 8);
  /// The slicer auto-wraps when X is out of bounds, so even this will grab the same as above:
  ///     Animation.fromImage(image, frameLeft: 32 * 20, frameWidth: 32, frameHeight: 32, frameCount: 8);
  AnimationComponent.fromRaster(
      Raster raster,
      {
        int frameLeft = 0,
        int frameTop = 0,
        int frameWidth,
        int frameHeight,
        int firstFrame = 0,
        int frameCount = 1,
        double frameDuration = 0.1,
        List<double> frameDurations,
        this.reverse = false,
        this.loop = true,
        paused = false,
        Pivot pivot,
      }
  ) {
    frameWidth ??= raster.intWidth;
    frameHeight ??= raster.intHeight;
    //
    int x = frameLeft, y = frameTop;
    x += firstFrame * frameWidth; // Exceeding image.width handled later.
    SpriteComponent sprite;
    _frames = List<Frame>(frameCount);
    for (var i = 0; i < frameCount; i++) {
      // Wrap extreme X values to the next row(s).
      // This avoids two things:
      //   1) column/row counting and props; and
      //   2) needing to calc frameTop in a large sheet (if using just frameLeft and not firstFrame).
      if (x >= raster.intWidth) {
        y += (x ~/ raster.intWidth) * frameHeight;
        x = x % raster.intWidth;
      }
      sprite = SpriteComponent.fromRaster(
        raster,
        frameLeft:   x,
        frameTop:    y,
        frameWidth:  frameWidth,
        frameHeight: frameHeight,
        pivot:       pivot,
      );
      frames[i] = Frame(sprite, frameDurations == null ? frameDuration : frameDurations[i] ?? frameDuration);
      x += frameWidth;
    }
    currentFrame = reverse ? frames.length - 1 : 0;
    _paused = paused;
  }

  /// Shortcut wrapper to [fromRaster] that allows skipping a discrete [Raster] get.
  AnimationComponent.fromRasterCache(
      String filename,
      {
        int frameLeft = 0,
        int frameTop = 0,
        int frameWidth,
        int frameHeight,
        int firstFrame = 0,
        int frameCount = 1,
        double frameDuration = 0.1,
        List<double> frameDurations,
        bool reverse = false,
        bool loop = true,
        bool paused = false,
        Pivot pivot,
      }
  ) : this.fromRaster(
      Assets.rasterCache.get(filename),
      frameLeft:      frameLeft,
      frameTop:       frameTop,
      frameWidth:     frameWidth,
      frameHeight:    frameHeight,
      firstFrame:     firstFrame,
      frameCount:     frameCount,
      frameDuration:  frameDuration,
      frameDurations: frameDurations,
      reverse:        reverse,
      loop:           loop,
      paused:         paused,
      pivot:          pivot,
  );

  /// Asynchronous wrapper to [fromRaster] for files (cached or not).
  static Future<AnimationComponent> fromRasterFile(
      String filename,
      {
        int frameLeft = 0,
        int frameTop = 0,
        int frameWidth,
        int frameHeight,
        int firstFrame = 0,
        int frameCount = 1,
        double frameDuration = 0.1,
        List<double> frameDurations,
        bool reverse = false,
        bool loop = true,
        bool paused = false,
        Pivot pivot,
      }
  ) async {
    final Raster raster = await Assets.rasterCache.load(filename);
    return AnimationComponent.fromRaster(
      raster,
      frameLeft:      frameLeft,
      frameTop:       frameTop,
      frameWidth:     frameWidth,
      frameHeight:    frameHeight,
      firstFrame:     firstFrame,
      frameCount:     frameCount,
      frameDuration:  frameDuration,
      frameDurations: frameDurations,
      reverse:        reverse,
      loop:           loop,
      paused:         paused,
      pivot:          pivot,
    );
  }

  /// Creates an Animation using animation data from the json file provided
  /// by Aseprite.
  ///
  /// [imagePath]: Source of the sprite sheet animation (start with path under `assets/images/` if any)
  /// [dataPath]: Animation's exported data in json format (start with path under `assets/` such as: `images/player.json`)
  static Future<AnimationComponent> fromAsepriteData(
      String imagePath,
      String dataPath,
      {
        bool reverse = false,
        bool loop = true,
        bool paused = false,
        Pivot pivot,
      }
  ) async {
    final Raster raster = await Assets.rasterCache.load(imagePath);
    final String content = await Assets.textCache.load(dataPath);
    final Map<String, dynamic> json = jsonDecode(content);

    final Map<String, dynamic> jsonFrames = json['frames'];

    final frames = jsonFrames.values.map((value) {
      final frameData = value['frame'];
      final int x = frameData['x'];
      final int y = frameData['y'];
      final int width = frameData['w'];
      final int height = frameData['h'];

      final frameDuration = value['duration'] / 1000;

      final SpriteComponent sprite = SpriteComponent.fromRaster(
        raster,
        frameLeft:   x,
        frameTop:    y,
        frameWidth:  width,
        frameHeight: height,
        pivot:       pivot,
      );

      return Frame(sprite, frameDuration);
    });

    return AnimationComponent(
        frames.toList(),
        reverse:        reverse,
        loop:           loop,
        paused:         paused,
    );
  }

  /// Whether all sprites composing this animation are loaded.
  bool loaded() {
    return frames.every((frame) => frame.sprite.loaded());
  }


  /// Returns whether the animation is on the last frame.
  bool get isLastFrame => currentFrame == frames.length - 1;
  /// Returns whether the animation is on the first frame.
  bool get isFirstFrame => currentFrame == 0;

  /// The number of frames this animation is composed of.
  int get frameCount => frames.length;

  /// Returns whether the animation has only a single frame (and is, thus, a still image).
  bool get isSingleFrame => frames.length == 1;

  /// If [loop] is false, returns whether the animation is finished (stopped after the final frame).
  ///
  /// Always returns false otherwise.
  bool get isFinished {
    return loop ? false : ((reverse && isFirstFrame) || (!reverse && isLastFrame)) && (frameElapsed >= frames.last.duration);
  }

  /// Sets the same duration to all frames.
  set setFrameDuration(double durationSeconds) {
    frames.forEach((frame) => frame.duration = durationSeconds);
  }
  /// Sets a different duration to each frame.  The length of the List must match `frames.length`.
  set setFrameDurations(List<double> frameDurations) {
    assert(frameDurations.length == frames.length);
    for (int i = 0; i < frames.length; i++) {
      frames[i].duration = frameDurations[i];
    }
  }

  /// Computes the total duration of this animation.
  // Could try to precalc, but a frame's duration could be changed individually at any time.
  double get totalDuration {
    return frames.map((f) => f.duration).reduce((a, b) => a + b);
  }


  /// Advances the animation one frame, looping if allowed, obeys reverse if set.
  void advance() {
    if (reverse) {
      if (!isFirstFrame) {
        currentFrame--;
      } else if (loop) {
        currentFrame = frames.length - 1;
      }
    } else {
      if (!isLastFrame) {
        currentFrame++;
      } else if (loop) {
        currentFrame = 0;
      }
    }
  }

  /// Pause the animation.
  void pause() {
    if (!_paused) {
      _pauseStartTime = Time.now;
      _paused = true;
    }
  }

  /// Resume the animation.
  void resume() {
    if (_paused) {
      _startTime += pausedTime;
      _paused = false;
    }
  }

  /// Resets the animation, like it had just been created.
  void reset() {
    _startTime = Time.now;
    _frameStartTime = Time.now;
    //frameElapsed = 0.0;
    //elapsed = 0.0;
    currentFrame = reverse ? frames.length - 1 : 0;
  }


  /// Updates the animation state.
  void update() {
    if (_paused) {
      // Exit before any time vars increment.
      return;
    }
    //frameElapsed += Time.deltaTime;
    //elapsed += Time.deltaTime;
    if (isSingleFrame) {
      return;
    }
    if (!loop && isLastFrame) {
      return;
    }
    while (frameElapsed > frames[currentFrame].duration) {
      if (loop || (reverse && !isFirstFrame) || (!reverse && !isLastFrame)) {
        //frameElapsed -= frames[currentFrame].duration;
        _frameStartTime += frames[currentFrame].duration;
        advance();
      } else {
        break;
      }
    }
  }

  void render() {
    getCurrentSprite().render();
  }

  /// Gets the current [SpriteComponent] that should be shown.
  SpriteComponent getCurrentSprite() {
    return frames[currentFrame].sprite;
  }
  // Why not a getter? Probably to go with getSprite(frameIndex).
  // Also, possible confusion with currentFrame, which returns the frame index, and not the frame.

}
