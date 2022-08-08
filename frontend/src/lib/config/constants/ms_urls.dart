class MSUrls {
  MSUrls._();

  static const String _baseUrl = "http://192.168.178.34:8010";

  static const String allAlbums = "$_baseUrl/album";
  static const String allAlbumInfos = "$allAlbums/info";
  static const String addAlbum = "$allAlbums/add";
  static const String removeAlbum = "$allAlbums/remove";
  static const String updateAlbum = "$allAlbums/update";

  static const String allCreators = "$_baseUrl/creator";
  static const String addCreator = "$allCreators/add";
  static const String removeCreator = "$allCreators/remove";
  static const String updateCreator = "$allCreators/update";

  static const String allTags = "$_baseUrl/tag";
  static const String addTag = "$allTags/add";
  static const String removeTag = "$allTags/remove";
  static const String updateTag = "$allTags/update";

  static const String media = "$_baseUrl/media";
  static const String addMedia = "$media/add";
  static const String removeMedia = "$media/remove";
  static const String updateMedia = "$media/update";
  static const String searchMedia = "$media/search";

  static const String addTagToMedia = "$media/tags/add";
  static const String removeTagFromMedia = "$media/tags/remove";

  static const String addMediaToAlbum = "$media/albums/add";
  static const String removeMediaFromAlbum = "$media/albums/remove";

  static String mediaFile(int id) => "$media/file/$id";
  static String mediaThumb(int id) => "$media/thumb/$id";

  static const String synchronize = "$_baseUrl/synchronize";
}
