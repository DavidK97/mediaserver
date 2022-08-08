import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediaserver/data/data.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository repository;
  StreamSubscription<Media>? mediaStream;

  MediaBloc(this.repository) : super(InitialMediaState()) {
    on<FetchMedia>((event, emit) {
      emit(MediaLoadingState());
      if (mediaStream != null) mediaStream!.cancel();

      mediaStream = repository.fetchMedia(event.id).listen((event) {
        add(MediaChanged(event));
      });
    });
    on<MediaChanged>(((event, emit) {
      emit(MediaLoadedState(event.media));
    }));
  }
}
