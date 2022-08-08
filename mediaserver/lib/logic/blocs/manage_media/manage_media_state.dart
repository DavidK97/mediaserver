part of 'manage_media_bloc.dart';

abstract class ManageMediaState extends Equatable {}

class ManageMediaInitial extends ManageMediaState {
  @override
  List<Object?> get props => [];
}

class UpdatingMedia extends ManageMediaState {
  @override
  List<Object?> get props => [];
}

class MediaUpdated extends ManageMediaState {
  final Response response;

  MediaUpdated(this.response);

  @override
  List<Object?> get props => [response];
}
