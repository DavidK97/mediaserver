part of 'media_bloc.dart';

abstract class MediaState extends Equatable {}

class InitialMediaState extends MediaState {
  @override
  List<Object?> get props => [];
}

class MediaLoadingState extends MediaState {
  @override
  List<Object?> get props => [];
}

class MediaLoadedState extends MediaState {
  final Media media;

  MediaLoadedState(this.media);

  @override
  List<Object?> get props => [media];
}
