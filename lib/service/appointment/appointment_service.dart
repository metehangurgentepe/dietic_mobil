import 'dart:convert';

import 'package:dietic_mobil/model/get_appointment.dart';
import 'package:dietic_mobil/model/get_appointment_for_dietitian.dart';
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
  GetAppointmentForDietitian? dietitianRandevu;
  List<GetAppointmentForDietitian> listDietitianRandevu = [];

  var jsonResponse; // your dynamic list

  Future<dynamic> postAppointment(
    String getDate,
    String getTime,
  ) async {
    String? dietitianId = await storage.read(key: 'dietitianId');
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

    String url =
        'http://localhost:8080/api/v1/appointments/book/${dietitianId}/${patientId}';
    print(getDate + ' ' + getTime);
    print('${dietitianId} + ${patientId}');

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
//   Future<List<GetAppointmentForDietitian>> getAppointment(String dietitianId) async {

//     String url='http://localhost:8080/api/v1/appointments/dietitian/${dietitianId}';
//     try{

// var response = await dio.get(url);
//     for (int i = 0; i < response.data.length; i++) {
//       dietitianRandevu = GetAppointmentForDietitian.fromJson(response.data[i]);
//       listDietitianRandevu.add(dietitianRandevu!);
//     }
//     return listDietitianRandevu;
//     }
//     catch(e){
//       return throw Exception('${e} error');

//     }

// }
  Future<List<GetAppointmentForDietitian>> getAppointmentsByDate(
      String datetime) async {
    String? dietitianId = await storage.read(key: 'dietitianId');
    String? token = await storage.read(key: 'token');
    String? patientID = await storage.read(key: 'patientId');

    String url =
        'http://localhost:8080/api/v1/appointments/dietitian/byDate/${dietitianId}';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> data = {
      'appointmentDate': '${datetime}',
    };

    try {
      var response = await dio.post(url, data: data);
      print(response.data);
      listDietitianRandevu.clear();
      for (int i = 0; i < response.data.length; i++) {
        dietitianRandevu =
            GetAppointmentForDietitian.fromJson(response.data[i]);
            listDietitianRandevu.add(dietitianRandevu!);
      }
      
      for (int i = 0; i < response.data.length; i++) {
        print(listDietitianRandevu[i].appointmentTime);
        print(listDietitianRandevu.length);
      }
      
      return listDietitianRandevu;
    } catch (e) {
      return throw Exception('${e} error');
    }
  }
}
