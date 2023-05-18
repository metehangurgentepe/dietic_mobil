import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

class TakePictureDytScreen extends StatefulWidget {
  const TakePictureDytScreen({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;

  @override
  TakePictureDytScreenState createState() => TakePictureDytScreenState();
}

class TakePictureDytScreenState extends State<TakePictureDytScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String imageUrl = '';
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  final ImagePicker picker = ImagePicker();
// Pick an image.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            String uniqFileName =
                DateTime.now().millisecondsSinceEpoch.toString();
            print('burada****************************************************');
            XFile? picture = await picker.pickImage(source: ImageSource.camera);
            if (picture == null) return;

            print('${picture!.path}');

            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('images');

            Reference referenceImageToUpload =
                referenceDirImages.child(uniqFileName);

            try {
              await referenceImageToUpload.putFile(File(picture!.path));
              imageUrl = await referenceImageToUpload.getDownloadURL();
              print(imageUrl);
              await storage.write(key: 'imageUrl', value: imageUrl);
            } catch (error) {}
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final storage = FlutterSecureStorage();
  final firestore = FirebaseFirestore.instance;
  var roomId;

  DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Column(
          children: [
            Image.file(File(imagePath)),
            StreamBuilder(
              stream: firestore
                  .collection('Rooms')
                  .snapshots(), // Replace with the appropriate stream for reading the image URL
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return ElevatedButton(
                  onPressed: () async {
                    String? userId = await storage.read(key: 'email');
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        String? imageUrl = await storage.read(key: 'imageUrl');
                        List<QueryDocumentSnapshot?> allData = snapshot
                            .data!.docs
                            .where((element) =>
                                element['users'].contains(userId) &&
                                element['users'].contains(
                                    FirebaseAuth.instance.currentUser!.uid))
                            .toList();
                        QueryDocumentSnapshot? data =
                            allData.isNotEmpty ? allData.first : null;
                        if (data != null) {
                          roomId = data.id;
                          print(roomId);
                          print('submit button');
                          print(imageUrl);
                          onSubmit(imageUrl, roomId);
                        }
                      }
                    }
                  },
                  child: Text('Send to message'),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit(String? imageUrl, String roomId) async {
    final firestore = FirebaseFirestore.instance;
    String? userId = await storage.read(key: 'email');
    String? userPatient = await storage.read(key: 'userPatient');
    if (imageUrl != '') {
      if (roomId != null) {
        Map<String, dynamic> data = {
          'message': imageUrl!.trim(),
          'sent_by': FirebaseAuth.instance.currentUser!.uid,
          'datetime': DateTime.now(),
        };
        firestore.collection('Rooms').doc(roomId).update({
          'last_message_time': DateTime.now(),
          'last_message': imageUrl,
        });
        firestore
            .collection('Rooms')
            .doc(roomId)
            .collection('messages')
            .add(data);
      } else {
        Map<String, dynamic> data = {
          'message': imageUrl,
          'sent_by': FirebaseAuth.instance.currentUser!.uid,
          'datetime': DateTime.now(),
        };
        firestore.collection('Rooms').add({
          'users': [
            userPatient,
            FirebaseAuth.instance.currentUser!.uid,
          ],
          'last_message': imageUrl,
          'last_message_time': DateTime.now(),
        }).then((value) async {
          value.collection('messages').add(data);
        });
      }
    }
  }
}
