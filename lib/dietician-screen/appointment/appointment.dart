import 'package:Dietic/model/get_appointment.dart';
import 'package:Dietic/screen/appointment/comps/config.dart';
import 'package:Dietic/service/appointment/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../config/theme/theme.dart';
import '../../model/booking_datetime_converted.dart';
import '../../provider/dio_provider.dart';
import 'comps/button.dart';
import 'comps/custom_app_bar.dart';

class DytAppointment extends StatefulWidget {
  const DytAppointment({Key? key, required this.patientId}) : super(key: key);
  static const String routeName = '/dyt_appointment';

  static Route route({required int patientId}) {
    return MaterialPageRoute(
        builder: (_) => DytAppointment(patientId: patientId),
        settings: const RouteSettings(name: routeName));
  }

  final int patientId;

  @override
  State<DytAppointment> createState() => _DytAppointmentState();
}

class _DytAppointmentState extends State<DytAppointment> {
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
  List<String> zamanlar = [
    '9:00:00',
    '9:30:00',
    '10:00:00',
    '10:30:00',
    '11:00:00',
    '11:30:00',
    '12:00:00',
    '12:30:00',
    '13:00:00',
    '13:30:00',
    '14:00:00',
    '14:30:00',
    '15:00:00',
    '15:30:00',
    '16:00:00',
    '16:30:00'
  ];
  List<String>? differenceList;
  final service = AppointmentService();
  ValueNotifier<String>? dateNotifier;
    ValueNotifier<List>? list;

  int? buttonNumber;
  
  String? dateWithoutTime;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    String date = DateTime.now().toString().substring(0, 10);
    dateNotifier = ValueNotifier<String>(date);
    list = ValueNotifier<List>(zamanlar);
    service.getAppointmentsByDate(date).then((value) {
      setState(() {
        allTimes.clear();
        for (int i = 0; i < value.length; i++) {
          allTimes.add(value[i].appointmentTime);
        }
        allTimes.length = value.length;
      });
      allTimes.isEmpty
          ? list = ValueNotifier<List>(zamanlar)
          : list = ValueNotifier<List>(allTimes);
      allTimes.isEmpty
          ? differenceList = zamanlar
          : differenceList = allTimes.cast<String>();
    });
    //list = ValueNotifier<List>(zamanlar);

    super.initState();
  }

  ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);


  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    list!.dispose();
    super.dispose();
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
                  :  ValueListenableBuilder<List>(
                      valueListenable: list!,
                      builder: (context, value, child) {
                        buttonNumber = 16 - allTimes.length;
                        differenceList = zamanlar
                            .where((element) => !allTimes.contains(element))
                            .toList();
                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    
                                    _currentIndex=index;
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
                                  child: allTimes == null
                                      ? Text(
                                          zamanlar[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _currentIndex == index
                                                ? Colors.white
                                                : null,
                                          ),
                                        )
                                      : Text(
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
                            childCount: buttonNumber ?? 16,
                          ),
                          gridDelegate:
                             const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 2,
                          ),
                        );
                      },
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

                      //final getTime = DateConverted.getTime(int.parse(_currentIndex!));

                      //String time= '${getTime.substring(0,5)}:00';

                      //DateTime dateTime = DateFormat('hh:mm a').parse(getTime);
                      DateTime date = DateTime.parse(_currentDay.toString());
                      String DateString = date.toString().substring(0, 10);

                      service.postDytAppointment(DateString,
                          differenceList![_currentIndex!], widget.patientId);

                      Navigator.pushNamed(context, '/success-appointment');
                    },
                    disable: _timeSelected ? false : true,
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
      calendarStyle: CalendarStyle(
        todayDecoration:
            BoxDecoration(color: AppColors.colorAccent, shape: BoxShape.circle),
      ),
      availableCalendarFormats: {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() async {
          _currentDay = selectedDay;
          _focusDay = focusedDay;

          _dateSelected = true;
          dateWithoutTime = selectedDay.toString().substring(0, 10);
          dateNotifier = ValueNotifier<String>(dateWithoutTime!);
          await storage.write(key: 'time', value: dateWithoutTime);

          service.getAppointmentsByDate(dateWithoutTime!).then((value) {
            setState(() {
              allTimes.clear();
              for (int i = 0; i < value.length; i++) {
                allTimes.add(value[i].appointmentTime);
                //print(allTimes[i]);
              }
              allTimes.length = value.length;
              list=ValueNotifier<List>(allTimes);
            });
          });

         

          String? index = await storage.read(key: 'index');
          try {
            _currentIndex = int.parse(differenceList![int.parse(index!)]);
            print(_currentIndex);
          } catch (e) {}

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
