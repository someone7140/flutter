class PostTagResponse {
  final String id;
  final String tagWord;

  PostTagResponse({required this.id, required this.tagWord});

  PostTagResponse.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        tagWord = json["tagWord"];

  static List<PostTagResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PostTagResponse.fromJson(json)).toList();
  }
}
