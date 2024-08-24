import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
// import 'package:client/core/utils.dart';
import 'package:client/features/home/repositories/home_repo.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required String songName,
    required String artist,
    // required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    // Await the future result
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      songName: songName,
      artist: artist,
      // hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    // Handle the Either result
    res.match(
      (failure) {
        print('Error: ${failure.message}');
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (data) {
        state = AsyncValue.data(data);
      },
    );

    print(state);
    _favSongSuccess(bool isFavorite, String songId) {}
  }
}
