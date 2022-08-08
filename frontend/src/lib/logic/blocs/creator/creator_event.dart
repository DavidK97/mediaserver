part of 'creator_bloc.dart';

abstract class CreatorEvent extends Equatable {}

class FetchCreators extends CreatorEvent {
  @override
  List<Object?> get props => [];
}

class CreatorsChanged extends CreatorEvent {
  final List<String> creators;

  CreatorsChanged(this.creators);

  @override
  List<Object?> get props => [creators];
}

class AddCreator extends CreatorEvent {
  final String creator;

  AddCreator(this.creator);

  @override
  List<Object?> get props => [creator];
}

class RemoveCreator extends CreatorEvent {
  final String creator;

  RemoveCreator(this.creator);

  @override
  List<Object?> get props => [creator];
}
