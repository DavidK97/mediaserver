part of 'media_bloc.dart';

abstract class MediaEvent extends Equatable {}

class FetchMedia extends MediaEvent {
  final int id;

  FetchMedia(this.id);

  @override
  List<Object?> get props => [id];
}

class MediaChanged extends MediaEvent {
  final Media media;

  MediaChanged(this.media);

  @override
  List<Object?> get props => [media];
}
