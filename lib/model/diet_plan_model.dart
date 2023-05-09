class DietPlanModel {
  int? planId;
  String? day;
  int? meal;
  int? foodId;
  String? foodName;
  double? carb;
  double? protein;
  double? fat;
  double? energy;
  String? details;
  String? eaten;
  double? portion;

  DietPlanModel(
      {this.planId,
      this.day,
      this.meal,
      this.foodId,
      this.foodName,
      this.carb,
      this.protein,
      this.fat,
      this.energy,
      this.details,
      this.eaten,
      this.portion});

  DietPlanModel.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    day = json['day'];
    meal = json['meal'];
    foodId = json['food_id'];
    foodName = json['food_name'];
    carb = json['carb'];
    protein = json['protein'];
    fat = json['fat'];
    energy = json['energy'];
    details = json['details'];
    eaten = json['eaten'];
    portion = json['portion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['day'] = this.day;
    data['meal'] = this.meal;
    data['food_id'] = this.foodId;
    data['food_name'] = this.foodName;
    data['carb'] = this.carb;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['energy'] = this.energy;
    data['details'] = this.details;
    data['eaten'] = this.eaten;
    data['portion'] = this.portion;
    return data;
  }
}
