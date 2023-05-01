import 'package:dietic_mobil/model/get_appointment.dart';
import 'package:dietic_mobil/screen/appointment/comps/config.dart';
import 'package:dietic_mobil/service/appointment/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../config/theme/theme.dart';
import '../../model/booking_datetime_converted.dart';
import '../../provider/dio_provider.dart';
import 'comps/button.dart';
import 'comps/custom_app_bar.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);
  static const String routeName = '/appointment';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => Appointment(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? token; //get token for insert booking date and time into database
  Map<String, List<String>>? dateMap;
  Map<String, String>? map;
  List<GetAppointmentModel> appointments = [];
  List<String> sumTime = [];
  List<String> sum = [];
  List<dynamic> allTimes = [];
  List<String> zamanlar=['9:00:00','10:00:00','11:00:00','12:00:00','13:00:00','14:00:00','15:00:00','16:00:00'];
List<String>? differenceList;
  final service = AppointmentService();
  
  int? buttonNumber;
  @override
  void initState() {
    // service.getPatientAppointments().then((data) {
    //   appointments = data;
    //   for (int i = 0; i < appointments.length; i++) {
    //     print(appointments[i].appointmentDate);
    //    print(appointments[i].appointmentTime);

    //     Map<String, String> myMap = {};
    //     myMap['${appointments[i].appointmentDate}']='${appointments[i].appointmentTime}';
    //     map=myMap;

    //   }

    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
/*
    final doctor = ModalRoute.of(context)!.settings.arguments as Map;
*/
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appTitle: 'Appointment',
          icon: const FaIcon(Icons.arrow_back_ios),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    _tableCalendar(),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                      child: Center(
                        child: Text(
                          'Select Available Time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _isWeekend
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        alignment: Alignment.center,
                        child: const Text(
                          'Weekend is not available, please select another date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                                _timeSelected = true;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: _currentIndex == index
                                    ? AppColors.colorAccent
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child:differenceList==null?Text(
                                zamanlar[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : null,
                                ),
                              ) : Text(
                                differenceList![index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: buttonNumber ?? 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, childAspectRatio: 1.5),
                    ),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                  child: Button(
                    width: double.infinity,
                    title: 'Make Appointment',
                    onPressed: () async {
                      //convert date/day/time into string first
                      final getDate = DateConverted.getDate(_currentDay);
                      final getDay = DateConverted.getDay(_currentDay.weekday);
                      final getTime = DateConverted.getTime(_currentIndex!);
                      print(getTime);
                      print(getDate);

                      DateTime dateTime = DateFormat('hh:mm a').parse(getTime);
                      String timeString =
                          DateFormat('HH:mm:ss').format(dateTime);
                      DateTime date = DateTime.parse(_currentDay.toString());
                      String DateString = date.toString().substring(0, 10);

                      service.postAppointment(DateString, timeString);

                      Navigator.pushNamed(context, '/success-appointment');
                    },
                    disable: _timeSelected && _dateSelected ? false : true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //table calendar
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2023, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: AppColors.colorAccent, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
          String dateWithoutTime = selectedDay.toString().substring(0, 10);
          print(dateWithoutTime);

          //sıkıntı var
          service.getAppointmentsByDate(dateWithoutTime).then((value) {
            allTimes.clear();
              for (int i = 0; i < value.length; i++) {
                allTimes.add(value[i].appointmentTime);
                //print(allTimes[i]);
              }  
              allTimes.length=value.length;
          });
          buttonNumber=8-allTimes.length;
         differenceList = zamanlar.where((element) => !allTimes.contains(element)).toList();
          
          //check if weekend is selected
          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      }),
    );
  }
}
