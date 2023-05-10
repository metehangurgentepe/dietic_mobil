class UserModel {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? password;
  String? picture;

  UserModel(
      {this.id,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.picture});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    password = json['password'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['email'] = this.email;
    data['password'] = this.password;
    data['picture'] = this.picture;
    return data;
  }
}
