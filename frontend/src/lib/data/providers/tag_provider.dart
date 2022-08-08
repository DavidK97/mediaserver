import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import '../data.dart';

class TagProvider {
  List<String> tagCache = List.empty(growable: true);

  Stream<List<String>> fetchTags() async* {
    try {
      if (tagCache.isNotEmpty) yield tagCache;

      final response = await http.get(Uri.parse(MSUrls.allTags));
      final List<String> json = List<String>.from(jsonDecode(response.body));
      if (!listEquals(tagCache, json)) {
        yield json;
        tagCache = json;
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Future<Response> addTag(String name) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.addTag),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name).toJson());
      if (response.statusCode == 200) {
        tagCache.add(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> removeTag(String name) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeTag),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name).toJson());
      if (response.statusCode == 200) {
        tagCache.remove(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> updateTag(String name, String oldName) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.updateTag),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name, oldName: oldName));
      if (response.statusCode == 200) {
        tagCache.remove(oldName);
        tagCache.add(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }
}
