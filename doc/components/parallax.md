# ParallaxComponent class

**//TODO: the old version of this is working but this is slated to be rebuilt; will rewrite doc after that**

**This code may be outdated, see the example app**

See the [**parallax** example app](/doc/examples/parallax).

----

This Component can be used to render pretty backgrounds by drawing several transparent images on top of each other, each dislocated by a tiny amount.

The rationale is that when you look at the horizon and moving, closer objects seem to move faster than distant ones.

This component simulates this effect, making a more realistic background with a feeling of depth.

Create it like this:

```dart
final images = [
ParallaxImage("mountains.jpg"),
ParallaxImage("forest.jpg"),
ParallaxImage("city.jpg"),
];
this.bg = ParallaxComponent(images);
```

This creates a static background, if you want it to move you have to set the named optional parameters `baseSpeed` and `layerDelta`. For example if you want to move your background images along the X-axis and have the images further away you would do the following:

```dart
this.bg = ParallaxComponent(images, baseSpeed: Offset(50, 0), layerDelta: Offset(20, 0));
```
You can set the baseSpeed and layerDelta at any time, for example if your character jumps or your game speeds up.

```dart
this.bg.baseSpeed = Offset(100, 0);
this.bg.layerDelta = Offset(40, 0);
```

By default the images are aligned to the bottom left, repeated along the X-axis and scaled proportionally so that the image covers the height of the screen. If you want to change this behaviour, for example if you are not making a side scrolling game, you can set the `repeat`, `alignment` and `fill` parameters for each ParallaxImage.

Advanced example:
```dart
final images = [
ParallaxImage("stars.jpg", repeat: ImageRepeat.repeat, alignment: Alignment.center, fill: LayerFill.width),
ParallaxImage("planets.jpg", repeat: ImageRepeat.repeatY, alignment: Alignment.bottomLeft, fill: LayerFill.none),
ParallaxImage("dust.jpg", repeat: ImageRepeat.repeatX, alignment: Alignment.topRight, fill: LayerFill.height),
];
this.bg = ParallaxComponent(images, baseSpeed: Offset(50, 0), layerDelta: Offset(20, 0));
```

* The stars image in this example will be repeatedly drawn in both axis, align in the center and be scaled to fill the screen width.
* The planets image will be repeated in Y-axis, aligned to the bottom left of the screen and not be scaled.
* The dust image will be repeated in X-axis, aligned to the top right and scaled to fill the screen height.

Once you are done with setting the parameters to your needs, render the ParallaxComponent as any other component.

Like the AnimationComponent, even if your parallax is static, you must call update on this component, so it runs its animation.
Also, don't forget to add you images to the `pubspec.yaml` file as assets or they wont be found.

See the [**parallax** example app](/doc/examples/parallax).
