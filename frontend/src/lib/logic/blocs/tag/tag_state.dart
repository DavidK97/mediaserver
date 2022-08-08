part of 'tag_bloc.dart';

abstract class TagState extends Equatable {}

class TagInitial extends TagState {
  @override
  List<Object?> get props => [];
}

class TagsLoading extends TagState {
  @override
  List<Object?> get props => [];
}

class TagsLoaded extends TagState {
  final List<String> tags;

  TagsLoaded(this.tags);

  @override
  List<Object?> get props => [tags];
}
