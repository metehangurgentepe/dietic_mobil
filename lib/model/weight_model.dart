class WeightModel {
  int? id;
  int? patientId;
  double? weight;
  String? date;

  WeightModel({this.id, this.patientId, this.weight, this.date});

  WeightModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    weight = json['weight'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['weight'] = this.weight;
    data['date'] = this.date;
    return data;
  }
}
