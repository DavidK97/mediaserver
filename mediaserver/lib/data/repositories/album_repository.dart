import 'package:mediaserver/data/models/album_info.dart';

import '../data.dart';

class AlbumRepository {
  final _provider = AlbumProvider();

  Stream<List<String>> fetchAlbums() async* {
    yield* _provider.fetchAlbums();
  }

  Stream<List<AlbumInfo>> fetchAlbumInfos() async* {
    yield* _provider.fetchAlbumInfos();
  }

  Stream<List<Media>> fetchMediaOfAlbum(String name) async* {
    yield* _provider.fetchMediaOfAlbum(name);
  }

  Future<Response> addAlbum(String name) async {
    return _provider.addAlbum(name);
  }

  Future<Response> removeAlbum(String name) async {
    return _provider.removeAlbum(name);
  }

  Future<Response> renameAlbum(String newName, String oldName) async {
    return _provider.updateAlbum(newName, oldName);
  }

  Future<Response> addMediaToAlbum(int id, String album) async {
    return _provider.addMediaToAlbum(id, album);
  }

  Future<Response> removeMediaFromAlbum(int id, String album) async {
    return _provider.removeMediaFromAlbum(id, album);
  }
}
