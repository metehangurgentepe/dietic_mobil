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
  String picture='';

  bool _clickedButton = false;
  @override
  void initState() {
    service.getPatients().then((value) {
      print(value);
      patients = value;
    });
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
        filteredPatients = patients;
      }
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
                onChanged: (query) => _filterUsers(query),
                decoration: InputDecoration(
                    hintText: 'Search Patients',
                    prefixIcon: Icon(Icons.search),
                    focusColor: AppColors.colorAccent,
                    iconColor: AppColors.colorAccent),
              ),
            ),
            _filteredPatients.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredPatients.length,
                      itemBuilder: (BuildContext context, int index) {
                        // SearchResult result = _searchResults[index];
                        final user = _filteredPatients[index];
                      print('picture');
                        print(user.picture);
                        print('******************');
                        print(_filteredPatients);
                        return GFListTile(
                            radius: 10,
                            shadow:
                                BoxShadow(color: FitnessAppTheme.background),
                            avatar: user.picture=='' ? Icon(Icons.person) : Image.network('${user.picture}',height: 20,),
                            titleText: '${user.name!} ${user.surname!}',
                            subTitleText: user.email,
                            onTap: () {
                              Navigator.pushNamed(context, '/diet-plan-detail',
                                  arguments: patients[index]);
                            });
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredPatients.length,
                      itemBuilder: (BuildContext context, int index) {
                        // SearchResult result = _searchResults[index];
                        final user = patients[index];
                        print('******************');

                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text('${user.name!} ${user.surname!}'),
                          subtitle: Text(user.email!),
                          onTap: () {
                            // Navigate to a detail page when a list tile is tapped
                            // and pass the SearchResult object to the detail page.
                            Navigator.pushNamed(context, '/diet-plan-detail',
                                arguments: patients[index]);
                          },
                        );
                      },
                    ),
                  )
          ]),
        ),
      ),
    );
  }
}
