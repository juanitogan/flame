# Prefabs

Prefabs are prefabricated [game entities](game_entity.md) intended for simple and one-time-use of a [component](components.md).  Thus, there is one prefab for each class-type component.

Note that prefabs do not implement [gestures](input.md) as you can't prefab responding to a gesture event.
It is possible to extend a prefab with gesture mixins but this is not
considered best practice versus extending GameEntity --
but not considered bad practice either.  It's a style choice.

| Contents |
| :-- |
| [SpritePrefab](#spriteprefab) <br/> [AnimationPrefab](#animationprefab) <br/> [FlarePrefab](#flareprefab) <br/> [MessageBoxPrefab](#messageboxprefab) <br/> [NinePatchPrefab](#ninepatchprefab) <br/> [ParallaxPrefab](#parallaxprefab) <br/> [ParticlePrefab](#particleprefab) <br/> [TextPrefab](#textprefab) <br/> [TiledPrefab](#tiledprefab) <br/> [TimerPrefab](#timerprefab) |

## SpritePrefab

Implements [SpriteComponent](components/sprite.md).

## AnimationPrefab

Implements [AnimationComponent](components/animation.md).

Adds `destroyOnFinish` constructor parameter and property.

## FlarePrefab

Implements [FlareComponent](components/flare.md).

## MessageBoxPrefab

Implements [MessageBoxComponent](components/text.md#messageboxcomponent-class).

Adds `destroyOnFinish` constructor parameter and property.

## NinePatchPrefab

Implements [NinePatchComponent](components/nine_patch.md).

## ParallaxPrefab

Implements [ParallaxComponent](components/parallax.md).

## ParticlePrefab

Implements [ParticleComponent](components/particle.md).

Currently has a `progress` property... but can't promise what it might have after a neede refactor.

## TextPrefab

Implements [TextComponent](components/text.md).

## TiledPrefab

Implements [TiledComponent](components/tiled.md).

## TimerPrefab

Implements [TimerComponent](components/timer.md).

May someday after a rewrite: ~~Adds `destroyOnFinish` constructor parameter and property.~~
