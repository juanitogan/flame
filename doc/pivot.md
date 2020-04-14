# Pivot class

The `Pivot` class is a type for defining the pivot (or rotation) point for visible components.  Defines what part of a component's base rectangle is attached to the game entity's `position`.

## Constants

| | |
| :-- | :-- |
| topLeft      | `Offset(0.0, 0.0)` |
| topCenter    | `Offset(0.5, 0.0)` |
| topRight     | `Offset(1.0, 0.0)` |
| centerLeft   | `Offset(0.0, 0.5)` |
| center       | `Offset(0.5, 0.5)` |
| centerRight  | `Offset(1.0, 0.5)` |
| bottomLeft   | `Offset(0.0, 1.0)` |
| bottomCenter | `Offset(0.5, 1.0)` |
| bottomRight  | `Offset(1.0, 1.0)` |

## Properties

| | |
| :-- | :-- |
| offsetFactor * | Final.  X and Y factors in the range of 0.0 to 1.0, used in calculating pivot offset coordinates. |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| translate        | Takes a Size and returns a relative Offset to the pivot point. |
| translateOffset  | Takes an Offset and Size and returns an absolute Offset to the pivot point. |
| translateRect    | Takes a Rect and returns an absolute Rect translated to the pivot point. |
| translateVector2 | Takes a Vector2, width, and height, and returns an absolute Vector2 to the pivot point. |

----

See the [**primatives** example app](/doc/examples/primatives/lib/main.dart).
