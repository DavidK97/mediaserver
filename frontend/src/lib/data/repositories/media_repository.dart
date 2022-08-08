import '../data.dart';

class MediaRepository {
  final _provider = MediaProvider();
  final _msProvider = MSProvider();

  Future<Response> synchronizeMedia() async {
    return _msProvider.synchronizeMedia();
  }

  Stream<List<Media>> fetchMediaIds() async* {
    yield* _provider.fetchMediaIds();
  }

  Stream<List<Media>> searchMedia(Search search) async* {
    yield* _msProvider.search(search);
  }

  Stream<Media> fetchMedia(int id) async* {
    yield* _provider.fetchMedia(id);
  }

  Future<Response> removeMedia(int id) async {
    return _provider.removeMedia(id);
  }

  Future<Response> updateMedia(Media media) async {
    return _provider.updateMedia(media);
  }

  Future<Response> addTagToMedia(int id, String tag) async {
    return _provider.addTagToMedia(id, tag);
  }

  Future<Response> removeTagFromMedia(int id, String tag) async {
    return _provider.removeTagFromMedia(id, tag);
  }
}
