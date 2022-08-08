part of 'manage_media_bloc.dart';

abstract class ManageMediaEvent extends Equatable {}

class RemoveMedia extends ManageMediaEvent {
  final int id;

  RemoveMedia(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateMedia extends ManageMediaEvent {
  final Media newMedia;

  UpdateMedia(this.newMedia);

  @override
  List<Object?> get props => [newMedia];
}

class AddTagToMedia extends ManageMediaEvent {
  final int id;
  final String tag;

  AddTagToMedia(this.id, this.tag);

  @override
  List<Object?> get props => [id, tag];
}

class RemoveTagFromMedia extends ManageMediaEvent {
  final int id;
  final String tag;

  RemoveTagFromMedia(this.id, this.tag);

  @override
  List<Object?> get props => [id, tag];
}

class AddMediaToAlbum extends ManageMediaEvent {
  final int id;
  final String album;

  AddMediaToAlbum(this.id, this.album);

  @override
  List<Object?> get props => [id, album];
}

class RemoveMediaFromAlbum extends ManageMediaEvent {
  final int id;
  final String album;

  RemoveMediaFromAlbum(this.id, this.album);

  @override
  List<Object?> get props => [id, album];
}
