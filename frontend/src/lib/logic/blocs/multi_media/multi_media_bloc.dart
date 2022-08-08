import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/media.dart';
import '../../../data/models/response.dart';
import '../../../data/models/search.dart';
import '../../../data/repositories/media_repository.dart';

part 'multi_media_event.dart';
part 'multi_media_state.dart';

class MultiMediaBloc extends Bloc<MultiMediaEvent, MultiMediaState> {
  final MediaRepository repository;
  StreamSubscription<List<Media>>? mediaIdStream;

  MultiMediaBloc(this.repository) : super(MultiMediaInitial()) {
    on<SynchronizeMedia>((event, emit) {
      repository.synchronizeMedia().then((value) {
        add(FetchMediaIds());
      });
    });
    on<FetchMediaIds>((event, emit) {
      emit(MediaIdsLoadingState());
      if (mediaIdStream != null) mediaIdStream!.cancel();

      mediaIdStream = repository.fetchMediaIds().listen((event) {
        add(MediaIdsChanged(event));
      });
    });
    on<MediaIdsChanged>(((event, emit) {
      emit(MediaIdsLoadedState(event.media));
    }));
    on<SearchMedia>((event, emit) {
      emit(MediaIdsLoadingState());
      if (mediaIdStream != null) mediaIdStream!.cancel();

      mediaIdStream = repository.searchMedia(event.search).listen((event) {
        add(MediaIdsChanged(event));
      });
    });
  }
}
