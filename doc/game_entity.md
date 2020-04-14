# GameEntity class

The `GameEntity` abstract class is the basic building block of a game.  It is considered the container for the [components](/doc/components.md) and any child entities that make up a game object.

For an overview of game entities, see the [getting started guide](/README.md#game-entities).

## Properties

| | |
| :-- | :-- |
| debugColor     | Color to draw debug-mode information.  Default: `Color(0xFFFF00FF) //magenta`. |
| enabled      * | Locally sets whether or not to `update()`, `render()`, and gesture handle this entity.  Default: `true`. |
| globalEnabled  | Read-only.  Whether this and all parent entities are enabled or not. |
| globalPosition | Read-only.  Global X,Y position. |
| globalRotation | Read-only.  Global rotation in radians. |
| globalScale    | Read-only.  Global X,Y scaling. |
| globalZ        | Read-only.  Global Z-order render position. |
| isHud          | Sets whether this entity is a HUD object or not (ignores `Camera.offset`).  Default: `false`. |
| parent       * | Sets a parent entity to this entity.  Default: `null`.|
| position     * | Local X,Y position.  Default: `Vector2.zero()`. |
| rotation     * | Local rotation in radians.  Default: `0.0`. |
| rotationDeg  * | Local rotation in degrees.  Default: `0.0`. |
| scale        * | Local X,Y scaling.  Hint: use negative values to flip.  Default: `Vector2(1.0, 1.0)`. |
| zOrder       * | Local Z-order render position.  Smaller numbers are closer to the camera.  Default: `0`. |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| addChild    | Adds a child entity.  Set `adjustTransform: true` if the child's transform is global and you need to adjust it to the parent's. |
| destroy     | Marks the entity for destruction at the end of the tick. |
| getChildren | Returns a list of child entities. |
| render      | Called by the main update loop.  Override to use. |
| removeChild | Adds a child entity.  Set `adjustTransform: true` if you want to adjust the child's local transform to be global. |
| update      | Called by the main render loop.  Transforms this entity on the main canvas.  All overrides should call `super.render()` first. |
