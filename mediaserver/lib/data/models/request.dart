import 'dart:convert';

class Request {
  final int? id;
  final String? name;
  final String? oldName;
  final String? payload;
  final int? count;
  final int? start;

  Request({
    this.id,
    this.name,
    this.oldName,
    this.payload,
    this.count,
    this.start,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'oldName': oldName,
      'payload': payload,
      'count': count,
      'start': start,
    });
  }
}
