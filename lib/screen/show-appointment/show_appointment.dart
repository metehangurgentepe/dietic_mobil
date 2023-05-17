import 'package:dietic_mobil/model/get_appointment.dart';
import 'package:dietic_mobil/model/get_appointment_for_dietitian.dart';
import 'package:dietic_mobil/screen/appointment/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import '../../config/theme/theme.dart';
import '../../service/appointment/appointment_service.dart';

class ShowPatientAppointment extends StatefulWidget {
  static const String routeName = '/show-appointment-patient';
  const ShowPatientAppointment({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ShowPatientAppointment(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ShowPatientAppointment> createState() => _ShowPatientAppointmentState();
}

class _ShowPatientAppointmentState extends State<ShowPatientAppointment> {
  List<int> patient_id = [];
  List<String> appointmentTime = [];
  List<GetAppointmentModel> randevu = [];
  final service = AppointmentService();
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    service.getPatientAppointment().then((value) {
      randevu = value;
      setState(() {
        if (randevu != null) {
          // for (int i = 0; i < randevu.length; i++) {
          //   patient_id[i] = randevu[i].patientId!;
          //   appointmentTime[i] = randevu[i].appointmentTime!;
          // }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
          backgroundColor: AppColors.colorAccent,
        ),
        body: SafeArea(
          child: ListView.builder(
              itemCount: randevu.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      // Navigator.pushNamed(
                      //           context,
                      //           '/appointment-detail',
                      //           arguments: randevu[index],
                      //         );
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top:Radius.circular(20)
                        )),
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(
                                    'Appointment',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Dietitian Name: '),
                                      Text(
                                        '${randevu[index].dietitianName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Appointment Time: '),
                                      Text(
                                        '${randevu[index].appointmentTime!.substring(0, 5)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Appointment Date: '),
                                      Text(
                                        '${randevu[index].appointmentDate!.replaceAll('-', ' ')}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Appointment Status: '),
                                      Text(
                                        '${randevu[index].status}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(28.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.colorAccent
                                        ),
                                        
                                          onPressed: () {
                                            service.updateStatus(randevu[index]);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Appointment Cancel')),
                                    )),
                              ],
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[200]),
                        child: ListTile(
                          title: Text(
                              '${randevu[index].dietitianName} ',style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                              ' ${randevu[index].appointmentDate!.replaceAll('-', '/')}' ??
                                  ' '),
                          leading: Icon(
                            Icons.notifications,
                            size: 35,
                          ),
                          trailing: Text(
                              '${randevu[index].appointmentTime!.substring(0, 5)}'),
                        ),
                      ),
                    ));
              }),
        ));
  }
}
