import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dietic_mobil/screen/daily-summary-detail/widget/date.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/theme/theme.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);
  static const String routeName = '/exercise';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ExerciseScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  DateTime _selectedTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2025))
        .then((value) => {
              setState(() {
                _selectedTime = value!;
              })
            });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    int month = int.parse(_selectedTime.month.toString());
    String monthName = '';

    switch (month) {
      case 1:
        monthName = 'January';
        break;
      case 2:
        monthName = 'February';
        break;
      case 3:
        monthName = 'March';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'June';
        break;
      case 7:
        monthName = 'July';
        break;
      case 8:
        monthName = 'August';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'October';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'December';
        break;
      default:
        monthName = 'Invalid month';
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Exercises')),
        backgroundColor: AppColors.colorPrimary,
      ),
      body: Column(
        children: [
          Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                Text(_selectedTime.day.toString() + " " + monthName,
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                MaterialButton(
                  height: 80,
                  minWidth: 150,
                  color: AppColors.colorAccent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 200),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  onPressed: () {
                    _showDatePicker();
                  },
                  child: Text('Today', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(height: 50),
                CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: 74,
                  stepSize: 10,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 150,
                  height: 150,
                  selectedStepSize: 15,
                  roundedCap: (_, __) => true,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(
                          '652 kcal',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          'Active Calories',
                          style: TextStyle(fontSize: 11),
                        )
                      ])),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 6),
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: 74,
                      stepSize: 10,
                      selectedColor: Colors.blueAccent,
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: 100,
                      height: 100,
                      selectedStepSize: 15,
                      roundedCap: (_, __) => true,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(
                              'Steps',
                              style: TextStyle(fontSize: 11),
                            ),
                            Text(
                              '1200',
                              style: TextStyle(fontSize: 22),
                            )
                          ])),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: 74,
                      stepSize: 10,
                      selectedColor: Colors.blueGrey,
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: 100,
                      height: 100,
                      selectedStepSize: 15,
                      roundedCap: (_, __) => true,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Time',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  '45 min',
                                  style: TextStyle(fontSize: 20),
                                )
                          ])),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: 74,
                      stepSize: 10,
                      selectedColor: Colors.pink,
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: 100,
                      height: 100,
                      selectedStepSize: 15,
                      roundedCap: (_, __) => true,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Heart',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  '75 bpm',
                                  style: TextStyle(fontSize: 18),
                                )
                          ])),
                    ),
                  ],
                ),
                    SizedBox(height:25),
              ]))
        ],
      ),
    );
  }
}
