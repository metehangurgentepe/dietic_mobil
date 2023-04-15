import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dietic_mobil/message/Logics/functions.dart';
import 'package:dietic_mobil/message/chatpage.dart';
import 'package:intl/intl.dart';
import '../config/theme/theme.dart';
import 'comps/styles.dart';
import 'comps/widgets.dart';

import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Functions.updateAvailability();
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;
  bool open = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorAccent,
      appBar: AppBar(
        backgroundColor: AppColors.colorAccent,
        title: const Text('Dietic App'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    open == true ? open = false : open = true;
                  });
                },
                icon: Icon(
                  open == true ? Icons.close_rounded : Icons.search_rounded,
                  size: 30,
                )),
          )
        ],
      ),
      drawer: ChatWidgets.drawer(context),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    color: AppColors.colorAccent,
                    padding: const EdgeInsets.all(8),
                    height: 162,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Text(
                            'Recent Users',
                            style: Styles.h1(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 80,
                          child: StreamBuilder(
                            stream:  firestore.collection('Rooms').snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              List data = !snapshot.hasData ? [] : snapshot.data!.docs.where((element) => element['users'].toString().contains(FirebaseAuth.instance.currentUser!.uid)).toList();
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (context, i) {
                                  List users = data[i]['users'];
                                  var friend = users.where((element) => element != FirebaseAuth.instance.currentUser!.uid);
                                  var user = friend.isNotEmpty ? friend.first : users .where((element) => element == FirebaseAuth.instance .currentUser!.uid).first;
                                  return  FutureBuilder(
                                    future: firestore.collection('Users').doc(user).get(),
                                    builder: (context, AsyncSnapshot snap) {
                                      return !snap.hasData? Container(): ChatWidgets.circleProfile(onTap: (){
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ChatPage(
                                                id: user,
                                                name: snap.data['name'],
                                              );
                                            },
                                          ),
                                        );
                                      },name:  snap.data['name']);
                                    }
                                  );
                                },
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: Styles.friendsBox(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text(
                            'Contacts',
                            style: Styles.h1().copyWith(color: AppColors.colorAccent),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: StreamBuilder(
                                stream:
                                    firestore.collection('Rooms').snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  List data = !snapshot.hasData ? [] : snapshot.data!.docs.where((element) => element['users'].toString().contains(FirebaseAuth.instance.currentUser!.uid)).toList();
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      List users = data[i]['users'];
                                      var friend = users.where((element) => element != FirebaseAuth.instance.currentUser!.uid);
                                      var user = friend.isNotEmpty ? friend.first : users .where((element) => element == FirebaseAuth.instance .currentUser!.uid).first;
                                      var lastMessage =data[i]['last_message'];


                                      return FutureBuilder(
                                        future: firestore.collection('Users').doc(user).get(),
                                        builder: (context,AsyncSnapshot snap) {
                                          return !snap.hasData? Container(): ChatWidgets.card(
                                            title: snap.data['name'],
                                            subtitle:Uri.tryParse(lastMessage)!.hasAbsolutePath ?
                                              'Photo' :
                                            lastMessage,
                                            time: DateFormat('hh:mm a').format(data[i]['last_message_time'].toDate()),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ChatPage(
                                                      id: user,
                                                      name: snap.data['name'],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ChatWidgets.searchBar(open)
          ],
        ),
      ),
    );
  }
}
