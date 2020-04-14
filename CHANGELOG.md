# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- Box2D analysis and likely refactor.
- `NinePatchComponent` refactor.
- `ParallaxComponent` refactor.  Add SVG too.  Consider keeping feature or not.
- `ParticleComponent` and `ParticlePrefab` refactor.
- `TiledComponent` refactor.
- `TimerComponent` refactor.
- Take another look at message boxes and text. They're stable for now but there is probably much to do still.
- Evaluate `palette.dart`.


## [0.0.1] - 2020-04-04
This project was forked from [Flame 0.18.1](https://github.com/flame-engine/flame/tree/0.18.1) and this is the first commit as Pogo.  I have some previous commits after Flame 0.18.1 that were submitted as a PR to Flame but that PR was not accepted.  Thus, Pogo was born.  Those changes are here along with many more changes to just about every part of the code.  This includes the introduction of entities and a significant redefinition of what a component is.  I will attempt to give a pretty good overview of all changes here.  The degree of changes is too great to hope to list in absolute detail.  Just look at the diffs over my last few commits and you'll see what I mean.

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
- Cache methods renamed, `clear()` to `remove()`, `clearCache()` to `clear()`, to be more inline with other Dart objects.
- Regarding what Flamed called "components," this took a great deal of sorting out -- all the details of which I will not list.  The base `Component` seemed be part-component/part-entity, while handling neither well, and with confusing mixin dependencies.  Thus, most feature components had a similar identity crisis where most were some sort of entity/component combo, while others were specialized entities, and others were a difficult mash of entity, component, and/or primitive object.  Fixing this broke everything (too put it lightly) and triggered the majority of all the other changes here.  In short, and very loosely, `Component`+`PositionComponent`+`ComposedComponent` became `GameEntity` with true-component features (like size) removed.  Some components were renamed to prefabs (such as `AnimationComponent` to `AnimationPrefab`, then `Animation` to `AnimationComponent`, same with sprites) while most others were demoted to simple components by stripping out the entity stuff.  These kept their name and new prefabs were created for them.  What this adds up to, for the most part, is that `add()` (which is no longer used) is replaced by a call to the prefab instead (i.e. `add(SpriteComponent())` to `SpritePrefab(SpriteComponent())`) and then the contained component syntax needs to be fixed, and the new prefab syntax added.  Get all that?  **Yeah, it's gonna be a mess if trying to port a large project from Flame.**
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
- `prepareCanvas()` made redundant by new design. **************************
- `add(Component)` is no longer needed to add objects to the game loop.  "Adding" is now automatic in the entity constructor.
- `/doc/examples/tapable` example app removed as it became redundant to `gestures`.  At least one other I don't recall.

## [Flame 0.18.1](https://github.com/flame-engine/flame/tree/0.18.1) - 2020-02-09
