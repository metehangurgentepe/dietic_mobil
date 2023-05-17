import 'package:dietic_mobil/model/diet_plan_model.dart';
import 'package:dietic_mobil/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../config/theme/fitness_app_theme.dart';
import '../../hexColor.dart';
import '../../main.dart';
import '../../model/meals_list_data.dart';

class MealsListView extends StatefulWidget {
  const MealsListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DietPlanService service = DietPlanService();

  List<DietPlanModel> lunchPlan = [];
  List<DietPlanModel> breakfastPlan = [];
  List<DietPlanModel> dinnerPlan = [];
  List<double?> energy = [];
  List<String> breakfastFoodNames = [];

  @override
  void initState() {
    DateTime date = DateTime.now();
    String time = date.toString().substring(0, 10);

    service.getBreakfastDietPlan().then((value) {
      if (value != null) {
        setState(() {
          breakfastPlan = value;
        });
      } else {
        throw Exception('kahvaltı data null geldi');
      }
    });
    service.getLunchDietPlan().then((value) {
      if (value != null) {
        setState(() {
          lunchPlan = value;
        });
      } else {
        throw Exception('lunch data null geldi');
      }
    });
    service.getDinnerDietPlan().then((value) {
      if (value != null) {
        setState(() {
          dinnerPlan = value;
        });
      } else {
        throw Exception('dinner data null geldi');
      }
    });
    service.getFirstDietPlanEnergy().then((value) {
      if (value != null) {
        setState(() {
          energy = value;
        });
      } else {
        throw Exception('getFirstDietPlanEnergy data null geldi');
      }
    });
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagePath = [
      'assets/fitness_app/breakfast.png',
      'assets/fitness_app/lunch.png',
      'assets/fitness_app/dinner.png',
      'assets/fitness_app/snack.png'
    ];
    List<String> titleTxt = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    List<String> startColor = ['#FA7D82', '#738AE6', '#6F72CA', '#FE95B6'];
    List<String> endColor = ['#FFB295', '#5C5EDD', '#1E1466', '#FF5287'];
    List<List<DietPlanModel>> dietPlan = [
      breakfastPlan,
      lunchPlan,
      dinnerPlan,
      breakfastPlan
    ];
    List<double?> kacl = energy;

    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = 1 > 10 ? 10 : 4;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  if (energy.isEmpty) {
                    return MealsView(
                      dietPlan: dietPlan[index],
                      imagePath: imagePath[index],
                      titleTxt: titleTxt[index],
                      startColor: startColor[index],
                      endColor: endColor[index],
                      kacl: 0,
                      animation: animation,
                      animationController: animationController!,
                    );
                  } else {
                    return MealsView(
                      dietPlan: dietPlan[index],
                      imagePath: imagePath[index],
                      titleTxt: titleTxt[index],
                      startColor: startColor[index],
                      endColor: endColor[index],
                      kacl: energy[index],
                      animation: animation,
                      animationController: animationController!,
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key? key,
      this.animationController,
      this.animation,
      required this.dietPlan,
      this.mealsListData,
      required this.imagePath,
      required this.titleTxt,
      required this.startColor,
      required this.endColor,
      this.breakfastPlan,
      required this.kacl})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? breakfastPlan;
  final String imagePath;
  final String titleTxt;
  final double? kacl;
  final String startColor;
  final String endColor;
  final MealsListData? mealsListData;
  final List<DietPlanModel> dietPlan;

  @override
  Widget build(BuildContext context) {
    MealsListData mealsListData = MealsListData.dynamicList(
        dietPlan: [],
        imagePath: imagePath,
        titleTxt: titleTxt,
        startColor: startColor,
        endColor: endColor,
        mealsList: [],
        kacl: kacl!);
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor('#' + endColor.toString())
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor('#' + startColor.toString()),
                            HexColor('#' + endColor.toString()),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              titleTxt.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            dietPlan.isNotEmpty ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    
                                    // Display the first element
                                    Text(
                                      '${dietPlan[0].foodName.toString()}\n',
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 6.3,
                                        letterSpacing: 0.2,
                                        color: FitnessAppTheme.white,
                                      ),
                                    ),
                                    // Check if the second-last element exists and display it
                                    if (dietPlan.length >= 2 &&
                                        dietPlan[dietPlan.length - 2] != null)
                                      Text(
                                        '${dietPlan[dietPlan.length - 2].foodName.toString()}\n',
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 6.3,
                                          letterSpacing: 0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    // Check if the last element exists and display it
                                    if (dietPlan.length >= 3 &&
                                        dietPlan[dietPlan.length - 3] != null)
                                      Text(
                                        '${dietPlan[dietPlan.length - 3].foodName.toString()}\n',
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 6.3,
                                          letterSpacing: 0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ):Text(' '),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  kacl.toString() ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, bottom: 3),
                                  child: Text(
                                    'kcal',
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 8,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset('${imagePath}'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
