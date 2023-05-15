class StepsModel {
  int? id;
  int? patientId;
  int? steps;
  String? date;

  StepsModel({this.id, this.patientId, this.steps, this.date});

  StepsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    steps = json['steps'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['steps'] = this.steps;
    data['date'] = this.date;
    return data;
  }
}
