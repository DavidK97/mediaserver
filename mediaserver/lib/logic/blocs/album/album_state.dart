part of 'album_bloc.dart';

abstract class AlbumState extends Equatable {}

class AlbumInitial extends AlbumState {
  @override
  List<Object?> get props => [];
}

class AlbumsLoading extends AlbumState {
  @override
  List<Object?> get props => [];
}

class AlbumsLoaded extends AlbumState {
  final List<String> albums;

  AlbumsLoaded(this.albums);

  @override
  List<Object?> get props => [albums];
}

class AlbumInfosLoading extends AlbumState {
  @override
  List<Object?> get props => [];
}

class AlbumInfosLoaded extends AlbumState {
  final List<AlbumInfo> albumInfos;

  AlbumInfosLoaded(this.albumInfos);

  @override
  List<Object?> get props => [albumInfos];
}
