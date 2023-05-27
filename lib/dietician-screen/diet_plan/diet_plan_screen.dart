import 'package:dietic_mobil/config/theme/fitness_app_theme.dart';
import 'package:dietic_mobil/service/get_patients/get_patients_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../config/theme/theme.dart';
import '../../model/patient_detail.dart';

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({Key? key}) : super(key: key);

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final service = GetPatientService();
  var _searchWord;
  List<PatientModel> patients = [];
  List<PatientModel> _filteredPatients = [];
  String picture = '';

  bool _clickedButton = false;

  bool empty = true;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    service.getPatients().then((value) {
      patients = value;
    });
    _filterUsers(' ');
    super.initState();
  }

  void _filterUsers(String query) {
    List<PatientModel> filteredPatients = [];
    setState(() {
      if (query.isNotEmpty) {
        for (var user in patients) {
          if (user.name != null) {
            if (user.name!.toLowerCase().contains(query.toLowerCase()) ||
                user.surname!.toLowerCase().contains(query.toLowerCase())) {
              filteredPatients.add(user);
            }
          }
        }
      } else {
        print(patients);
        print('patients');
        filteredPatients = patients;
      }
      print('patients');
      _filteredPatients = filteredPatients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plan'),
        backgroundColor: AppColors.colorAccent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 1000,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: TextField(
                onChanged: (query) {
                  empty=false;
                  _filterUsers(query);
                },
                controller: searchController,
                decoration: InputDecoration(
                    hintText: 'Search Patients',
                    prefixIcon: Icon(Icons.search),
                    focusColor: AppColors.colorAccent,
                    iconColor: AppColors.colorAccent),
              ),
            ),
               empty ?  
               Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: patients.length,
                      itemBuilder: (BuildContext context, int index) {
                        print('object');
                        // SearchResult result = _searchResults[index];
                        print('user');
                        var user=patients[index];
                        return GFListTile(
                            radius: 10,
                            shadow:
                                BoxShadow(color: FitnessAppTheme.background),
                            avatar: (user.picture == null || user.picture == '')
                                ? Icon(Icons.person)
                                : Image.network(
                                    '${user.picture}',
                                    height: 20,
                                  ),
                            titleText: '${user.name!} ${user.surname!}',
                            subTitleText: user.email,
                            onTap: () {
                              Navigator.pushNamed(context, '/diet-plan-detail',
                                  arguments: patients[index]);
                            });
                      },
                    ),
                  )
               :Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredPatients.length,
                      itemBuilder: (BuildContext context, int index) {
                        print('object');
                        // SearchResult result = _searchResults[index];
                        var user=_filteredPatients[index];
                        return GFListTile(
                            radius: 10,
                            shadow:
                                BoxShadow(color: FitnessAppTheme.background),
                            avatar: (user.picture == null || user.picture == '')
                                ? Icon(Icons.person)
                                : Image.network(
                                    '${user.picture}',
                                    height: 20,
                                  ),
                            titleText: '${user.name!} ${user.surname!}',
                            subTitleText: user.email,
                            onTap: () {
                              Navigator.pushNamed(context, '/diet-plan-detail',
                                  arguments: patients[index]);
                            });
                      },
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
