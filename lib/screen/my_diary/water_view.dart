import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/theme/fitness_app_theme.dart';
import '../../hexColor.dart';
import '../../ui_view/wave_view.dart';

class WaterView extends StatefulWidget {
  const WaterView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _WaterViewState createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  String? email;
  Timestamp? time;

  final firestore = FirebaseFirestore.instance;

  // Future<void> postWaterData(String userId, double waterAmount) async {
  //   final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
  //   await _database.child('users/$userId/water').add().set({
  //     'amount': waterAmount,
  //     'timestamp': timestamp,
  //   });
  // }
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    getEmail() async {
      email = await storage.read(key: 'email');
    }

    getEmail();
    super.initState();
  }

  int water = 0;
  int localWater = 0;
  double percentWater = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder(
                            stream: firestore.collection('Water').snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              DateTime date = DateTime.now();
                              List data = !snapshot.hasData
                                  ? []
                                  : snapshot.data!.docs
                                      .where((element) => element['email']
                                          .toString()
                                          .contains(FirebaseAuth
                                              .instance.currentUser!.uid))
                                      .toList();
                              for (int i = 0; i < 1; i++) {
                                time = data[i]['datetime'];
                                if (time!.toDate().day == date.day) {
                                  localWater = data[i]['water'];
                                  water = data[i]['water'];
                                  percentWater = ((water / 2500) * 100);
                                } else {
                                  time = null;
                                }
                              }
                              //water=data[0];
                              return Column(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, bottom: 3),
                                            child: Text(
                                              '${water}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 32,
                                                color: FitnessAppTheme
                                                    .nearlyDarkBlue,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, bottom: 8),
                                            child: Text(
                                              'ml',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                letterSpacing: -0.2,
                                                color: FitnessAppTheme
                                                    .nearlyDarkBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 2, bottom: 14),
                                        child: Text(
                                          'of daily goal 2.5L',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4, top: 8, bottom: 16),
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: FitnessAppTheme.background,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Icon(
                                                Icons.access_time,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                                size: 16,
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: time == null
                                                    ? Container()
                                                    : Text(
                                                        'Last drink ${time!.toDate().toString().substring(10, 16)}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          letterSpacing: 0.0,
                                                          color: FitnessAppTheme
                                                              .grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      )),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Image.asset(
                                                    'assets/fitness_app/bell.png'),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Your bottle is empty, refill it!.',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    color: HexColor('#F65283'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        width: 34,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyDarkBlue
                                          .withOpacity(0.4),
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    water += 100;
                                    postWaterData(water);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyDarkBlue
                                          .withOpacity(0.4),
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    water -= 100;
                                    if (water < 0) {
                                    } else {
                                      postWaterData(water);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 8, top: 16),
                        child: Container(
                          width: 60,
                          height: 160,
                          decoration: BoxDecoration(
                            color: HexColor('#E8EDFE'),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                                bottomLeft: Radius.circular(80.0),
                                bottomRight: Radius.circular(80.0),
                                topRight: Radius.circular(80.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4),
                            ],
                          ),
                          child: StreamBuilder(
                              stream: firestore.collection('Water').snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                DateTime date = DateTime.now();

                                List data = !snapshot.hasData
                                    ? []
                                    : snapshot.data!.docs
                                        .where((element) => element['email']
                                            .toString()
                                            .contains(FirebaseAuth
                                                .instance.currentUser!.uid))
                                        .toList();
                                for (int i = 0; i < 1; i++) {
                                  time = data[i]['datetime'];
                                  if (time!.toDate().day == date.day) {
                                    localWater = data[i]['water'];
                                    water = data[i]['water'];
                                    percentWater = ((water / 2500) * 100);
                                  } else {
                                    time = null;
                                  }
                                }
                                return WaveView(
                                  percentageValue: (water / 2500) * 100,
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  postWaterData(int waterData) async {
    String? email = await storage.read(key: 'email');
    Map<String, dynamic> data = {
      'email': email,
      'water': waterData,
      'datetime': DateTime.now()
    };
    storage.write(key: 'water', value: waterData.toString());
    try {
      firestore.collection('Water').doc(email).set(data);
    } catch (e) {}
  }
}
