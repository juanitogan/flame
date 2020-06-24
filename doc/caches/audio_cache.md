# AudioCache class

Handles [audio](/doc/audio/audio.md) caching and functions.  **Not finished evaluating this. Possible changes coming.**

## Methods

| | |
| :-- | :-- |
| clear         | Clears all data from the cache. |
| disableLog    | Disables audio logging. |
| load          | Loads a single file into the cache.  Returns a File Future.  Not for web. |
| loadAll       | Loads a List of files into the cache.  Returns a List<File> Future.  Not for web. |
| loop          | Continuous looping of the given file (takes an optional volume parameter).  Caches the file if not already cached.  Returns an AudioPlayer Future. |
| loopLongAudio | Continuous looping of the given file (takes an optional volume parameter).  This method supports long audio files.  Caches the file if not already cached.  NOTE: Long audio files on Android have an audio gap between loop iterations.  This happens due to limitations on Android's native media player features.  If you need a gapless loop, prefer the `loop()` method.  Returns an AudioPlayer Future. |
| play          | Plays a single run of the given file (takes an optional volume parameter).  Caches the file if not already cached.  Returns an AudioPlayer Future. |
| playLongAudio | Plays a single run of the given file (takes an optional volume parameter).  This method supports long audio files.  Caches the file if not already cached.  Returns an AudioPlayer Future. |
| remove        | Removes a single audio file, by filename, from the cache. |
| setSubPath    | Override the default subdirectory for audio files.  Must specify a path underneath `assets/` (or set to empty for `assets/` root).  Default: `audio/`. |

**Notes:**

* Caching audio does not work with web apps due to lack of web support for `path_provider.getTemporaryDirectory()` (which is used by the `audioplayers` plugin).  Trying to do so can break the web app, possibly without an error message (if there is a message it will reference `path_provider`).  You can, however, still use the `play()` function here to play audio in web apps -- but they still will not be cached.  I still hope to find a better audio solution and/or code around issues like this.

----

For an overview of how to setup your assets, see the [getting started guide](/README.md#asset-files).
