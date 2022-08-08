import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository repository;
  StreamSubscription<List<String>>? tagStream;

  TagBloc(this.repository) : super(TagInitial()) {
    on<FetchTags>((event, emit) {
      emit(TagsLoading());
      if (tagStream != null) tagStream!.cancel();

      tagStream = repository.fetchTags().listen((event) {
        add(TagsChanged(event));
      });
    });
    on<TagsChanged>(((event, emit) {
      emit(TagsLoaded(event.tags));
    }));
    on<AddTag>((event, emit) =>
        repository.addTag(event.tag).then((value) => add(FetchTags())));
    on<RemoveTag>((event, emit) =>
        repository.removeTag(event.tag).then((value) => add(FetchTags())));
  }
}
