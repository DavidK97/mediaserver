import 'package:mediaserver/data/data.dart';

class MSRepository {
  final MSProvider _provider = MSProvider();

  Stream<List<Media>> search(Search search) async* {
    yield* _provider.search(search);
  }
}
