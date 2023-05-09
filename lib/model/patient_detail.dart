class PatientModel {
  int? patientId;
  int? dietitianId;
  String? email;
  String? name;
  String? surname;
  int? age;
  int? height;
  double? weight;
  double? bodyFat;
  String? about;

  PatientModel(
      {this.patientId,
      this.dietitianId,
      this.email,
      this.name,
      this.surname,
      this.age,
      this.height,
      this.weight,
      this.bodyFat,
      this.about});

  PatientModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    dietitianId = json['dietitian_id'];
    email = json['email'];
    name = json['name'];
    surname = json['surname'];
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    bodyFat = json['bodyFat'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['dietitian_id'] = this.dietitianId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['age'] = this.age;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['bodyFat'] = this.bodyFat;
    data['about'] = this.about;
    return data;
  }
}
