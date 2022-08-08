part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {}

class FetchTags extends TagEvent {
  @override
  List<Object?> get props => [];
}

class TagsChanged extends TagEvent {
  final List<String> tags;

  TagsChanged(this.tags);

  @override
  List<Object?> get props => [tags];
}

class AddTag extends TagEvent {
  final String tag;

  AddTag(this.tag);

  @override
  List<Object?> get props => [tag];
}

class RemoveTag extends TagEvent {
  final String tag;

  RemoveTag(this.tag);

  @override
  List<Object?> get props => [tag];
}
