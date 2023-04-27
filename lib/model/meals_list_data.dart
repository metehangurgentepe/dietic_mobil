import 'dart:core';

import 'package:dietic_mobil/service/diet_plan/diet_plan_service.dart';

class MealsListData {
  MealsListData({
    required this.imagePath,
    required this.titleTxt,
    required this.startColor,
    required this.endColor,
    required this.kacl,
    this.dietPlan
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  int kacl;
 List<List<String>>? dietPlan;

  MealsListData.dynamicList({
    required this.imagePath,
    required this.titleTxt,
    required this.kacl,
    required List<List<String>> mealsList,
    required this.startColor,
    required this.endColor, required List<List<String>> dietPlan,
  }) : dietPlan = mealsList;

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'titleTxt': titleTxt,
      'kacl': kacl,
      'meals': dietPlan,
      'startColor': startColor,
      'endColor': endColor,
    };
  }

/*
  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: 'assets/fitness_app/breakfast.png',
      titleTxt: 'Breakfast',
      kacl: 525, startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/lunch.png',
      titleTxt: 'Lunch',
      kacl: 602,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/dinner.png',
      titleTxt: 'Dinner',
      kacl: 0,
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/snack.png',
      titleTxt: 'Snack',
      kacl: 0,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    )
  ];
*/
}
