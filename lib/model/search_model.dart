class SearchModel {
  int? id;
  String? description;
  int? protein;
  int? fat;
  int? carb;
  int? energy;

  SearchModel(
      {this.id,
        this.description,
        this.protein,
        this.fat,
        this.carb,
        this.energy});

  SearchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    protein = json['protein'];
    fat = json['fat'];
    carb = json['carb'];
    energy = json['energy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carb'] = this.carb;
    data['energy'] = this.energy;
    return data;
  }
}
