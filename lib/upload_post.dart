import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobs/show.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UploadPost());
}

class UploadPost extends StatelessWidget {
  const UploadPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadScreen(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Colors.white;
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  TextEditingController descriptionController = TextEditingController();
  bool _isUploading = false; // Flag to track upload status

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Upload Description",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: height * 0.05),
              Container(
                width: width * 0.9,
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Write Post.....",
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColors.customb,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          _imageFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.customb,
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              size: 35,
                              color: AppColors.white,
                            ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  const Text(
                    'Attach a picture',
                    style: TextStyle(fontSize: 20, color: AppColors.customPurple),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                onPressed: _isUploading ? null : _validateAndUpload, // Disable button if already uploading
                child: _isUploading
                    ? CircularProgressIndicator()
                    : const Text(
                        "Upload",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.customPurple,
                  minimumSize: Size(width * 0.9, 57),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndUpload() async {
    setState(() {
      _isUploading = true; // Set uploading flag to true
    });

    if (_imageFile != null) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName.jpg');
        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();

        DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('jobs').push();
        databaseRef.set({
          'post': descriptionController.text,
          'imageURL': downloadURL,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload successful'),
            duration: Duration(seconds: 2),
          ),
        );

        setState(() {
          descriptionController.clear();
          _imageFile = null;
        });

        // Navigate to the show data screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowUploadedData()),
        );
      } catch (e, stackTrace) {
        print('Unexpected Error: $e');
        print(stackTrace);
        _showAlertDialog('Error', 'Unexpected error occurred.');
      }
    } else {
      // Show an alert if no image is uploaded
      _showAlertDialog('Upload Error', 'Please upload an image.');
    }

    setState(() {
      _isUploading = false; // Set uploading flag to false
    });
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
