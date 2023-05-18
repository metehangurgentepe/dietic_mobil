import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import '../../model/note_model.dart';

class NoteService {

  FlutterSecureStorage storage = FlutterSecureStorage();

  String baseUrl = 'http://localhost:8080/api/v1/notes/';
  
  
  
  Future<List<NoteModel>> getDailyNotes(String date) async {
    List<NoteModel> notes = [];
    String url='${baseUrl}getDailyNotes';
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var data={
      "date":date
    };
    try {
      var response = await dio.post(url,data: data);
      for (int i = 0; i < response.data.length; i++) {
        notes.add(NoteModel.fromJson(response.data[i]));
      }
      print(notes);
      return notes;
    } catch (e) {
      throw Exception('${e} notes detail alınamadı');
    }
  }




  Future postNote(String date, String note, bool done) async {
        String url='${baseUrl}saveNote';

    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var data = {
      "date": date,
      "note": note,
      "done": done
    };
    try {
      var response = await dio.post(url,data: data);
      print(response);
    } catch (e) {
      throw Exception('${e} notes eklenemedi');
    }
  }




  Future updateStatus(int noteId,bool done) async {
    String url='${baseUrl}updateStatus/${noteId}';

    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var data = {
      "done": done
    };
    try {
      var response = await dio.patch(url,data: data);
      print(response);
    } catch (e) {
      throw Exception('${e} notes eklenemedi');
    }
  }
  Future deleteNote(int noteId) async {
    String url='${baseUrl}delete/${noteId}';

    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    
    try {
      var response = await dio.delete(url);
      print(response);
    } catch (e) {
      throw Exception('${e} notes eklenemedi');
    }
  }
  Future <List<NoteModel>> getNotes() async {
    List<NoteModel> notes=[];
    String url='${baseUrl}getUpcomingNotes';

    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    
    try {
      var response = await dio.get(url);
      for (int i = 0; i < response.data.length; i++) {
        notes.add(NoteModel.fromJson(response.data[i]));
      }
      print(notes);
      return notes;
    } catch (e) {
      throw Exception('${e} notes eklenemedi');
    }
  }
}
