import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dietic_mobil/config/config.dart';
import 'package:dietic_mobil/widget/widget.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class DailyCalorieStatistics extends StatefulWidget {
  const DailyCalorieStatistics({Key? key}) : super(key: key);

  @override
  State<DailyCalorieStatistics> createState() => _DailyCalorieStatisticsState();
}

class _DailyCalorieStatisticsState extends State<DailyCalorieStatistics> {
  String? heartRate;
  String? bp;
  String? steps;
  String? activeEnergy;

  String? bloodPreSys;
  String? bloodPreDia;

  List<HealthDataPoint> healthData = [];

  HealthFactory health = HealthFactory();


   @override
  void initState() {
    super.initState();
    fetchData();
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    // define the types to get
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      try {
        // fetch health data
        healthData = await health.getHealthDataFromTypes(yesterday, now, types);
        print(healthData);

        if (healthData.isNotEmpty) {
          for (HealthDataPoint h in healthData) {
            if (h.type == HealthDataType.STEPS) {
              steps = "${h.value}";
            } else if (h.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
              activeEnergy = "${h.value}";
            }
          }
          setState(() {
            print('adımlar');
            print(steps);
          });
        }
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthData = HealthFactory.removeDuplicates(healthData);
    } else {
      print("Authorization not granted");
    }
    print(steps);
    print(activeEnergy);
    final storage = FlutterSecureStorage();
    await storage.write(key: 'steps', value: steps.toString());
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        margin: EdgeInsets.only(top: 18.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            statisticsTile(
                title: 'Intaked',
                icon: FaIcon(
                  FontAwesomeIcons.pizzaSlice,
                  color: Colors.orange,
                ),
                progressColor: AppColors.colorWarning,
                value: '589',
                progressPercent: 0.4
            ),
            SizedBox(width: 15.w,),
            statisticsTile(
                title: 'Burned',
                icon: FaIcon(
                  FontAwesomeIcons.fire,
                  color: Colors.red,
                ),
                progressColor: Colors.redAccent,
                value: steps,
                progressPercent: 0.7
            )

          ],
        ),
      ),
    );
  }
}
