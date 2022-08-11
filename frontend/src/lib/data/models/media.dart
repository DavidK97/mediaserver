import 'dart:convert';

import 'package:flutter/foundation.dart';

class Media {
  int id;
  String name;
  String thumbnail;
  String type;
  bool favorite;
  List<String> creators;
  List<String> tags;
  List<String> albums;

  Media(
      {required this.id,
      required this.name,
      required this.thumbnail,
      required this.type,
      required this.creators,
      required this.favorite,
      required this.tags,
      required this.albums});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json["id"],
      name: json["name"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      type: json["type"],
      favorite: json["favorite"] ?? false,
      creators: ((json["creators"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tags: ((json["tags"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      albums: ((json["albums"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      "id": id,
      "name": name,
      "thumbnail": thumbnail,
      "type": type,
      "favorite": favorite
    });
  }

  factory Media.empty() {
    return Media(
      id: -1,
      name: "",
      thumbnail: "",
      type: "",
      favorite: false,
      creators: [],
      tags: [],
      albums: [],
    );
  }

  equals(Media newMedia) {
    return (id == newMedia.id &&
        name == newMedia.name &&
        thumbnail == newMedia.thumbnail &&
        type == newMedia.type &&
        favorite == newMedia.favorite &&
        listEquals(creators, newMedia.creators) &&
        listEquals(tags, newMedia.tags) &&
        listEquals(albums, newMedia.albums));
  }
}
