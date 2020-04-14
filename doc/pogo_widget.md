# PogoWidget class

A PogoWidget is a Flutter widget that uses a Pogo component or game entity for rendering.

The `PogoWidget` class is a static class that provides central access to the PogoWidget methods.

## SpriteComponent

A [SpriteComponent](/doc/components/sprite.md) can be used as a widget directly.

Method: `PogoWidget.fromSprite()`

```dart
SpriteComponent sprite = await SpriteComponent.fromRasterFile("minotaur.png", frameWidth: 96, frameHeight: 96);
...
PogoWidget.fromSprite(sprite, const Size(96, 96)),
```

Returns a regular Flutter widget containing the given SpriteComponent
rendered at the given `size`.

This is a thin wrapper that skips creating a [GameEntity](/doc/game_entity.md) for when just an image is needed.

This will create a [CustomPaint](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html) widget using a [CustomPainter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html) for rendering the SpriteComponent.
Be aware that the Sprite must have been loaded, otherwise it can't be rendered.

See the [**animation_widget** example app](/doc/examples/animation_widget/lib/main.dart).

## AnimationComponent

An [AnimationComponent](/doc/components/animation.md) can be used as a widget directly.

Method: `PogoWidget.fromAnimation()`

```dart
SpriteImage minotaur = await Assets.rasterCache.load("minotaur.png");
...
PogoWidget.fromAnimation(
    AnimationComponent.fromRaster(
      minotaur,
      frameWidth: 96,
      frameCount: 19,
    ),
    const Size(256.0, 256.0)
),
```

Returns a regular Flutter widget containing the given AnimationComponent
rendered at the given `size`.

This is a helper method for creating a [GameEntity](/doc/game_entity.md) from the given AnimationComponent and size.
This scales the animation for you (based on frame 0) and then calls `fromEntity()`.

This creates an [EmbeddedGameWidget](TODO) with a [PseudoGame](TODO) whose only content is a GameEntity.
This is intended to be used by non-game apps that want to add a spritesheet animation.

See the [**animation_widget** example app](/doc/examples/animation_widget/lib/main.dart).

## GameEntity

Any [GameEntity](/doc/game_entity.md) can be used as a widget.

Method: `PogoWidget.fromEntity()`

Returns a regular Flutter widget containing the given GameEntity
that reserves UI space according to the given `reservedSize`
(which the game entity is NOT restricted to).

This creates an [EmbeddedGameWidget](TODO) with a [PseudoGame](TODO) whose only content is a GameEntity.
You can use this implementation as base to create your own widgets based on more complex game entities.
This is intended to be used by non-game apps that want to add sprite animations and such.

See the [**widgets** example app](/doc/examples/widgets/lib/main.dart).



----

**//TODO: ignore the following -- the NineTileBox (now NinePatch) that I found did not support `child` widgets**

# Flutter widgets

One cool feature when developing games with Flutter is the ability to use Flutter's extensive toolset for building UIs, Flame tries to expand that introducing widgets which are specially made with games in mind.

Here you can find all the available widgets provided by Flame.

You can also see all the widgets showcased inside a [Dashbook](https://github.com/erickzanardo/dashbook) sandbox [here](/doc/examples/widgets)

### Nine Tile Box

A Nine Tile Box is a rectangle drawn using a grid sprite.

The grid sprite is a 3x3 grid and with 9 blocks, representing the 4 courners, the 4 sides and the middle.

The corners are drawn at the same size, the sides are streched on the side direction and the middle is expanded both ways.

The `NineTileBox` widget implements a Container using that standard. This pattern is also implemented in game by the `NineTileBoxComponent` where you can use this same feature, but directly into the game Canvas, to know more about this, check the component docs [here](doc/components.md#nine-tile-box-component).

Here you can find an example of its usage:

```dart
import 'nine_patch.dart';

NineTileBox(
        image: image, // dart:ui image instance
        tileSize: 16, // The width/height of the tile on your grid image
        destTileSize: 50, // The dimensions to be used when drawing the tile on the canvas
        child: SomeWidget(), // Any Flutter widget
)
```
