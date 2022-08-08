class AlbumInfo {
  String name;
  int preview;
  int count;

  AlbumInfo({
    required this.name,
    required this.preview,
    required this.count,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      name: json['name'],
      preview: json['preview'],
      count: json['count'],
    );
  }
}
