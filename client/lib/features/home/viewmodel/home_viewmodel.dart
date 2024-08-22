import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_repo.dart';
import 'package:client/features/home/repositories/local_home_repo.dart';
import 'package:fpdart/fpdart.dart';
// import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(
        token: token,
      );
  final val = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
  return val;
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(
        token: token,
      );
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late LocalHomeRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
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
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (data) {
        state = AsyncValue.data(data);
      },
    );

    print(state);
  }

  Future<void> favSong({
    required String songId,
    // required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    // Await the future result
    final res = await _homeRepository.favSong(
      songId: songId,
      // hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    // Handle the Either result
    res.match(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (data) {
        state = AsyncValue.data(data);
      },
    );

    print(state);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadsongs();
  }
}
