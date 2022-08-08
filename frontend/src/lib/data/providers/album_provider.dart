import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mediaserver/data/models/album_info.dart';

import '../../config/config.dart';
import '../data.dart';

class AlbumProvider {
  List<String> albumCache = List.empty();
  List<AlbumInfo> albumInfoCache = List.empty();
  Map<String, List<Media>> mediaOfAlbumCache = {};

  Stream<List<String>> fetchAlbums() async* {
    try {
      if (albumCache.isNotEmpty) yield albumCache;
      final response = await http.get(Uri.parse(MSUrls.allAlbums));
      final List<String> json = List<String>.from(jsonDecode(response.body));
      if (!listEquals(albumCache, json)) {
        yield json;
        albumCache = json;
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Stream<List<AlbumInfo>> fetchAlbumInfos() async* {
    try {
      if (albumCache.isNotEmpty) yield albumInfoCache;
      final response = await http.get(Uri.parse(MSUrls.allAlbumInfos));

      final List<dynamic> json = jsonDecode(response.body);
      final List<AlbumInfo> info = List.empty(growable: true);

      for (dynamic item in json) {
        info.add(AlbumInfo.fromJson(item));
      }

      if (!listEquals(albumInfoCache, info)) {
        yield info;
        albumInfoCache = info;
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Stream<List<Media>> fetchMediaOfAlbum(String name) async* {
    try {
      if (mediaOfAlbumCache.containsKey(name)) yield mediaOfAlbumCache[name]!;

      final Search search = Search();
      search.albums.add(name);
      final response = await http.post(Uri.parse(MSUrls.searchMedia),
          headers: MSConstants.defaultJsonRequestHeader, body: search.toJson());
      final List<dynamic> json = jsonDecode(response.body);
      final List<Media> media = List.empty(growable: true);

      for (dynamic item in json) {
        media.add(Media.fromJson(item));
      }

      if (!mediaOfAlbumCache.containsKey(name) ||
          !listEquals(mediaOfAlbumCache[name]!, media)) {
        yield media;
        mediaOfAlbumCache.remove(name);
        mediaOfAlbumCache.putIfAbsent(name, () => media);
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Future<Response> addAlbum(String name) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.addAlbum),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name).toJson());
      if (response.statusCode == 200) {
        albumCache.add(name);
        mediaOfAlbumCache.putIfAbsent(name, () => List.empty(growable: true));
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> removeAlbum(String name) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name).toJson());
      if (response.statusCode == 200) {
        albumCache.remove(name);
        mediaOfAlbumCache.remove(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> updateAlbum(String name, String oldName) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.updateMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(name: name, oldName: oldName));
      if (response.statusCode == 200) {
        mediaOfAlbumCache.update(oldName, (value) {
          mediaOfAlbumCache.remove(oldName);
          mediaOfAlbumCache.putIfAbsent(name, () => value);
          return value;
        });
        albumCache.remove(oldName);
        albumCache.add(name);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> addMediaToAlbum(int id, String album) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.addMediaToAlbum),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id, name: album).toJson());
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> removeMediaFromAlbum(int id, String album) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeMediaFromAlbum),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id, name: album).toJson());
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }
}
