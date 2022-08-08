import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/creator_repository.dart';

part 'creator_event.dart';
part 'creator_state.dart';

class CreatorBloc extends Bloc<CreatorEvent, CreatorState> {
  final CreatorRepository repository;
  StreamSubscription<List<String>>? creatorStream;

  CreatorBloc(this.repository) : super(CreatorInitial()) {
    on<FetchCreators>((event, emit) {
      emit(CreatorsLoading());
      if (creatorStream != null) creatorStream!.cancel();

      creatorStream = repository.fetchCreators().listen((event) {
        add(CreatorsChanged(event));
      });
    });
    on<CreatorsChanged>(((event, emit) {
      emit(CreatorsLoaded(event.creators));
    }));
    on<AddCreator>((event, emit) => repository
        .addCreator(event.creator)
        .then((value) => add(FetchCreators())));
    on<RemoveCreator>((event, emit) => repository
        .removeCreator(event.creator)
        .then((value) => add(FetchCreators())));
  }
}
