class WorldData {
  final int totalCases;
  final int deaths;
  final int recovered;
  final int active;

  WorldData({this.totalCases, this.deaths, this.recovered, this.active});

  factory WorldData.fromJson(Map<String, dynamic> json) {
    return WorldData(
        totalCases: json['cases'],
        deaths: json['deaths'],
        recovered: json['recovered'],
        active: json['active']);
  }
}
