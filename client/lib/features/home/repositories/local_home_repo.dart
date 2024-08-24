import 'package:client/features/home/model/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_home_repo.g.dart';

@riverpod
LocalHomeRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return LocalHomeRepository();
}

class LocalHomeRepository {
  final Box box = Hive.box();
  void uploadSongs(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadsongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)));
    }
    return songs;
  }
}
