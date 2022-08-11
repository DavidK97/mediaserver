import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediaserver/data/data.dart';

part 'manage_media_event.dart';
part 'manage_media_state.dart';

class ManageMediaBloc extends Bloc<ManageMediaEvent, ManageMediaState> {
  final MediaRepository mediaRepository;
  final AlbumRepository albumRepository;
  final CreatorRepository creatorRepository;

  ManageMediaBloc({
    required this.mediaRepository,
    required this.albumRepository,
    required this.creatorRepository,
  }) : super(ManageMediaInitial()) {
    on<RemoveMedia>((event, emit) async {
      emit(UpdatingMedia());
      Response r = await mediaRepository.removeMedia(event.id);
      emit(MediaUpdated(r));
    });
    on<UpdateMedia>((event, emit) async {
      emit(UpdatingMedia());
      Response r = await mediaRepository.updateMedia(event.newMedia);
      emit(MediaUpdated(r));
    });
    on<AddTagToMedia>((event, emit) async {
      emit(UpdatingMedia());
      Response r = await mediaRepository.addTagToMedia(event.id, event.tag);
      emit(MediaUpdated(r));
    });
    on<RemoveTagFromMedia>((event, emit) async {
      emit(UpdatingMedia());
      Response r =
          await mediaRepository.removeTagFromMedia(event.id, event.tag);
      emit(MediaUpdated(r));
    });
    on<AddMediaToAlbum>((event, emit) async {
      emit(UpdatingMedia());
      Response r = await albumRepository.addMediaToAlbum(event.id, event.album);
      emit(MediaUpdated(r));
    });
    on<RemoveMediaFromAlbum>((event, emit) async {
      emit(UpdatingMedia());
      Response r =
          await albumRepository.removeMediaFromAlbum(event.id, event.album);
      emit(MediaUpdated(r));
    });
    on<AddCreatorToMedia>((event, emit) async {
      emit(UpdatingMedia());
      Response r =
          await creatorRepository.addCreatorToMedia(event.id, event.creator);
      emit(MediaUpdated(r));
    });
    on<RemoveCreatorFromMedia>((event, emit) async {
      emit(UpdatingMedia());
      Response r = await creatorRepository.removeCreatorFromMedia(
          event.id, event.creator);
      emit(MediaUpdated(r));
    });
  }
}
