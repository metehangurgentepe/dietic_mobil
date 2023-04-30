import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/patient_detail.dart';

class PatientDetailService {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String url = 'http://localhost:8080/api/v1/dietitians/patients/details';
  PatientDetailModel? patient;
  Future<PatientDetailModel> getPatientDetail() async {
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await dio.get(url);
      patient = response.data;
      return patient!;
    } catch (e) {
      throw Exception('patient detail alınamadı');
    }
  }
}
