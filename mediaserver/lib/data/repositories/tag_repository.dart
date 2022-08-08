import '../data.dart';

class TagRepository {
  final _provider = TagProvider();

  Stream<List<String>> fetchTags() async* {
    yield* _provider.fetchTags();
  }

  Future<Response> addTag(String name) async {
    return _provider.addTag(name);
  }

  Future<Response> removeTag(String name) async {
    return _provider.removeTag(name);
  }

  Future<Response> renameTag(String newName, String oldName) async {
    return _provider.updateTag(newName, oldName);
  }
}
