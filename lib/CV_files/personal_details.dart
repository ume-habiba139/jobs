import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobs/CV_files/cv_format.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UploadP_Details());
}

class UploadP_Details extends StatelessWidget {
  const UploadP_Details({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget3(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class YourWidget3 extends StatefulWidget {
  @override
  _YourWidgetState3 createState() => _YourWidgetState3();
}

class _YourWidgetState3 extends State<YourWidget3> {
  File? _imageFile;
  TextEditingController descriptionController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Personal Details",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputLayoutWidget(
                      hintText: 'Name',
                      controller: _nameController,
                    ),
                    SizedBox(height: 20),
                    TextInputLayoutWidget(
                      hintText: 'Address',
                      controller: _addressController,
                    ),
                    SizedBox(height: 20),
                    TextInputLayoutWidget(
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    SizedBox(height: 20),
                    TextInputLayoutWidget(
                      hintText: 'phone',
                      controller: _phoneController,
                    ),
                    SizedBox(height: 20),
                    TextInputLayoutWidget(
                      hintText: 'Date of Birth',
                      controller: _dateController,
                    ),
                    SizedBox(height: 20),
                    TextInputLayoutWidget(
                      hintText: 'Website(optional)',
                      controller: _websiteController,
                    ),
                    SizedBox(height: 20),
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
                        SizedBox(width: 10),
                        const Text(
                          'Attach a picture(optional)',
                          style: TextStyle(
                              fontSize: 20, color: AppColors.customPurple),
                        ),
                      ],
                    ),
                    SizedBox(height: 70),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveToDatabase,
                        child: Text(
                          'Save information',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.customPurple,
                          fixedSize: const Size(300, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _saveToDatabase() async {
    // Upload image to Firebase Storage
    if (_imageFile != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/$fileName.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Upload data to Firebase Realtime Database under "P-Details" node
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('P-Details').push();
      databaseRef.set({
        'imageURL': downloadURL,
        'Name': _nameController.text,
        'Address': _addressController.text,
        'Email': _emailController.text,
        'phone': _phoneController.text,
        'Date of Birth': _dateController.text,
        'Website(optional)': _websiteController.text,
      });

      // Clear fields
      setState(() {
        _imageFile = null;
        _nameController.clear();
        _addressController.clear();
        _emailController.clear();
        _phoneController.clear();
        _dateController.clear();
        _websiteController.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save Successful'),
          duration: Duration(seconds: 1), // Adjust the duration as per your requirement
        ),
      );
       Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      });
    }
  }
}

class TextInputLayoutWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const TextInputLayoutWidget({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
