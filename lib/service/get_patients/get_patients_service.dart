import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/patient_detail.dart';

class GetPatientService {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietitians/patients';
  List<PatientModel> patient=[];
  Future<List<PatientModel>> getPatients() async {
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var response = await dio.get(url);
      for(int i=0;i<response.data.length;i++){
        patient.add(PatientModel.fromJson(response.data[i]));
      }
      print(patient);
      return patient;
    } catch (e) {
      throw Exception('${e} patient detail alınamadı');
    }
  }
}
