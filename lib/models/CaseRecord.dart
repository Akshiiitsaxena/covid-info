class CaseRecordData {
  final String caseType;
  final int cases;
  final DateTime date;

  CaseRecordData({this.caseType, this.cases, this.date});

  factory CaseRecordData.fromJson(Map<String, dynamic> json) {
    return CaseRecordData(
        caseType: json['Status'],
        cases: json['Cases'],
        date: DateTime.parse(json['Date']));
  }
}


