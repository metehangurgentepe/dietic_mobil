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

class ShowAppointment extends StatefulWidget {
  static const String routeName = '/show-appointment';
  const ShowAppointment({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ShowAppointment(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ShowAppointment> createState() => _ShowAppointmentState();
}

class _ShowAppointmentState extends State<ShowAppointment> {
  List<int> patient_id = [];
  List<String> appointmentTime = [];
  List<GetAppointmentModel> randevu = [];
  final service = AppointmentService();
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    service.getAppointment().then((value) {
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
      appBar: AppBar(title: Text('Appointments'),backgroundColor: AppColors.colorAccent,),
        body: SafeArea(
      child: ListView.builder(
          itemCount: randevu.length,
          itemBuilder: (BuildContext context, int index) {   
            return InkWell(onTap: (){
Navigator.pushNamed(
          context, 
          '/appointment-detail', 
          arguments: randevu[index],
        );            },
            child:ListTile(
              title: Text('${randevu[index].patientId} burada isim olcak' ?? ' '),
              subtitle: Text('${randevu[index].appointmentTime} ${randevu[index].appointmentDate}' ?? ' '),
              leading: Text('${randevu[index].status}'),
            ));
          }),
    ));
  }
}
