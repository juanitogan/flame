# Pogo Reference Documentation

Shortcuts to other docs:

 * [Pogo README](/README.md).  Read this first.  It includes the [Getting Started Guide](/README.md#getting-started-guide).
 * [Pogo FAQ](/doc/FAQ.md)
 * [Pogo CHANGELOG](/CHANGELOG.md)

## Contents

 * Core concepts
   - [Game Engine Basics](game.md)
   - [GameEntity class](game_entity.md)
   - [Components](components.md)
   - [Input (gesture mixin components)](input.md)

 * Static classes
   - [Assets](statics/assets.md)
   - [Camera](statics/camera.md)
   - [GameCanvas](statics/game_canvas.md)
   - [GestureInitializer](input.md#gestureinitializer-class)
   - [Screen](statics/screen.md)
   - [System](statics/system.md)
   - [Time](statics/time.md)

 * Assets
   - Audio
     - [General Audio](audio/audio.md)
     - [Looping Background Music](audio/bgm.md)
   - Images
     - [SpriteImage](images/sprite_image.md)
       - [Raster](images/raster.md)
       - [SVG](images/svg.md)
   - Caches
     - [AudioCache](caches/audio_cache.md)
     - [RasterCache](caches/raster_cache.md)
     - [SvgCache](caches/svg_cache.md)
     - [TextCache](caches/text_file_cache.md)

 * Components
   - Built-in
     - [SpriteComponent](components/sprite.md)
     - [AnimationComponent](components/animation.md)
     - [MessageBoxComponent](components/text.md#messageboxcomponent-class)
     - [NinePatchComponent](components/nine_patch.md)
     - [ParallaxComponent](components/parallax.md)
     - [ParticleComponent](components/particle.md)
     - [TextComponent](components/text.md)
     - [TimerComponent](components/timer.md)
   - External plugins
     - [RiveComponent](https://github.com/juanitogan/pogo_rive)
     - [TiledComponent](https://github.com/juanitogan/pogo_tiled)
     - [Box2D](https://github.com/juanitogan/pogo_box2d)

 * Miscellaneous
   <!-- - [Gamepad](gamepad.md) -->
   - [Pivot type](pivot.md)
   - [PogoWidgets](pogo_widget.md)
   - [Prefabs](prefabs.md)

## 3rd-party tools

Note that these are untested with Pogo but may be of use:

 * [flame_gamepad](https://github.com/fireslime/flame_gamepad) adds support for gamepads. Android only.
 * [play_games](https://github.com/luanpotter/play_games) integrates to Google Play Games Services (GPGS). Android only. Adds login, achievements, saved games and leaderboard. Be sure to check the instructions on how to configure, as it's not trivial.
