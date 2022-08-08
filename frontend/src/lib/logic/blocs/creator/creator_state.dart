part of 'creator_bloc.dart';

abstract class CreatorState extends Equatable {}

class CreatorInitial extends CreatorState {
  @override
  List<Object?> get props => [];
}

class CreatorsLoading extends CreatorState {
  @override
  List<Object?> get props => [];
}

class CreatorsLoaded extends CreatorState {
  final List<String> creators;

  CreatorsLoaded(this.creators);

  @override
  List<Object?> get props => [creators];
}
