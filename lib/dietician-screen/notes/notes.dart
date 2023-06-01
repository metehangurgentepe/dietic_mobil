import 'package:Dietic/config/theme/fitness_app_theme.dart';
import 'package:Dietic/service/notes/note_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getwidget/getwidget.dart';

import '../../config/theme/theme.dart';
import '../../model/note_model.dart';

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
class _NoteScreenState extends State<NoteScreen> with TickerProviderStateMixin {
  final service = NoteService();
  DateTime? _selectedDate;
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<NoteModel> notes = [];
  Function(BuildContext)? deleteFunction;
  ValueNotifier<List<NoteModel>> notesNotifier=ValueNotifier<List<NoteModel>>([]);

  
  @override
  void initState() {
    service.getNotes().then((value) {
      setState(() {
        notes = value;
       notesNotifier=ValueNotifier<List<NoteModel>>(notes);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterGifController controller = FlutterGifController(vsync: this);
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
        body: SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child: ValueListenableBuilder<List<NoteModel>>(
    valueListenable: notesNotifier,
    builder: (context, notes, _) {
      return notes.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Cartoon of businessman thinking hard with pen vector image on VectorStock.jpeg'),
                  SizedBox(height: 10),
                  Text(
                    'There are no notes. Add notes for reminding.',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(motion: StretchMotion(), children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        service.deleteNote(notes[index].noteId!);
                      },
                      icon: Icons.delete,
                      backgroundColor: AppColors.colorWarning,
                    ),
                  ]),
                  child: Container(
                    height: 160,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        GFCard(
                          color: AppColors.colorBackColor,
                          title: GFListTile(
                            color: AppColors.colorBackColor,
                            avatar: GFCheckbox(
                              activeBgColor: FitnessAppTheme.nearlyDarkBlue,
                              value: notes[index].done!,
                              onChanged: (bool? value) {},
                            ),
                            title: Text(notes[index].note!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24, right: 24),
                          child: Text(notes[index].date!.replaceAll('-', '/')),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    },
  ),
));
  }

  void _popUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Note',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FitnessAppTheme.nearlyDarkBlue),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextField(
                  cursorColor: AppColors.colorAccentDark,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: FitnessAppTheme
                            .dark_grey, // Set the enabled border color
                        width: 2.0, // Set the enabled border width
                      ),
                    ),
                  ),
                  controller: noteController,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Date',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FitnessAppTheme.nearlyDarkBlue),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      focusColor: AppColors.colorAccent,
                      fillColor: AppColors.colorAccent,
                      iconColor: AppColors.colorAccent,
                      hoverColor: AppColors.colorAccent,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: FitnessAppTheme.nearlyDarkBlue,
                        ),
                        onPressed: _showDatePicker,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: FitnessAppTheme
                              .dark_grey, // Set the enabled border color
                          width: 2.0, // Set the enabled border width
                        ),
                      )),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: FitnessAppTheme.nearlyDarkBlue),
                  onPressed: () {
                    service.postNote(
                        dateController.text, noteController.text, false);
                        Navigator.pop(context);
                  },
                  child: Text('Add Note')),
            ],
          );
        });
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dateController.text = pickedDate.toString().substring(0, 10);
      });
    }
  }
}
