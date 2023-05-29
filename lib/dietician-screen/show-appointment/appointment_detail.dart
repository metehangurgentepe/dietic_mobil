import 'package:Dietic/model/get_appointment.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../../config/theme/theme.dart';

class AppointmentDetailScreen extends StatefulWidget {
  static const String routeName = '/appointment-detail';

  static Route route({required GetAppointmentModel randevu}) {
    return MaterialPageRoute(
        builder: (_) => AppointmentDetailScreen(randevu: randevu),
        settings: const RouteSettings(name: routeName));
  }

  const AppointmentDetailScreen({Key? key, required this.randevu})
      : super(key: key);
  final GetAppointmentModel randevu;
  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Detail'),
        backgroundColor: AppColors.colorAccent,
      ),
      body: Column(children: [
        Text(''+widget.randevu.appointmentId.toString()),
        Text(widget.randevu.appointmentTime.toString()),
        Text('Dietitan Name:'+widget.randevu.dietitianId.toString()),
        Text('Randevu:'+widget.randevu.status.toString()),



        
        ]),
    );
  }
}
