# General Audio

For an overview of how to setup your assets, see the [getting started guide](/README.md#asset-files).

Tested audio file types: MP3, OGG, and WAV.

Pogo currently uses the [audioplayers](https://github.com/luanpotter/audioplayers) library.

## Usage

See the [AudioCache reference](/doc/caches/audio_cache.md) for a quick overview of what follows.

To play audio files:

```dart
    Assets.audioCache.play('explosion.mp3');
    Assets.audioCache.playLongAudio('music.mp3');
```

You can add the `volume` parameter for volume control.  For example, for half volume: 

```dart
    Assets.audioCache.play('explosion.mp3', volume: 0.5);
```

If you prefer you play audio from another cache instead of the central static cache:

```dart
    AudioCache audio = AudioCache();

    audio.play('explosion.mp3');
    audio.playLongAudio('music.mp3');
```

To play indefinitely, use one of the `loop` functions:

```dart
    Assets.audioCache.loop('music.mp3');
    Assets.audioCache.loopLongAudio('music.mp3');
```

Alternatively, you can use the [`Bgm` class (via `Assets.bgm`)](bgm.md) to play looping background music tracks. The `Bgm` class lets Flame manage the auto pausing and resuming of background music tracks when pausing/resuming the game/app.

The difference between the `play/loop` and `playLongAudio/loopLongAudio` is that `play/loop` makes uses of optimized features that allow sounds to be looped without gaps between their iterations, and almost no drop on the game frame rate will happen. You should whenever possible, prefer these methods. `playLongAudio/loopLongAudio` allows for audios of any length to be played, but they do create frame rate drop, and the looped audio will experience a small gap between iterations.

Both the `play` and `loop` methods return an [`AudioPlayer`](https://pub.dev/documentation/audioplayers/latest/audioplayers/AudioPlayer-class.html) instance that allows you to stop, pause, and configure other specifications.

There is a lot of logging.  This is reminiscent of the original AudioPlayer plugin.  Useful while debugging... but afterwards you can disable it with:

```dart
    Assets.audioCache.disableLog();
```

### Caching

Audio files need to be loaded into memory before playback.  Therefore, the first time you play a file you might get a delay if it is not loaded yet.  To pre-load an audio files to reduce lag:

```dart
    Assets.audioCache.load('explosion.mp3');
```

To cache multiple files from a List of filenames:

```dart
    Assets.audioCache.loadAll(['explosion.mp3', 'music.mp3'])
```

Both load methods return a `Future` for the `File`s loaded.

The `remove()` method removes a single file from the cache:

```dart
    Assets.audioCache.remove('explosion.mp3');
```

The `clear()` method clears the whole cache.  This might be useful if, for instance, your game has multiple levels and each has a different soundtrack.

```dart
    Assets.audioCache.clear();
```
