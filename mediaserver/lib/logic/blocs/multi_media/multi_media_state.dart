part of 'multi_media_bloc.dart';

abstract class MultiMediaState extends Equatable {}

class MultiMediaInitial extends MultiMediaState {
  @override
  List<Object?> get props => [];
}

class SynchronizingMediaState extends MultiMediaInitial {
  @override
  List<Object?> get props => [];
}

class SynchronizedMediaState extends MultiMediaInitial {
  final Response response;

  SynchronizedMediaState(this.response);

  @override
  List<Object?> get props => [response];
}

class MediaIdsLoadingState extends MultiMediaState {
  @override
  List<Object?> get props => [];
}

class MediaIdsLoadedState extends MultiMediaState {
  final List<Media> media;

  MediaIdsLoadedState(this.media);

  @override
  List<Object?> get props => [media];
}
