import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  Timestamp? dateTime;
  String? email;
  String? name;
  String? password;
  String? profilePic;

  UserModel(
      {this.dateTime, this.email, this.name, this.password, this.profilePic});

  UserModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['date_time'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_time'] = this.dateTime;
    data['email'] = this.email;
    data['name'] = this.name;
    data['password'] = this.password;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
