import '../data.dart';

class CreatorRepository {
  final _provider = CreatorProvider();

  Stream<List<String>> fetchCreators() async* {
    yield* _provider.fetchCreators();
  }

  Future<Response> addCreator(String name) async {
    return _provider.addCreator(name);
  }

  Future<Response> removeCreator(String name) async {
    return _provider.removeCreator(name);
  }

  Future<Response> renameCreator(String newName, String oldName) async {
    return _provider.updateCreator(newName, oldName);
  }

  Future<Response> addCreatorToMedia(int id, String creator) async {
    return _provider.addCreatorToMedia(id, creator);
  }

  Future<Response> removeCreatorFromMedia(int id, String creator) async {
    return _provider.removeCreatorFromMedia(id, creator);
  }
}
