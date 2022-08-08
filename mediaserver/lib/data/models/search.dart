import 'dart:convert';

class Search {
  List<String> albums = List.empty(growable: true);
  List<String> creators = List.empty(growable: true);
  bool favorite = false;
  List<String> tags = List.empty(growable: true);

  Search();

  String toJson() {
    return jsonEncode(<String, dynamic>{
      "albums": albums,
      "creators": creators,
      "favorite": favorite,
      "tags": tags,
    });
  }
}
