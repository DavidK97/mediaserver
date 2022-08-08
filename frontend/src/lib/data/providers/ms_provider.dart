import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../data.dart';

class MSProvider {
  Map<Search, List<Media>> cachedSearch = {};

  Stream<List<Media>> search(Search search) async* {
    try {
      if (cachedSearch.containsKey(search)) {
        yield cachedSearch[search]!;
      }
      final response = await http.post(Uri.parse(MSUrls.searchMedia),
          headers: MSConstants.defaultJsonRequestHeader, body: search.toJson());

      if (StatusCodes.requestOK.contains(response.statusCode)) {
        final List<dynamic> json = jsonDecode(response.body);

        final List<Media> media = List.empty(growable: true);
        for (dynamic item in json) {
          media.add(Media.fromJson(item));
        }

        if (!cachedSearch.containsKey(search) ||
            !listEquals(cachedSearch[search]!, media)) {
          yield media;
          cachedSearch.remove(search);
          cachedSearch.putIfAbsent(search, () => media);
        }
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Future<Response> synchronizeMedia() async {
    try {
      final response = await http.get(Uri.parse(MSUrls.synchronize));
      final Map<String, String> json = jsonDecode(response.body);
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false, message: json['message']);
    } catch (error) {
      return Response(success: false);
    }
  }
}
