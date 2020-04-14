# Text

Classes and components for text.


# TextConfig Class

The `TextConfig` class contains all typographical information required to render texts (basically, a style preset, but the term "TextStyle" is already taken by Flutter).  It is used by both `TextComponent` and `MessageBoxComponent`.

## Properties

| | |
| :-- | :-- |
| color         * | Final.  Font Color.  Default: `Color(0xFF000000)` black. |
| fontFamily    * | Final.  Name of a commonly-available font, like Arial (default), or [a custom font added to your pubspec](https://flutter.io/custom-fonts/). |
| fontSize      * | Final.  Font size, in points.  Default: `24.0`. |
| textAlign     * | Final.  The TextAlign to be used when creating the TextPainter.  It is recommended to leave this at the default value and use a [Pivot](/doc/pivot.md) to align otherwise.  Default: `TextAlign.left`. |
| textDirection * | Final.  The direction to render this text (left to right or right to left).  Default: `TextDirection.ltr`. |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| getTextPainter | Returns a TextPainter for the given string. |
| copyWith       | Returns a copy of this text config but with the given fields replaced with the new values. |

----

Example usage:

```dart
const TextConfig config = TextConfig(fontSize: 48.0, fontFamily: 'Awesome Font', pivot: Pivot.rightBottom);
```


# TextComponent class

The `TextComponent` class is a component for use in building a [`GameEntity`](/doc/game_entity.md).  It draws a single line of text.

## Properties

| | |
| :-- | :-- |
| height       | Read-only.  Height of the TextPainter for the text. |
| pivot      * | [Pivot](/doc/pivot.md) point for rotation and anchor point for placement.  Default: `System.defaultPivot` which defaults to `Pivot.center`. |
| size         | Read-only.  Width and height of the TextPainter for the text. |
| text       * | String to draw. |
| textConfig * | TextConfig to use for styling the text.  Default: `const TextConfig()`. |
| width        | Read-only.  Width of the TextPainter for the text. |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| render | Draws the text, translated by the set Pivot, with the set TextConfig.  To execute, call from a `GameEnity.update()`. |

----

See the [**text** example app](/doc/examples/text/lib/main.dart)

See the [**timer** example app](/doc/examples/timer/lib/main.dart)


# MessageBoxComponent class

The `MessageBoxComponent` class is a component for use in building a [`GameEntity`](/doc/game_entity.md).  It can draw multiple lines of text, creating line breaks according to the provided box width.  It can also animate the typing of characters like what is common for in-game dialog.

## Properties

| | |
| :-- | :-- |
| charDuration      * | Read-only.  Seconds to pause between display of each character.  Default: `0.0`, that is, instant display of all text. |
| currentHeight       | Read-only.  Current height of the animated message box (including padding). |
| currentWidth        | Read-only.  Current width of the animated message box (including padding). |
| elapsed             | Read-only.  Seconds since start of message box. |
| endOfMessagePause * | Read-only.  Seconds to pause after last character is displayed before setting the `isFinished` flag.  Default: `0.0`. |
| height              | Read-only.  Final calculated height of the message box (including padding). |
| isFinished          | Read-only.  Whether message typing and message pause have finished or not. |
| maxWidth          * | Read-only.  Maximum width to allow for each line.  Required. |
| padding           * | Read-only.  Padding to add to all sides.  Default: `0.0`. |
| pivot             * | [Pivot](/doc/pivot.md) point for rotation and anchor point for placement.  Default: `System.defaultPivot` which defaults to `Pivot.center`. |
| text              * | Read-only.  String to draw.  Required. |
| textConfig        * | Read-only.  TextConfig to use for styling the text.  Default: `const TextConfig()`. |
| totalCharDuration   | Read-only.  Total time it will take to display all characters, in seconds. |
| width               | Read-only.  Final calculated width of the message box (including padding). |

\* Also is a constructor parameter.

## Methods

| | |
| :-- | :-- |
| render         | Draws the text, translated by the set Pivot, with the set TextConfig.  To execute, call from a `GameEnity.update()`. |
| update         | Updates the animation state.  To execute, call from a `GameEnity.update()`. |
| drawBackground | Override to draw a background for the message box (currently limited to `currentWidth` and `currentHeight` it appears, for some unknown reason). |

----

See the [**text** example app](/doc/examples/text/lib/main.dart)
