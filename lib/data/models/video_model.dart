class VideoModel {
  final String id;
  final String key;
  final String site;
  final String type;

  VideoModel({required this.id, required this.key, required this.site, required this.type});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(id: json['id'], key: json['key'], site: json['site'], type: json['type']);
  }
}
