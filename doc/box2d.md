# Box2D

Pogo bundles Flame's [Box2D fork](https://github.com/flame-engine/box2d.dart) of Google's [Dart port of Java's Box2D port](https://github.com/google/box2d.dart).

There is a simple example game that can be used as reference of how to use Box2D on Flame (0.6.x) [here](https://github.com/feroult/haunt).  How much of this applies to Pogo as well has yet to be determined.

### old details:

The whole concept of a box2d's World is mapped to the `Box2DComponent` component; every Body should be a `BodyComponent`, and added directly to the `Box2DComponent`, and not to the game list.

So you can have HUD and other non-physics-related components in your game list, and also as many `Box2DComponents` as you'd like (normally one, I guess), and then add your physical entities to your Components instance. When the Component is updated, it will use box2d physics engine to properly update every child.

## Properties

**//TODO: The `Box2DComponent` and supporting objects are waiting to be Pogo-ized still... and may not actually be a component.**
