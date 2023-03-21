class FoodDetailsModel {
  int? fdcId;
  String? description;
  String? dataType;
  String? publicationDate;
  String? foodCode;
  List<FoodNutrients>? foodNutrients;

  FoodDetailsModel(
      {this.fdcId,
        this.description,
        this.dataType,
        this.publicationDate,
        this.foodCode,
        this.foodNutrients});

  FoodDetailsModel.fromJson(Map<String, dynamic> json) {
    fdcId = json['fdcId'];
    description = json['description'];
    dataType = json['dataType'];
    publicationDate = json['publicationDate'];
    foodCode = json['foodCode'];
    if (json['foodNutrients'] != null) {
      foodNutrients = <FoodNutrients>[];
      json['foodNutrients'].forEach((v) {
        foodNutrients!.add(new FoodNutrients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fdcId'] = this.fdcId;
    data['description'] = this.description;
    data['dataType'] = this.dataType;
    data['publicationDate'] = this.publicationDate;
    data['foodCode'] = this.foodCode;
    if (this.foodNutrients != null) {
      data['foodNutrients'] =
          this.foodNutrients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodNutrients {
  String? number;
  String? name;
  double? amount;
  String? unitName;

  FoodNutrients({this.number, this.name, this.amount, this.unitName});

  FoodNutrients.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    amount = json['amount'];
    unitName = json['unitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['unitName'] = this.unitName;
    return data;
  }
}
