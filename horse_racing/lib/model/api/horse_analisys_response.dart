class HorceAnalysisResponse {
  late final String raceName;
  late final String horseId;
  late final String horseName;
  late final String horseUrl;
  late final String sameCourseFastTime;
  late final int score;

  HorceAnalysisResponse.fromJson(Map<String, dynamic> json)
      : raceName = json["raceName"],
        horseId = json["horseId"],
        horseName = json["horseName"],
        horseUrl = json["horseUrl"],
        sameCourseFastTime = json["sameCourseFastTime"],
        score = json["score"];

  Map<String, dynamic> toJson() {
    return {
      'raceName': raceName,
      'horseId': horseId,
      'horseName': horseName,
      'horseUrl': horseUrl,
      'sameCourseFastTime': sameCourseFastTime,
      'score': score
    };
  }
}
