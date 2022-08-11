import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../data.dart';

class CreatorProvider {
  List<String> creatorCache = List.empty();
  Map<String, List<int>> mediaOfCreatorCache = {};

  Stream<List<String>> fetchCreators() async* {
    try {
      if (creatorCache.isNotEmpty) yield creatorCache;
      final response = await http.get(Uri.parse(MSUrls.allCreators));
      final List<String> json = List<String>.from(jsonDecode(response.body));
      if (creatorCache.isEmpty || !listEquals(creatorCache, json)) {
        yield json;
        creatorCache = json;
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Stream<List<int>> fetchMediaOfCreator(String name) async* {
    try {
      if (mediaOfCreatorCache.containsKey(name)) {
        yield mediaOfCreatorCache[name]!;
      }
      final Search search = Search();
      search.creators.add(name);
      final response = await http.post(Uri.parse(MSUrls.searchMedia),
          headers: MSConstants.defaultJsonRequestHeader, body: search.toJson());
      final List<int> json = jsonDecode(response.body);
      if (mediaOfCreatorCache.containsKey(name) &&
          !listEquals(mediaOfCreatorCache[name]!, json)) {
        yield json;
        mediaOfCreatorCache.remove(name);
        mediaOfCreatorCache.putIfAbsent(name, () => json);
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Future<Response> addCreator(String name) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.addCreator),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name).toJson());
      if (response.statusCode == 200) {
        creatorCache.add(name);
        mediaOfCreatorCache.putIfAbsent(name, () => List.empty(growable: true));
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> removeCreator(String name) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeCreator),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name).toJson());
      if (response.statusCode == 200) {
        creatorCache.remove(name);
        mediaOfCreatorCache.remove(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> updateCreator(String name, String oldName) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.updateCreator),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name, oldName: oldName));
      if (response.statusCode == 200) {
        mediaOfCreatorCache.update(oldName, (value) {
          mediaOfCreatorCache.remove(oldName);
          mediaOfCreatorCache.putIfAbsent(name, () => value);
          return value;
        });
        creatorCache.remove(oldName);
        creatorCache.add(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> addCreatorToMedia(int id, String creator) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.addCreatorToMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id, name: creator).toJson());
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> removeCreatorFromMedia(int id, String creator) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeCreatorFromMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id, name: creator).toJson());
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }
}
