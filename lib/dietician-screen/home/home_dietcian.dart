import 'package:dietic_mobil/config/theme/fitness_app_theme.dart';
import 'package:dietic_mobil/model/get_appointment.dart';
import 'package:dietic_mobil/service/appointment/appointment_service.dart';
import 'package:dietic_mobil/service/update_profile_pic/update_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../model/get_appointment_for_dietitian.dart';
import '../../screen/appointment/comps/config.dart';
import 'comps/appointment_card.dart';
import 'comps/chart_painter.dart';
import 'comps/doctor_card.dart';

class HomeDietician extends StatefulWidget {
  const HomeDietician({Key? key}) : super(key: key);

  @override
  State<HomeDietician> createState() => _HomeDieticianPageState();
}

class _HomeDieticianPageState extends State<HomeDietician> {
  final storage = FlutterSecureStorage();
  final service = AppointmentService();
  List<GetAppointmentModel> appointments = [];
  GetAppointmentModel? nextAppointment;
  List<String>? appointmentTimes;
  final userService = UpdateProfilePic();

  String? name;
  @override
  initState() {
    service.getAppointmentsToday().then((value) {
      setState(() {
        DateTime now = DateTime.now();
        appointments = value;
      });

      // for (int i = 0; i < appointments.length; i++) {
      //   appointmentTimes!.add(appointments[i].appointmentTime!);
      // }

      // TimeOfDay convertToTimeOfDay(String timeString) {
      //   List<String> parts = timeString.split(":");
      //   int hour = int.parse(parts[0]);
      //   int minute = int.parse(parts[1]);
      //   return TimeOfDay(hour: hour, minute: minute);
      // }

      // TimeOfDay findNextAppointment(List<String> appointmentTimes) {
      //   appointmentTimes.sort();
      //   final now = TimeOfDay.now();
      //   for (final appointmentTime in appointmentTimes) {
      //     TimeOfDay appointment = convertToTimeOfDay(appointmentTime);
      //     DateTime nowDateTime = DateTime.now();
      //     DateTime appointmentDateTime = DateTime(
      //       nowDateTime.year,
      //       nowDateTime.month,
      //       nowDateTime.day,
      //       appointment.hour,
      //       appointment.minute,
      //     );
      //     if (appointmentDateTime.isAfter(nowDateTime)) {
      //       return appointment;
      //     }
      //   }
      //   return throw Exception();
      // }

      // TimeOfDay nextAppointmentTime = findNextAppointment(appointmentTimes!);
      // print(nextAppointmentTime);
    });
    super.initState();
  }
  Future<String?> getName() async {
    String? dietitanName = await storage.read(key: 'dietitian-name');
    return dietitanName;
  }

  Future<String?> getEmail() async {
    String? email = await storage.read(key: 'email');
    return email;
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    /*user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;*/

    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      //if user is empty, then return progress indicator
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FutureBuilder(
                            future: getName(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? 'Try again',
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                        FutureBuilder(
                            future: userService.getProfilePic(),
                            builder: (context, snapshot) {
                              return snapshot.data!.picture!.isNotEmpty
                                  ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(snapshot.data!.picture!),
                                  ) : const Icon(Icons.person);
                            })
                      ],
                    ),
                    FutureBuilder(
                        future: getEmail(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? 'Try again',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                          );
                        }),
                  ],
                ),
                Config.spaceMedium,
                const Text(
                  'Appointment Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                appointments.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildItem(
                                  '${appointments.last.patientName!} ${appointments.last.patientSurname}',
                                  '${appointments.last.appointmentTime!.substring(0, 5)} ',
                                  Color(0xff0074ff)),
                              _buildDivider(),
                              _buildItem(
                                  "${appointments[index].status!}",
                                  "${appointments.length} Patients",
                                  Color(0xffff1759)),
                            ],
                          );
                        })
                    : LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 100,
                      ),
                Config.spaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Appointment Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: Text('See All'))
                  ],
                ),
                Config.spaceSmall,
                appointments.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 180,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Appointment Date'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.alarm,
                                          size: 20,
                                        ),
                                        Text(
                                          '   ${appointments[index].appointmentDate}   ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.circle,
                                          color: Colors.grey,
                                          size: 5,
                                        ),
                                        Text(
                                          '    ${appointments[index].appointmentTime!.substring(0, 5)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 3),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: ListTile(
                                      title: Text(
                                          '${appointments[index].patientName!} ${appointments[index].patientSurname} ',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      leading: Icon(Icons.person, size: 70),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'No Appointment Today',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Flexible(
      flex: 1,
      child: SizedBox(
        width: 5,
        child: Container(
          alignment: Alignment.centerRight,
          height: 70,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String title, String subtitle, Color chartColor) {
    return Flexible(
      flex: 5,
      child: Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 60,
                height: 80,
                child: CustomPaint(
                  painter: CurrentDataChartPainter(
                    chartColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
