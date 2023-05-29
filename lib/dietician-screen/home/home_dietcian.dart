import 'dart:collection';

import 'package:Dietic/config/theme/fitness_app_theme.dart';
import 'package:Dietic/model/get_appointment.dart';
import 'package:Dietic/service/appointment/appointment_service.dart';
import 'package:Dietic/service/update_profile_pic/update_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../hexColor.dart';
import '../../model/get_appointment_for_dietitian.dart';
import '../../model/note_model.dart';
import '../../model/user_model.dart';
import '../../screen/appointment/comps/config.dart';
import '../../service/notes/note_service.dart';
import 'comps/appointment_card.dart';
import 'comps/chart_painter.dart';
import 'comps/doctor_card.dart';
import 'package:intl/intl.dart';

class HomeDietician extends StatefulWidget {
  const HomeDietician({Key? key}) : super(key: key);

  @override
  State<HomeDietician> createState() => _HomeDieticianPageState();
}

class _HomeDieticianPageState extends State<HomeDietician>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  final storage = FlutterSecureStorage();
  final service = AppointmentService();
  List<GetAppointmentModel> appointments = [];
  GetAppointmentModel? nextAppointment;
  List<String> appointmentTimes = [];
  final userService = UpdateProfilePic();
  final noteService = NoteService();
  Map hastalar = {};
  String? patientName;
  String? randevuSaat;
  String profilePic = '';
  UserModel? user;
  List<String> imagePath = [
    'assets/fitness_app/breakfast.png',
    'assets/fitness_app/lunch.png',
    'assets/fitness_app/dinner.png',
    'assets/fitness_app/snack.png'
  ];
  List<String> titleTxt = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  List<String> startColor = ['#FA7D82', '#738AE6', '#6F72CA', '#FE95B6'];
  List<String> endColor = ['#FFB295', '#5C5EDD', '#1E1466', '#FF5287'];

  String? name;
  List<NoteModel> notes = [];

  String string = 'No appointment';
  List<Color> firstContainer=[Color(0xFF6F72CA),Color(0xFF1E1466)];
  List<Color> secondContainer=[Color(0xFFFFB295),Color(0xFFA7D82)];

  @override
  initState() {
    DateTime now = DateTime.now();
    String date = now.toString().substring(0, 10);
    service.getAppointmentsToday().then((value) {
      setState(() {
        DateTime now = DateTime.now();
        appointments = value;
      });

      for (int i = 0; i < appointments.length; i++) {
        appointmentTimes.add(appointments[i].appointmentTime!.substring(0, 5));
        hastalar[
                '${appointments[i].patientName} ${appointments[i].patientSurname}'] =
            appointments[i].appointmentTime!.substring(0, 5);
      }
      print(hastalar);

      String getNextAppointment(List<String> appointments) {
        for (String appointment in appointments) {
          final appointmentTime = DateTime.parse('2023-01-01 $appointment');

          if (appointmentTime.isAfter(DateTime.now())) {
            return appointment;
          }
        }

        return 'There is no appointment'; // No upcoming appointments
      }

      print('next appointment');
      print(getNextAppointment(appointmentTimes));

      userService.getProfilePic().then((value) {
        setState(() {
          user = value;
        });
        try {
          profilePic = user!.picture!;
        } catch (e) {}
      });
    });
    noteService.getDailyNotes(date).then((value) {
      setState(() {
        notes = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                        profilePic.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(profilePic),
                              )
                            : const Icon(Icons.person)
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
                  ' Next Appointment ',
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
                          void getNextAppointment(List<String> randevu) {
                            List<String> listWithoutDuplicates =
                                randevu.toSet().toList();

                            for (String appointment in listWithoutDuplicates) {
                              final now = DateTime.now();
                              final dateFormat = DateFormat('yyyy-MM-dd');
                              final appointmentTime = DateTime.parse(
                                  '${dateFormat.format(now)} $appointment');

                              if (appointmentTime.isAfter(DateTime.now())) {
                                for (var entry in hastalar.entries) {
                                  if (entry.value == appointment) {
                                    patientName = entry.key;
                                    randevuSaat = appointment;
                                    return entry.key;
                                  }
                                }
                              }
                            }
                          }

                          getNextAppointment(appointmentTimes);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              patientName != null
                                  ? _buildItem('${patientName}',
                                      '${randevuSaat} ', Color(0xff0074ff))
                                  : _buildItem(string, ' ', Color(0xff0074ff)),
                              _buildDivider(),
                              _buildItem(
                                  "${appointments[index].status!}",
                                  "${appointments.length} Patients",
                                  Color(0xffff1759)),
                            ],
                          );
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          patientName != null
                              ? _buildItem('${patientName}', '${randevuSaat} ',
                                  Color(0xff0074ff))
                              : _buildItem(string, ' ', Color(0xff0074ff)),
                          _buildDivider(),
                          _buildItem(
                              "There is no appointments",
                              "${appointments.length} Patients",
                              Color(0xffff1759)),
                        ],
                      ),
                Config.spaceSmall,
                const Text(
                  ' Notes ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                notes.length==0 ? 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:88),
                  child: Container(
                   decoration: BoxDecoration(
                     color:FitnessAppTheme.nearlyDarkBlue.withOpacity(0.6),
                     //backgroundBlendMode:BlendMode.lighten,
                     borderRadius: BorderRadius.circular(10),
                     gradient: LinearGradient(colors:firstContainer)
                   ),
                   height:Config.heightSize * 0.15,
                   width: Config.screenWidth! * 0.5,
                   child:InkWell(
                     onTap: (){
                       Navigator.pushNamed(context,'/note');
                     },
                     child: Icon(Icons.add,size:Config.heightSize * 0.07,color: FitnessAppTheme.nearlyWhite,)
                   ) ,
                  ),
                ) :SizedBox(
                           height: Config.heightSize * 0.15,
                           child: ListView.builder(
                             shrinkWrap: true,
                             itemCount: notes.length,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (context, index) {
                               return Card(
                                 shape: BeveledRectangleBorder(
                                     borderRadius: BorderRadius.circular(10)),
                                 margin: const EdgeInsets.only(right: 20),
                                 color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(
                                       horizontal: 15, vertical: 10),
                                   child: Row(
                                     mainAxisAlignment:
                                         MainAxisAlignment.spaceAround,
                                     children: <Widget>[
                                       Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(
                                             notes[index].note!,
                                             style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 18),
                                           ),
                                           Text(notes[index].date!,textAlign: TextAlign.end,)
                                         ],
                                       ),
                                       
                                     ],
                                   ),
                                 ),
                               );
                             },
                           )),
                Config.spaceSmall,
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
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/show-appointment');
                        },
                        child: Text('See All'))
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
                                      leading:
                                          appointments[index].picture == null
                                              ? Image.asset(
                                                  'assets/images/user.png')
                                              : ClipOval(
                                                  child: Image.network(
                                                      '${appointments[index].picture}'),
                                                ),
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
              ])),
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
                          fontSize: 13,
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
