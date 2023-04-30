class GetAppointmentForDietitian {
  int? appointmentId;
  String? status;
  int? dietitianId;
  int? patientId;
  String? appointmentDate;
  String? appointmentTime;
  String? createdAt;

  GetAppointmentForDietitian(
      {this.appointmentId,
      this.status,
      this.dietitianId,
      this.patientId,
      this.appointmentDate,
      this.appointmentTime,
      this.createdAt});

  GetAppointmentForDietitian.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    status = json['status'];
    dietitianId = json['dietitian_id'];
    patientId = json['patient_id'];
    appointmentDate = json['appointmentDate'];
    appointmentTime = json['appointmentTime'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['status'] = this.status;
    data['dietitian_id'] = this.dietitianId;
    data['patient_id'] = this.patientId;
    data['appointmentDate'] = this.appointmentDate;
    data['appointmentTime'] = this.appointmentTime;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
