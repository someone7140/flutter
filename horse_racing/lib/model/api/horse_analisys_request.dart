class HorceAnalysisRequest {
  final String url;

  HorceAnalysisRequest({required this.url});

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}
