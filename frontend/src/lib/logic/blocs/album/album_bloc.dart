import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediaserver/data/models/album_info.dart';

import '../../../data/repositories/album_repository.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository repository;
  StreamSubscription<List<String>>? albumStream;
  StreamSubscription<List<AlbumInfo>>? albumInfoStream;

  AlbumBloc(this.repository) : super(AlbumInitial()) {
    on<FetchAlbums>((event, emit) {
      emit(AlbumsLoading());
      if (albumStream != null) albumStream!.cancel();

      albumStream = repository.fetchAlbums().listen((event) {
        add(AlbumsChanged(event));
      });
    });
    on<AlbumsChanged>(((event, emit) {
      emit(AlbumsLoaded(event.albums));
    }));
    on<FetchAlbumInfos>((event, emit) {
      emit(AlbumInfosLoading());
      if (albumInfoStream != null) albumInfoStream!.cancel();

      albumInfoStream = repository.fetchAlbumInfos().listen((event) {
        add(AlbumInfosChanged(event));
      });
    });
    on<AlbumInfosChanged>(((event, emit) {
      emit(AlbumInfosLoaded(event.albumInfos));
    }));
    on<AddAlbum>((event, emit) => repository
        .addAlbum(event.album)
        .then((value) => add(FetchAlbumInfos())));
  }
}
