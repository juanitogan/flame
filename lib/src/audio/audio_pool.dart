import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:synchronized/synchronized.dart';

typedef void Stoppable();

//TODO evaluate this more - seems useful, but mixing also seems fine without this

/// An AudioPool is a provider of AudioPlayers that leaves them pre-loaded to minimize delays.
///
/// All AudioPlayers loaded are for the same given source [filename].
/// If you want to pool multiple sounds use multiple [AudioPool]s.
/// Use this class for repetitive and overlapping sounds, like the gun sound in a shooter game.
class AudioPool {
  AudioCache cache;
  Map<String, AudioPlayer> currentPlayers = {};
  List<AudioPlayer> availablePlayers = [];

  String filename;
  bool loop;
  int minPlayers, maxPlayers;

  final Lock _lock = Lock();

  AudioPool(
      this.filename,
      {
        this.loop = false,
        this.minPlayers = 1,
        this.maxPlayers = 1,
        String subPath = 'audio/'
      }
  ) {
    cache = AudioCache(prefix: subPath);
    //TODO assert min>=1 and max>=min
  }

  Future init() async {
    for (int i = 0; i < minPlayers; i++) {
      availablePlayers.add(await _createNewAudioPlayer());
    }
  }

  Future<Stoppable> start({double volume = 1.0}) async {
    return _lock.synchronized(() async {
      if (availablePlayers.isEmpty) {
        availablePlayers.add(await _createNewAudioPlayer());
      }
      final AudioPlayer player = availablePlayers.removeAt(0);
      currentPlayers[player.playerId] = player;
      await player.setVolume(volume);
      await player.resume();

      StreamSubscription<void> subscription;

      final Stoppable stop = () {
        _lock.synchronized(() async {
          final AudioPlayer p = currentPlayers.remove(player.playerId);
          subscription?.cancel();
          await p.stop();
          if (availablePlayers.length >= maxPlayers) {
            await p.release();
          } else {
            availablePlayers.add(p);
          }
        });
      };

      subscription = player.onPlayerCompletion.listen((_) {
        if (loop) {
          player.resume();
        } else {
          stop();
        }
      });

      return stop;
    });
  }

  Future<AudioPlayer> _createNewAudioPlayer() async {
    final AudioPlayer player = AudioPlayer();
    final String url = await cache.getAbsoluteUrl(filename); // web-friendly load/pathfinder
    await player.setUrl(url);
    await player.setReleaseMode(ReleaseMode.STOP);
    return player;
  }
}
