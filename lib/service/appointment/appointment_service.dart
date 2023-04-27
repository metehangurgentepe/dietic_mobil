import 'dart:convert';

import 'package:dietic_mobil/model/get_appointment.dart';
import 'package:dietic_mobil/screen/appointment/appointment.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AppointmentService {
  final storage = FlutterSecureStorage();
  Dio dio = Dio();
  GetAppointmentModel? randevu;
  List<GetAppointmentModel> listRandevu = [];
  List<dynamic> appointmentData = [];

  var jsonResponse; // your dynamic list

  Future<dynamic> postAppointment(
    String getDate,
    String getTime,
  ) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    String? token = await storage.read(key: 'token');

    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> data = {
      'appointmentDate': getDate,
      'appointmentTime': getTime
    };

    String url = 'http://localhost:8080/api/v1/appointments/book/3/3';
    print(getDate + ' ' + getTime);

    try {
      var response = await dio.post(url, data: data);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  Future<List<GetAppointmentModel>> getPatientAppointments() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String url = 'http://localhost:8080/api/v1/appointments/patient/3';
    var response = await dio.get(url);
    print(response.data.length);
    print('json');
    for (int i = 0; i < response.data.length; i++) {
      randevu = GetAppointmentModel.fromJson(response.data[i]);
      listRandevu.add(randevu!);
    }
    print(listRandevu);

    return listRandevu;
  }
}
