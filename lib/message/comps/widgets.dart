import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:dietic_mobil/message/comps/animated-dialog.dart';
import 'package:dietic_mobil/message/comps/styles.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/theme/theme.dart';

class ChatWidgets {
  static Widget card({title, time, subtitle, onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Card(
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(5),
          leading: const Padding(
            padding: EdgeInsets.all(0.0),
            child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                )),
          ),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(time),
          ),
        ),
      ),
    );
  }

  static Widget circleProfile({onTap, name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(
                width: 50,
                child: Center(
                    child: Text(
                  name,
                  style:
                      TextStyle(height: 1.5, fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                )))
          ],
        ),
      ),
    );
  }

  static Widget messagesCard(bool check, message, time) {
    var _isUrl = false;
    bool isURL(String message) {
      RegExp urlRegex = RegExp(
          r"^(http(s)?:\/\/)?[\w.-]+\.[a-zA-Z]{2,}(\/)?([\w-]+)?(\.[\w-]+)*(\/([\w-]+)\/)*([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$");
      return urlRegex.hasMatch(message);
    }

    if (isURL(message)) {
      print('This is a URL.');
      _isUrl = true;
    } else {
      print('This is not a URL.');
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          if (!check)
            const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
              radius: 10,
            ),
          _isUrl
              ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.grey[700],
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10),
                right: Radius.circular(10),
              ),
            ),



                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                    Image.network(
                    message,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                        Padding(padding: EdgeInsets.all(5),child:(
                            Text('$time',style: TextStyle(color: Colors.white,))))


    ]))
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '$message\n\n$time',
                      style:
                          TextStyle(color: check ? Colors.white : Colors.black),
                    ),
                    decoration: Styles.messagesCardStyle(check),
                  ),
                ),
          if (check)
            const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
              radius: 10,
            ),
          if (!check) const Spacer(),
        ],
      ),
    );
  }

  static messageField({required onSubmit}) {
    final storage = FlutterSecureStorage();
    final con = TextEditingController();
    return Container(
      margin: const EdgeInsets.all(5),
      child: TextField(
        decoration: Styles.messageTextFieldStyle(onSubmit: () async {
          String? value = await storage.read(key: 'imageUrl');
          var imageUrl = TextEditingController();
          imageUrl.text = value!;
          if (value.isNotEmpty) {
            onSubmit(imageUrl);
          } else {
            onSubmit(con);
          }
        }),
        controller: con,
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }

  static drawer(context) {
    return Drawer(
      backgroundColor: Colors.indigo.shade400,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
          child: Theme(
            data: ThemeData.dark(),
            child: Column(
              children: [
                const CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                  radius: 60,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async => await FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static searchBar(
    bool open,
  ) {
    return AnimatedDialog(
      height: open ? 800 : 0,
      width: open ? 400 : 0,
    );
  }

  static searchField({Function(String)? onChange}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        onChanged: onChange,
        decoration: Styles.searchTextFieldStyle(),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }
}
