part of 'multi_media_bloc.dart';

abstract class MultiMediaEvent extends Equatable {}

class FetchMediaIds extends MultiMediaEvent {
  @override
  List<Object?> get props => [];
}

class SearchMedia extends MultiMediaEvent {
  final Search search;

  SearchMedia(this.search);

  @override
  List<Object?> get props => [search];
}

class SynchronizeMedia extends MultiMediaEvent {
  @override
  List<Object?> get props => [];
}

class MediaIdsChanged extends MultiMediaEvent {
  final List<Media> media;

  MediaIdsChanged(this.media);

  @override
  List<Object?> get props => [media];
}
