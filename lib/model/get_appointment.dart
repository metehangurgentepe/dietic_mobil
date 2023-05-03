class GetAppointmentModel {
  int? appointmentId;
  String? status;
  int? dietitianId;
  String? dietitianName;
  int? patientId;
  String? patientName;
  String? appointmentDate;
  String? appointmentTime;
  String? createdAt;

  GetAppointmentModel(
      {this.appointmentId,
      this.status,
      this.dietitianId,
      this.dietitianName,
      this.patientId,
      this.patientName,
      this.appointmentDate,
      this.appointmentTime,
      this.createdAt});

  GetAppointmentModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    status = json['status'];
    dietitianId = json['dietitian_id'];
    dietitianName = json['dietitianName'];
    patientId = json['patient_id'];
    patientName = json['patientName'];
    appointmentDate = json['appointmentDate'];
    appointmentTime = json['appointmentTime'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['status'] = this.status;
    data['dietitian_id'] = this.dietitianId;
    data['dietitianName'] = this.dietitianName;
    data['patient_id'] = this.patientId;
    data['patientName'] = this.patientName;
    data['appointmentDate'] = this.appointmentDate;
    data['appointmentTime'] = this.appointmentTime;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
