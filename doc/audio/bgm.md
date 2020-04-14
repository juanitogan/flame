# Looping Background Music

**//TODO haven't looked at this -- will rewrite after I do**

The `Bgm` class with the management of looping background music tracks with regards to application (or game) lifecycle state changes.

When the application is paused, terminated, or sent to background, `Bgm` will automatically pause the currently playing music track. Similarly, when the application is resumed, `Bgm` will resume the background music. Manual pause and resume is also supported.

For this class to function properly, the observer must be registered by calling the following:

```dart
Assets.bgm.initialize();
```

**IMPORTANT Note:** The `initialize` function must be called at a point in time where an instance of the `WidgetsBinding` class already exists. It's safe to assume that this case is true at any point after `runApp` has been called at least once.

In cases where you're done with background music but still want to keep the application/game running, use the `dispose` function to remove the observer.

```dart
Assets.bgm.dispose();
```

To play a looping background music track, run:

```dart
Assets.bgm.play('adventure-track.mp3');
```

Or, if you prefer:

```dart
Bgm audio = Bgm();
audio.play('adventure-track.mp3');
```

**Note:** The `Bgm` class will always use the static instance of `AudioCache` in `Assets.audioCache` for storing cached music files.

You must have an appropriate folder structure and add the files to the `pubspec.yaml` file, as explained in [audio documentation](audio.md).

## Caching music files

The following functions can be used to preload (and unload) music files into the cache. These functions are just aliases for the ones in `Assets.audioCache` with the same names.

Again, please refer to the [audio documentation](audio.md) if you need more info.

```dart
Assets.audioCache.load('adventure-track.mp3');
Assets.audioCache.loadAll([
  'menu.mp3',
  'dungeon.mp3',
]);
Assets.audioCache.clear('adventure-track.mp3');
Assets.bgm.clearAll();
```

## Methods

### Play

The `play` function takes in a `String` that should be a filename that points to the location of the music file to be played (following the audio folder structure requirements).

You can pass an additional optional `double` parameter, the `volume` (defaults to `1.0`).

Examples:

```dart
Assets.bgm.play('bgm/boss-fight/level-382.mp3');
```

```dart
Assets.bgm.play('bgm/world-map.mp3', volume: .25);
```

### Stop

To stop a currently playing background music track, just call `stop`.

```dart
Assets.bgm.stop();
```

### Pause and Resume

To manually pause and resume background music you can use the `pause` and `resume` functions.

`Assets.bgm` automatically handles pausing and resuming the currently playing background music track. Manually `pausing` the function prevents the app/game from auto-resuming when focus is given back to the app/game.

```dart
Assets.bgm.pause();
```

```dart
Assets.bgm.resume();
```
