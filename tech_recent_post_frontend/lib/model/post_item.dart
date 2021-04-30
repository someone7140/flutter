class PostItem {
  final String id;
  final String url;
  final String updatedAt;

  PostItem({this.id, this.url, this.updatedAt});

  PostItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        url = json["url"],
        updatedAt = json["updated_at"];

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'updated_at': updatedAt};
  }
}
