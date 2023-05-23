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
  GetAppointmentModel? patientRandevu;
  List<GetAppointmentModel> listPatientRandevu=[];
  List<GetAppointmentForDietitian> listDietitianRandevu = [];
  List<GetAppointmentModel> Randevular = [];
  GetAppointmentModel? diyetisyenRandevu;


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
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/book/${dietitianId}/${patientId}';
    print(getDate + ' ' + getTime);
    print(patientId);
    print('${dietitianId} + ${patientId}');

    try {
      var response = await dio.post(url, data: data);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }





  Future<dynamic> postDytAppointment(
    String getDate,
    String getTime,
    int patientId
  ) async {
    String? dietitianId = await storage.read(key: 'dietitianId');
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
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/book/${dietitianId}/${patientId}';
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
    String url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/patient/3';
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

  Future<List<GetAppointmentModel>> getAppointment() async {
    String? token = await storage.read(key: 'token');
    String url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/dietitian';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var response = await dio.get(url);
      listRandevu.clear();
      for (int i = 0; i < response.data.length; i++) {
        diyetisyenRandevu =
            GetAppointmentModel.fromJson(response.data[i]);
        Randevular.add(diyetisyenRandevu!);
      }
      return Randevular;
    } catch (e) {
      return throw Exception('${e} error');
    }
  }
  Future<List<GetAppointmentModel>> getPatientAppointment() async {
    String? token = await storage.read(key: 'token');
    String? patientId = await storage.read(key: 'patientId');
    String url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/patient/${patientId}';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      print(token);
      var response = await dio.get(url);
      listRandevu.clear();
      for (int i = 0; i < response.data.length; i++) {
        diyetisyenRandevu =
            GetAppointmentModel.fromJson(response.data[i]);
        Randevular.add(diyetisyenRandevu!);
      }
      return Randevular;
    } catch (e) {
      return throw Exception('${e} error');
    }
  }

  Future<List<GetAppointmentForDietitian>> getAppointmentsByDate(
      String datetime) async {
    String? dietitianId = await storage.read(key: 'dietitianId');
    String? token = await storage.read(key: 'token');
    String? patientID = await storage.read(key: 'patientId');

    String url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/dietitian/byDate/${dietitianId}';
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
    Future<List<GetAppointmentModel>> getAppointmentsToday() async {
       DateTime today =DateTime.now();
    String date =today.toString().substring(0,10);
    String? dietitianId = await storage.read(key: 'dietitianId');
    String? token = await storage.read(key: 'token');
    String? patientID = await storage.read(key: 'patientId');

    String url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/dietitian/byDate/${dietitianId}';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> data = {
      'appointmentDate': '${date}',
    };

    try {
      var response = await dio.post(url, data: data);
      print(response.data);
      listDietitianRandevu.clear();
      for (int i = 0; i < response.data.length; i++) {
        patientRandevu =
            GetAppointmentModel.fromJson(response.data[i]);
        listPatientRandevu.add(patientRandevu!);
      }
      print(listPatientRandevu);

      return listPatientRandevu;
    } catch (e) {
      return throw Exception('${e} error');
    }
  }


  Future updateStatus(GetAppointmentModel getAppointmentModel) async {
    String? token = await storage.read(key: 'token');
    String url='http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/appointments/updateStatus/${getAppointmentModel.appointmentId}';
    Map<String, dynamic> data ={
        "appointment_id":getAppointmentModel.appointmentId,
        "status": "AVAILABLE",
        "dietitian_id": getAppointmentModel.dietitianId,
        "patient_id": getAppointmentModel.patientId,
        "appointmentDate": getAppointmentModel.appointmentDate,
        "appointmentTime": getAppointmentModel.appointmentTime,
        "createdAt": getAppointmentModel.createdAt
        };
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try{
      var response = dio.patch(url,data: data);
      print(response);
    }catch(e){
      throw Exception('appointment servis hatası');

    }
  }
}
