# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- `NinePatchComponent` refactor.
- `ParallaxComponent` refactor.  Add SVG too.  Consider keeping in core or move out.  (I don't use this and instead use SpriteComponents to make my own parallaxes.)
- `ParticleComponent` and `ParticlePrefab` refactor.  Consider keeping in core or move out.
- `TimerComponent` refactor.
- Take another look at message boxes and text. They're stable for now but there is probably much to do still.
- Investigate the minor artifacts from non-integer canvas scaling in low-res games.
- I've noticed math and/or scaling/position problems with the `--enable-software-rendering` flag in both API 16 and 23 (and likely all others).


## [0.2.1] - 2020-06-20
### Changed
- Reverted flutter_svg 0.18.0 back to 0.17.3+1 because the latest version depends on a pre-release version of Flutter.  Who builds packages like this?


## [0.2.0] - 2020-06-20
### Changed
- **WARNING: Breaking changes!**
- This update introduces "built-in" and "external" components (plugins).  Components (and their respective particles and prefabs) that were not deemed necessary for the core of a basic 2D engine were moved to their own projects (`pogo_*`).  This meant, especially, components that rely on 3rd-party libraries: `TiledComponent`, `FlareComponent`, and `Box2DComponent`.
  - Not sure yet about non-3rd-party extras such as: `ParticleComponent` and `ParallaxComponent`.  These are currently a mess and I can't say I'll ever find time to dig into them.
  - After looking at the continued growing pains of Flame and its willy-nilly addition of any component that doesn't break the engine -- regardless of how muddy or useless it is -- I have once again been inspired to "do it different" with Pogo.  Flame has been really helpful in this regard.
  - Moving 3rd-party plugins out should push Pogo significantly towards version 1.0.
  - This should also simplify PR handling and maybe even help these components get the attention they need.

### Removed
- TiledComponent and TiledPrefab moved out to its own `pogo_tiled` project.
- FlareComponent, FlareParticle, and FlarePrefab moved out to its own `pogo_rive` project.  Everything here was renamed from Flare to Rive to match the new branding of the Rive product.
- All Box2D stuff moved out to its own `pogo_box2d` project.  Moving Box2D out was a tough decision.  On one hand, it can be appropriate for a game engine to include a physics engine.  On the other hand, Pogo is just a thin layer on top of Flutter and probably should not be dictating which physics engine a game dev should be using.  Also, the Box2D integration still needs major analysis and refactoring.  Seeing it in Flame as a single "component" or two makes my brain hurt.  It should be another type of plugin (perhaps a mixin) that comes with a suite of components.


## [0.1.2] - 2020-05-27
### Added
- Added web app hints to some docs.

### Changed
- Removed yet another unused import identified by pub.dev.

### Removed
- Removed the `PogoBinding` class that extended BindingBase.  This was a relic from Flame (called FlameBinding) of unknown use except for a note that it was used to setup Flutter services.  It looked like a singleton.  Likely something needed for an early version of Flutter.  Anyhow, the latest Flutter in the beta channel doesn't like it, so I simply removed it due to no known references to it.


## [0.1.1] - 2020-05-24
### Added
- Now published on [pub.dev](https://pub.dev/packages/pogo).

### Changed
- `pubspec.yaml`: updated `audioplayers` from 0.14.0 to 0.15.1 as suggested by pub.dev.
- Removed a couple unused imports identified by pub.dev.


## [0.1.0] - 2020-05-24
With the release of [_Pogo Bug_](https://play.google.com/store/apps/details?id=com.littlebigspeed.pogobug) on Android, the Pogo Game Engine is now bona fide and ready for release as v0.1.0.

### Changed
- `pubspec.yaml`: updated `path_provider` from 1.6.0 to 1.6.6 to remove a bug/warning.
- `pubspec.yaml`: updated `flutter_svg` from 0.17.1 to 0.17.4 to work with the latest Flutter update.
- Minor doc edits.


## [0.0.3] - 2020-04-25
### Added
- `TapAreaPrefab` is an experimental prefab to aid in creating simple GUI dialogs (or other objects) that may have more than one hot spot.

### Changed
- **WARNING: Breaking changes!**
- `GestureZone` etc. renamed to `GestureArea` etc. to be more consistent with Flutter lingo (I hope).  To update, do a non-word global replace that preserves case.


## [0.0.2] - 2020-04-21
### Added
- `AnimationComponent.frameCount` property added (not sure where this went or what I was thinking).
- `Pivot.translateWH()` method added.  Takes two doubles: width and height.
- `AnimationComponent.currentFrameWidth` and `.currentFrameHeight` props added (doubt I'll add size, top, left, offset, rect, but maybe should).
- `System.defaultPaint` for setting up the default Paint (namely, `isAntiAlias = false` for low-res games).

### Changed
- Various doc edits.
- The introduction of `System.defaultPaint` and elimination of `palette.dart` brought various changes throughout.

### Fixed
- `MessageBox` text parsing fixed to handle one line without dropping a char.

### Removed
- **WARNING: Breaking changes!**
- `SpritePrefab.empty()` constructor removed.  Was left over from testing.
- `PaletteEntry` and `BasicPalette` (all of `palette.dart`) classes removed.  These are helper classes that confuse best practice more than helping.  I figure less than 1% are likely to use.  And, of those, most would be better off with their own solution for Color/Paint constants (or use material.Colors).  Dart's Color and Paint classes are not too hard for game dev as they are.  Given the need for `Paint.isAntiAlias` (and possibly other Paint props) in some games, this really complicates a universal helper.


## [0.0.1] - 2020-04-13
This project was forked from [Flame 0.18.1](https://github.com/flame-engine/flame/tree/0.18.1) and this is the first commit as Pogo.  I have some previous commits after Flame 0.18.1 that were submitted as a PR to Flame but that PR was not accepted.  Thus, Pogo was born.  Those changes are here along with many more changes to just about every part of the code.  This includes the introduction of entities and a significant redefinition of what a component is.  I will attempt to give a pretty good overview of all changes here.  The degree of changes is too great to hope to list in absolute detail.  Just look at the [diffs of the commits](https://github.com/flame-engine/flame/compare/0.18.1...juanitogan:0.0.1) leading up to this version and you'll see what I mean.

### Added
- `game_engine.dart` exports every feature of the engine.  Thus, only one import needed now: `import 'package:pogo/game_engine.dart';`.  Still working on best practices for import/export.
- `GameEntity` new fundamental class that replaces `Component` etc.  Also comes with new features/properties: `enabled`, `zOrder`, `scale`, `parent`, `addChild()`, `removeChild()`, `getChildren()`.
- `zOrder` adds fully-dynamic z-ordering (integer based... but you can pretend it is scaled-int if you like).  A critical feature, I think.
- `SpriteImage` superclass and subtypes `Raster` and `Svg`.  For granting equal rights to the new image types to components that can use either.
- SVG support now built into `SpriteComponent` by use of the new `SpriteImage` superclass.  This cascades to supporting SVGs in `AnimationComponent`.  (More components need this change.)
- `AnimationComponent.paused` feature added.  Particularly useful for those that need to control the `currentFrame` prop in code.
- `AnimationComponent` methods: `advance()`, `pause()`, `resume()`.
- `GestureInitializer` static class in `widget_builder.dart` for setting up the main `GestureDetector`.
- `GestureZone` mixin for help limiting gestures to just the entity they are attached to.
- Created a complete set of scale-adaptive, gesture-detector mixins (and renamed `Tapable` to `TapDetector`).
- Created several well-divided static classes: `System`, `Time`, `Screen`, `GameCanvas`, `Camera`, `Assets`, `PogoWidget`.
- `Assets.svgCache` and `SvgCache` class added.
- `Assets.xxxxxCache.get(filename)` method added to encourage explicit cache use.
- `Assets.xxxxxCache.setSubPath(subPath)` method added to override default path under `/assets`.
- `System.defaultPivot` added to allow overriding the new default of `Pivot.center`.
- `Time.now`, `Time.unscaledNow`, `Time.frameCount` fields added.  Note: scaled-time features (like pause) not yet built.
- `Screen.onResize` for setting a callback when the screen/window gets resized (in case you want to adjust the `Camera` or whatever).
- `Camera` static class adds a new camera methodology with both offset and size/scaling.  Hint: scaling is particularly useful for low-res games.
- `vector_math.dart` to promote easy use of `Vector2` et al throughout your code, and for easier integration with Box2D.
- `/example` -- wrote a new main example app showing a few more features.  (Moved the old one to `/doc/examples/primatives` with a couple interesting changes.)

### Changed
- **WARNING: Breaking changes!**
- `Game` renamed to `GameCore` and `BaseGame` renamed to `Game` (not that they look much like their former selves).
- The new `Game` is now a singleton and `GameCore` only exists for adventurous souls who want a starting point for their own engine.  I am aware of the many differing opinions of the use of singletons, static classes, etc... but I eventually came to the conclusion that the best-practice rules can be different for an engine versus the rules for the apps that run on that engine.  Thus, the pros for the `Game()` singleton far outweighed the cons.  Really, the only cons I could find had to do with PogoWidget/PseudoGame and, since that is not a tier-1 feature, it had little weight.
- `update()` and `render()` no longer pass any data (and `resize()` was completely removed, see Removed section below).  The data was moved to static classes.  See `Time.deltaTime` and `GameCanvas.main`.  (`render()` now also removed.)
- `BaseGame.camera` (Position) replaced with a new `Camera.rect` paradigm.
- `BaseGame.size` moved to `Screen.size` and initialized in more ways (and still probably needs more working out).
- `BaseGame.debugMode()` moved to `GameCore.debugMode` and not propagated to entities either.  Use `Game().debugMode` to read.  Look for other changes and new visualizations and data here.
- More `BaseGame` changes not bothering to list.
- The `Flame` static class and the `Util` helper class were replaced by several static classes.  Most of the contents of `Flame` was moved to `Assets`.  Most of the contents of `Util` was moved to `Screen`.
- Caches renamed, `Flame.images` to `Assets.rasterCache`, `Flame.audio` to `Assets.audioCache` (and their respective classes renamed too: `FlameAudio` to `AudioCache`, etc.).  Others?
- Cache methods renamed, `clear()` to `remove()`, `clearCache()` to `clear()`, to be more in line with other Dart objects.
- Regarding what Flamed called "components," this took a great deal of sorting out -- all the details of which I will not list.  The base `Component` seemed be part-component/part-entity, while handling neither well, and with confusing mixin dependencies.  Thus, most feature components had a similar identity crisis where most were some sort of entity/component combo, while others were specialized entities, and others were a difficult mash of entity, component, and/or primitive object.  Fixing this broke everything (to put it lightly) and triggered the majority of all the other changes here.  In short, and very loosely, `Component`+`PositionComponent`+`ComposedComponent` became `GameEntity` with true-component features (like size) removed.  Some components were renamed to prefabs (such as `AnimationComponent` to `AnimationPrefab`, then `Animation` to `AnimationComponent`, same with sprites) while most others were demoted to simple components by stripping out the entity stuff.  These kept their name and new prefabs were created for them.  What this adds up to, for the most part, is that `add()` (which is no longer used) is replaced by a call to the prefab instead (i.e. `add(SpriteComponent())` to `SpritePrefab(SpriteComponent())`) and then the contained component syntax needs to be fixed, and the new prefab syntax added.  Get all that?  **Yeah, it's gonna be a mess if trying to port a large project from Flame.**
- `isHud()` replaced by `isOverlay`.  (Not sure what all the functions were about.)  More generic term.  Not all overlays are HUDs.
- The static `priority()` was replaced by `zOrder` which is also now fully dynamic.
- `angle` renamed to `rotation` (and added `rotationDeg`).
- `Anchor` class renamed to `Pivot` and expanded with more translate methods.  "Anchor" was not incorrect.  I wanted to clarify the nuances between anchoring in UI engines and pivoting in game engines.
- Changed default pivot (anchor) from `topLeft` to `center`.  Default can now also be set in `System`.
- All `Sprite` and `Animation` (renamed to `SpriteComponent` and `AnimationComponent`) constructors refactored with focus on simplifying, clarifying, and flexibility.  (This is where I first started into this can of worms, BTW.)  Most properties are now included as optional named parameters in the constructors.  (Modeled loosely after Qt's [AnimatedSprite](https://doc.qt.io/qt-5/qml-qtquick-animatedsprite.html).)  All async instantiations have been moved to Future<> methods.
- The flexibility from the above changes eliminates the need for the animation `sequence` constructor... as well as the entire `spritesheet` module.  Admittedly, the new way can get a bit wordy (as seen in the updated `spritesheet` example app) but can also be beautifully simple (as seen in the updated `particles` example app).
- `Raster` image slicing now happens via integer parameters instead of doubles (when using the raster-specific constructors).  I find it very odd if have to do counter-intuitive things like `width: image.height.toDouble()` to slice an image for an animation.  Don't worry, the sprites and animations are still positioned and sized with doubles.
- Because I was breaking so much, I went a little further than normal in renaming a few minor things. `textureWidth` etc. are now `frameWidth` etc.  `currentIndex` is now `currentFrame` (and the previous `currentFrame` getter was removed).  `done()` is now `isFinished`.  `getSprite()` is now `getCurrentSprite()`.  Others I'm probably forgetting (like whatever `frameCount` was before).
- `Animation.reversed()` replaced by a new and fancy `AnimationComponent.reverse` mechanism instead.  `reversed()` was a surprising deep-copy function.  If wanting a deep-copy feature, be less surprising about it, and then reverse it if wanted.
- `FlareComponent` refactored similar to sprite and SVG handling.  `FlareAnimation` renamed to `FlareComponent`, `FlareComponent` renamed to `FlarePrefab` among other things like adding a pivot.
- `TextConfig.render()` moved to `TextComponent` because it gave the `TextConfig` type too much personality while `TextComponent` didn't have enough.  This forced all example apps to a better practice of using text components and/or prefabs.  Debug-mode text reverted to lower-level code and painting.  Regarding debug-mode text, if you really need helpers for drawing such text, then create a debug-mode-specific helper elsewhere.
- `TextConfig.withXxxx()` helpers replaced by more flexible and more standard `copyWith()`.
- `NineTileBoxComponent` renamed to `NinePatchComponent` to match Flutter and other sources.
- `TextBoxComponent` renamed to `MessageBoxComponent` because, well, a box with text in it is not always a text box.  Also underwent lingo and many other changes.  Still much to do, it appears.
- `TimerComponent` has some lingo changes, and also still in need of rethink.
- `ComponentParticle` renamed to `EntityParticle`.
- `WidgetBuilder` now ignores unneeded/deprecated events (assuming I understand `GestureDetector` mojo correctly, which I may not).
- Many, many source files split/renamed/moved/deleted.  Folders too.
- All example apps fixed, axed, or replaced.  Well, okay, a couple still give some trouble that I can't seem to care about much right now.
- All docs totally rewritten.  _"Totally."_  Tried to remove all conflicting info and also write something easier to ramp up on.  This took almost as much time as the rest.

### Removed
- **WARNING: Breaking changes!**
- `resize()` method and all related objects.  Not needed with the new camera and resize callback.  This feature has confused me since I haven't seen anything like it before and I fail to see why camera position and scaling can't handle everything.  But, well, maybe someone has a use case they can show me.
- `render()` removed after finding little reason to keep it.  Things run just fine without it and, given Flutter's control of these lower-lever things like execution order, why pretend otherwise?
- `Spritesheet` helper class.  Not needed with the new sprite and animation constructors.
- `SvgComponent` thingy class.  SVG support built into the new `SpriteComponent`.
- `ComposedComponent` mixin.  Concept built-in with new design.
- `HasGameRef` mixin.  Made moot by `Game()` singleton.
- `Position` data type.  Replaced by `Vector2` or `Offset`.
- `renderFlipX/Y` props.  Replaced by negative scaling which does the same thing.
- `angleBetween()` helper.  Made redundant by `position.angleTo()`.
- `distance()` helper.  Made redundant by `position.distanceTo()`.
- `prepareCanvas()` made redundant by new design.
- `add(Component)` is no longer needed to add objects to the game loop.  "Adding" is now automatic in the entity constructor.
- `/doc/examples/tapable` example app removed as it became redundant to `gestures`.  At least one other I don't recall.


## [Flame 0.18.1](https://github.com/flame-engine/flame/tree/0.18.1) - 2020-02-09


[Unreleased]: https://github.com/juanitogan/pogo/compare/0.2.1...HEAD
[0.2.1]: https://github.com/juanitogan/pogo/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/juanitogan/pogo/compare/0.1.2...0.2.0
[0.1.2]: https://github.com/juanitogan/pogo/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/juanitogan/pogo/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/juanitogan/pogo/compare/0.0.3...0.1.0
[0.0.3]: https://github.com/juanitogan/pogo/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/juanitogan/pogo/compare/0.0.1...0.0.2
[0.0.1]: https://github.com/flame-engine/flame/compare/0.18.1...juanitogan:0.0.1
