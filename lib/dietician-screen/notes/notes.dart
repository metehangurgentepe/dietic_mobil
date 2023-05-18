import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';

import '../../config/theme/theme.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});
  static const String routeName = '/note';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => NoteScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
        backgroundColor: AppColors.colorAccent,
        actions: [
          IconButton(
              onPressed: () {
                _popUp();
              },
              icon: Icon(Icons.add_box))
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 200,
          child: Center(
            child: GFListTile(
              color: AppColors.colorBackColor,
              title: Text('Note title'),
              titleText: 'hastanın diyet planını yap ve hastalıklarını araştır',
              description: Text('Yapılması planlanan zaman: 18 Mayıs'),
            ),
          ),
        )
      ]),
    );
  }

  void _popUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Note'),
            content: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text('Note'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.green, // Set the enabled border color
                    width: 2.0, // Set the enabled border width
                  ),
                ),
              ),
              controller: noteController,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
