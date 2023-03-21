class LoginModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? token;

  LoginModel(
      {this.id, this.firstName, this.lastName, this.email, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['token'] = this.token;
    return data;
  }
}
