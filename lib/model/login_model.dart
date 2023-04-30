class LoginModel {
  int? id;
  int? dietitianId;
  String? roleName;
  String? email;
  String? name;
  String? surname;
  String? accessToken;
  String? tokenType;

  LoginModel(
      {this.id,
      this.dietitianId,
      this.roleName,
      this.email,
      this.name,
      this.surname,
      this.accessToken,
      this.tokenType});

  LoginModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dietitianId = json['dietitianId'];
    roleName = json['roleName'];
    email = json['email'];
    name = json['name'];
    surname = json['surname'];
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dietitianId'] = this.dietitianId;
    data['roleName'] = this.roleName;
    data['email'] = this.email;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['accessToken'] = this.accessToken;
    data['tokenType'] = this.tokenType;
    return data;
  }
}
