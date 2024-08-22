import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/local_home_repo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late LocalHomeRepository _localHomeRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    _localHomeRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer();
    // Aproach 1:
    // await audioPlayer!.setUrl(song.song_url);
    // Approach 2:
    //create a audio source,let the audio player be created
    //we use this because we need a tag present in the AudioSource
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(
            'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQb2uhUtFn7E-sLe9YpnWHr2H8GrqyEkHSA914iromA3B95zuQP'),
      ),
    );
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        // state = state.copyWith();
      }
    });
    // audioPlayer.positionStream
    _localHomeRepository.uploadSongs(song);
    audioPlayer!.play();
    state = song;
    //   void seek(double val) {
    //   audioPlayer!.seek(
    //     Duration(
    //       milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
    //     ),
    //   );
    // }
  }

  void PlayAndPause() {
    if (isPlaying) {
      audioPlayer?.play();
    } else {
      audioPlayer?.pause();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith();
    //"UI REbuild to take place
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
