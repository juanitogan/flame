# Prefabs

Prefabs are prefabricated [game entities](game_entity.md) intended for simple and one-time-use of a [component](components.md).  Thus, there is one prefab for each class-type component.  There is also, currently, one other experimental prefab for gestures.

Note that most prefabs do not implement [gestures](input.md) as that is generally beyond the intended purpose of prefabs.  If nothing else, it would lead to too many prefab variants.
It is possible to extend a prefab with gesture mixins but this is not
considered best practice versus extending GameEntity...
but not really considered bad practice either.  It's a style choice.

| Contents |
| :-- |
| [SpritePrefab](#spriteprefab) <br/> [AnimationPrefab](#animationprefab) <br/> [FlarePrefab](#flareprefab) <br/> [MessageBoxPrefab](#messageboxprefab) <br/> [NinePatchPrefab](#ninepatchprefab) <br/> [ParallaxPrefab](#parallaxprefab) <br/> [ParticlePrefab](#particleprefab) <br/> [TapAreaPrefab](#tapareaprefab) <br/> [TextPrefab](#textprefab) <br/> [TiledPrefab](#tiledprefab) <br/> [TimerPrefab](#timerprefab) |

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

Currently has a `progress` property... but can't promise what it might have after a needed refactor.

## TapAreaPrefab

Implements the [GestureArea](input.md#gesturearea-mixin) mixin and the [TapDetector](input.md#gesture-detector-mixins) mixin and no visual components.  Experimental.

This is intended for use only with overly-simple GUI objects that have more than one hot spot.  For example, a yes/no message box with static, pre-drawn buttons.  If, instead, you have a separate button object, that button should be its own GameEntity with gesture mixins plus a visual component (such as an AnimationComponent, for example).

## TextPrefab

Implements [TextComponent](components/text.md).

## TiledPrefab

Implements [TiledComponent](components/tiled.md).

## TimerPrefab

Implements [TimerComponent](components/timer.md).

May someday after a rewrite: ~~Adds `destroyOnFinish` constructor parameter and property.~~
