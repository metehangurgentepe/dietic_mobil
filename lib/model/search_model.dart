class SearchModel {
  int? foodId;
  String? description;
  num? protein;
  num? fat;
  num? carb;
  num? energy;

  SearchModel(
      {this.foodId,
        this.description,
        this.protein,
        this.fat,
        this.carb,
        this.energy});

  SearchModel.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    description = json['description'];
    protein = json['protein'];
    fat = json['fat'];
    carb = json['carb'];
    energy = json['energy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this.foodId;
    data['description'] = this.description;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carb'] = this.carb;
    data['energy'] = this.energy;
    return data;
  }
}
