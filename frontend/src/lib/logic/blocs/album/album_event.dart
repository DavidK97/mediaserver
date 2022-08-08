part of 'album_bloc.dart';

abstract class AlbumEvent extends Equatable {}

class FetchAlbums extends AlbumEvent {
  @override
  List<Object?> get props => [];
}

class AlbumsChanged extends AlbumEvent {
  final List<String> albums;

  AlbumsChanged(this.albums);

  @override
  List<Object?> get props => [albums];
}

class FetchAlbumInfos extends AlbumEvent {
  @override
  List<Object?> get props => [];
}

class AlbumInfosChanged extends AlbumEvent {
  final List<AlbumInfo> albumInfos;

  AlbumInfosChanged(this.albumInfos);

  @override
  List<Object?> get props => [albumInfos];
}

class AddAlbum extends AlbumEvent {
  final String album;

  AddAlbum(this.album);

  @override
  List<Object?> get props => [album];
}
