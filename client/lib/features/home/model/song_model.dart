// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SongModel {
  final String id;
  final String song_name;
  final String song_url;
  final String artist;
  SongModel({
    required this.id,
    required this.song_name,
    required this.song_url,
    required this.artist,
  });

  SongModel copyWith({
    String? id,
    String? song_name,
    String? song_url,
    String? artist,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      song_url: song_url ?? this.song_url,
      artist: artist ?? this.artist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': song_name,
      'song_url': song_url,
      'artist': artist,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      song_name: map['song_name'] ?? '',
      song_url: map['song_url'] ?? '',
      artist: map['artist'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, song_name: $song_name, song_url: $song_url, artist: $artist)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.song_name == song_name &&
        other.song_url == song_url &&
        other.artist == artist;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        song_name.hashCode ^
        song_url.hashCode ^
        artist.hashCode;
  }
}
