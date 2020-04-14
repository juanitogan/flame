# Game Engine Basics

The game loop iterates over game entities and executes the `update()` methods in each.  This is where you update entity and component state, and render any components that need rendering (by calling component `update()` and/or `render()` methods).  Seconds since the last update is found in `Time.deltaTime`.

The class `Game` is a singleton that gets instantiated on the first reference to it.  The singleton is always available as `Game()`.
 
`Game().widget` is a reference to the game widget.  `runApp()` will run a widget and attach it to the screen.  Thus, `runApp(Game().widget)` will start the game engine.

## Game engine config and startup

This is the recommended sequence of code to start a game (the rest will be explained below):

```dart
import 'package:pogo/game_engine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required
  await Screen.setFullScreen();
  await Screen.setPortrait();

  GestureInitializer.detectTaps = true;
  GestureInitializer.detectPans = true;

  await Assets.audioCache.load("explosion.mp3");

  await Assets.rasterCache.load("background.png");

  await Assets.svgCache.loadAll(["enemy.svg", "player.svg"], scale: 0.75);

  runApp(Game().widget); // required

  await Screen.waitForStartupSizing(); // required

  MainEntity(); // you can name your startup entity whatever you like
}

class MainEntity extends GameEntity {
  MainEntity() {}
}
```

Line by line:

`WidgetsFlutterBinding.ensureInitialized()` is required as the first line if you want to call setup features like `Screen.setFullScreen()` before you call `runApp()`.

The [`Screen` static class](/doc/statics/screen.md) contains some setup functions.

The [`GestureInitializer` static class](/doc/input.md#gestureinitializer-class) contains flags for setting up the main [`GestureDetector`](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html) in the game engine.  You must initialize all gestures here that will be used anywhere in your game.

The [`Assets` static class](/doc/statics/assets.md) contains caches for some assets.  It is recommended to cache your assets (the ones that currently _can_ be cached).  It is not required to cache them in your `main()` but this is a good place to do it for simple games.  More complex games will want to use the cache features to load and clear assets.

`Screen.waitForStartupSizing()` is the current recommended way to allow Flutter time to startup and size the game widget.  This also sets `Screen.size` for the first time.

`runApp(Game().widget)` starts the game engine.

At this point, you can now call and instantiate your first [game entity](/doc/game_entity.md) (called `MainEntity()` in this example).

## Debug mode

Debug mode can be turned on with `Game().debugMode = true`.  This enables FPS calculating with `Game().fps(frameSpan)`.  This also turns on some extra visualizations for game entities.  Some components may also provide extra visualizations.

See the [debug example app](/doc/examples/debug).

## Flutter widgets

:warning: I can't say this feature is working at the moment.

Because a Pogo game is a widget itself, it is possible to use Flutter widgets and a Pogo game together. To facilitate this, Pogo provides a `mixin` called `HasWidgetsOverlay` which will enable any Flutter widget to be shown on top of your game instance. This makes it easy to create things like a pause menu or an inventory screen, for example.

To use it, simply add the `HasWidgetsOverlay` `mixin` on your game class, by doing so, you will have two new methods available `addWidgetOverlay` and `removeWidgetOverlay`, like the name suggests, they can be used to add, or remove widgets overlay above your game, they can be used as shown below:

```dart
addWidgetOverlay(
  "PauseMenu", // Your overlay identifier
  Center(child:
      Container(
          width: 100,
          height: 100,
          color: const Color(0xFFFF0000),
          child: const Center(child: const Text("Paused")),
      ),
  ) // Your widget, this can be any Flutter widget
);

removeWidgetOverlay("PauseMenu"); // Use the overlay identifier to remove the overlay
```

Under the hood, Flame uses a [Stack widget](https://api.flutter.dev/flutter/widgets/Stack-class.html) to display the overlay, so it is important to __note that the order which the overlays are added matter__, where the last added overlay will be in front of those added before.

See the [widgets overlay example app](/doc/examples/with_widgets_overlay).
