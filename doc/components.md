# Components

Components are the building blocks of [game entities](game_entity.md).

An entity can instantiate as many components as needed.  It is, however, unusual to have multiple components of a the same type in a single entity.  For example, an entity will not typically have more than one sprite component unless you have images that should be composed, such as a border image and a content image or animation.  Entities that use multiple images that need to move independent of each other should instead create a child entity for each part.

## Built-in components

Built-in components are the components built into the `GameEntity` class.  Since a game entity, at its most basic, is just a container for components, then the additional features found in `GameEntity` can be considered components.  This includes the transform and the ability to be called by the update and render loops.  In other words, the things that give an entity position, movement, and visibility, etc.  These could have been added by a discrete component but it was considered easiest for engine design and use to build them in -- if nothing else, to make parent-child local transforms easier.

## Mixin components

Mixin components are the components made available by mixin classes.  Currently, only [`GestureArea`](input.md#gestureArea-mixin) and the [gesture detectors](input.md#gesture-detector-mixins) are available as mixins.

## Class-type components

Class-type components are the components available by instantiating a class.

Class-type components must be instantiated by an entity in order to be used (updated and rendered).  These types of components also typically come with an `update()` or a `render()` method (or both, like with the `AnimationComponent`) that must be called from the game entity's own `update()` in order for them to work.

> Note: I may choose to someday automatically register component `update()` and `render()` methods so you don't have to call them explicitly... but not today. 


| Contents |
| :-- |
| [SpriteComponent](components/sprite.md) <br/> [AnimationComponent](components/animation.md) <br/> [FlareComponent](components/flare.md) <br/> [MessageBoxComponent](components/text.md#messageboxcomponent-class) <br/> [NinePatchComponent](components/nine_patch.md) <br/> [ParallaxComponent](components/parallax.md) <br/> [ParticleComponent](components/particle.md) <br/> [TextComponent](components/text.md) <br/> [TiledComponent](components/tiled.md) <br/> [TimerComponent](components/timer.md) |

