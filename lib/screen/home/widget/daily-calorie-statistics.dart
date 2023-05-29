import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Dietic/config/config.dart';
import 'package:Dietic/widget/widget.dart';
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

  String? move_mins;

  String? height;

  String? water;


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
      HealthDataType.HEIGHT,
      HealthDataType.WATER,
     // HealthDataType.MOVE_MINUTES,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 5));

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
            else if (h.type == HealthDataType.MOVE_MINUTES) {
              move_mins = "${h.value}";
            }
            else if (h.type == HealthDataType.HEIGHT) {
              height = "${h.value}";
            }
            else if (h.type == HealthDataType.WATER) {
              water = "${h.value}";
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
    print('aktif enerji:');
    print(activeEnergy);
    final storage = FlutterSecureStorage();
    await storage.write(key: 'steps', value: steps.toString());
    await storage.write(key: 'energy', value: activeEnergy.toString());
    await storage.write(key: 'move_min', value: move_mins.toString());
    await storage.write(key: 'height', value: height.toString());
    await storage.write(key: 'water', value: water.toString());
    /////////////////////////////////////////////////////////////////
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
                value: activeEnergy,
                progressPercent: 0.7
            )

          ],
        ),
      ),
    );
  }
}
