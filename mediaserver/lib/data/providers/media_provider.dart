import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../data.dart';

class MediaProvider {
  List<Media> mediaIdsCache = List.empty();
  List<Media> mediaCache = List.empty(growable: true);

  Stream<List<Media>> fetchMediaIds() async* {
    try {
      if (mediaIdsCache.isNotEmpty) yield mediaIdsCache;

      final response = await http.get(Uri.parse(MSUrls.media));
      List<dynamic> json = jsonDecode(response.body);

      List<Media> media = List.empty(growable: true);
      for (dynamic item in json) {
        media.add(Media.fromJson(item));
      }
      if (!listEquals(mediaIdsCache, media)) {
        yield media;
        mediaIdsCache = media;
      }
    } catch (error) {
      yield List.empty();
    }
  }

  Stream<Media> fetchMedia(int id) async* {
    try {
      if (mediaCache.isNotEmpty &&
          mediaCache.where((element) => element.id == id).isNotEmpty) {
        yield mediaCache.where((element) => element.id == id).first;
      }
      final response = await http.post(Uri.parse(MSUrls.media),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id).toJson());
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Media newMedia = Media.fromJson(json);
      if (mediaCache.where((element) => element.equals(newMedia)).isEmpty) {
        if (mediaCache
            .where((element) => element.id == newMedia.id)
            .isNotEmpty) {
          mediaCache.removeWhere((element) => element.id == newMedia.id);
        }

        yield newMedia;
        mediaCache.add(newMedia);
      }
    } catch (error) {
      yield Media.empty();
    }
  }

  Future<List<Media>> preLoadMedia(List<int> ids) async {
    try {
      List<Media> preloaded = List.empty(growable: true);

      for (int id in ids) {
        if (mediaCache.isNotEmpty &&
            mediaCache.where((element) => element.id == id).isNotEmpty) {
          preloaded.add(mediaCache.where((element) => element.id == id).first);
        }
        final response = await http.post(Uri.parse(MSUrls.media),
            headers: MSConstants.defaultJsonRequestHeader,
            body: Request(id: id).toJson());
        final Map<String, dynamic> json = jsonDecode(response.body);
        final Media newMedia = Media.fromJson(json);
        if (mediaCache.where((element) => element.equals(newMedia)).isEmpty) {
          if (mediaCache
              .where((element) => element.id == newMedia.id)
              .isNotEmpty) {
            mediaCache.removeWhere((element) => element.id == newMedia.id);
            preloaded.removeWhere((element) => element.id == newMedia.id);
          }

          preloaded.add(newMedia);
          mediaCache.add(newMedia);
        }
      }
      return preloaded;
    } catch (error) {
      return List<Media>.empty();
    }
  }

  Future<Response> removeMedia(int id) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id).toJson());
      if (response.statusCode == 200) {
        mediaCache.removeWhere((element) => element.id == id);
        mediaIdsCache.removeWhere((element) => element.id == id);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> updateMedia(Media media) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.updateMedia),
          headers: MSConstants.defaultJsonRequestHeader, body: media.toJson());
      if (response.statusCode == 200) {
        mediaCache.removeWhere((element) => element.id == media.id);
        mediaCache.add(media);
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> addTagToMedia(int id, String tag) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.addTagToMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id, name: tag).toJson());
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }

  Future<Response> removeTagFromMedia(int id, String tag) async {
    try {
      final response = await http.post(Uri.parse(MSUrls.removeTagFromMedia),
          headers: MSConstants.defaultJsonRequestHeader,
          body: Request(id: id, name: tag).toJson());
      if (StatusCodes.requestOK.contains(response.statusCode)) {
        return Response(success: true);
      }
      return Response(success: false);
    } catch (error) {
      return Response(success: false);
    }
  }
}
