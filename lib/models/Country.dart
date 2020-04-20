class CountryData {
  final String name;
  final String countryCode;
  final int confirmedCases;
  final int recoveredCases;
  final int deathCases;
  final String flagUrl;

  CountryData(
      {this.name,
      this.countryCode,
      this.confirmedCases,
      this.recoveredCases,
      this.deathCases,
      this.flagUrl});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
        name: json['country'],
        countryCode: json['countryInfo']['iso2'],
        confirmedCases: json['cases'],
        recoveredCases: json['recovered'],
        deathCases: json['deaths'],
        flagUrl:
            "https://www.countryflags.io/${json['countryInfo']['iso2']}/shiny/64.png");
  }
}
