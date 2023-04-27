class LoginModel {
  String? roleName;
  String? name;
  String? surname;
  String? accessToken;
  String? tokenType;

  LoginModel(
      {this.roleName,
      this.name,
      this.surname,
      this.accessToken,
      this.tokenType});

  LoginModel.fromJson(Map<String, dynamic> json) {
    roleName = json['roleName'];
    name = json['name'];
    surname = json['surname'];
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleName'] = this.roleName;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['accessToken'] = this.accessToken;
    data['tokenType'] = this.tokenType;
    return data;
  }
}
