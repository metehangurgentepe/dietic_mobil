import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/patient_detail.dart';

class PatientDetailService {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietitians/patients/details';
  PatientModel? patient;
  Future<PatientModel> getPatientDetail() async {
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await dio.get(url);
      patient = PatientModel.fromJson(response.data);
      return patient!;
    } catch (e) {
      throw Exception('${e} patient detail alınamadı');
    }
  }
}
