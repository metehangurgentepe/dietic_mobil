import 'package:dietic_mobil/config/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/patient_detail.dart';
import '../../service/get_patients/get_patients_service.dart';

class ChoosePatientScreen extends StatefulWidget {
  const ChoosePatientScreen({super.key});
  static const String routeName = '/choose_patient';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ChoosePatientScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ChoosePatientScreen> createState() => _ChoosePatientScreenState();
}

class _ChoosePatientScreenState extends State<ChoosePatientScreen> {
  final service=GetPatientService();
  List<PatientModel> patients=[];


  @override
  void initState() {
    service.getPatients().then((value){
      setState(() {
        print(value);
      patients=value;
      });
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Patient'),
        backgroundColor: AppColors.colorAccent,
      ),
      body: 
    patients.isNotEmpty? SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: patients.length,
        itemBuilder: (context,index){
          return InkWell(
            child: Column(
              children: [
                ListTile(
                  title: Text('${patients[index].name} ${patients[index].surname}'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('age:${patients[index].age}'),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                Divider(height: 10,)
              ],
            ),
            onTap: () => Navigator.pushNamed(context,'/dyt_appointment',arguments: patients[index].patientId),
          );
    
      })) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 118.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.person,size: 200),
            Text('There is no patient attached to you',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          ],
        ),
      )
    );
  }
}