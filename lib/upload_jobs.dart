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
  runApp(const UploadJobs());
}

class UploadJobs extends StatelessWidget {
  const UploadJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Signup(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Colors.white;
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
  static const Color black = Colors.black;
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? _selectedJobCategory;
  File? _imageFile;
  TextEditingController _jobName = TextEditingController();
  TextEditingController jobGradeController = TextEditingController();
  TextEditingController salaryPackageController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController selectedJobCategoryController = TextEditingController();
  bool _isUploading = false; // Flag to track upload status

  List<String> jobCategories = [
    "Freelance projects",
    "Jobs By industries",
    "Jobs By company",
    "Jobs By Industries",
    "Jobs BY City",
    "Latest Featured Jobs",
    "Call Center Services",
    " Counter Software ",
    "Employment Firms",
    "Lahore",
    "Jobs By Functional area",
    "Information Technology",
    "Zones IT Solutions",
    "Islamabad",
    "Faisalabad",
    "Business Development",
    "Manufacturing",
    "Example 3",
    " United Nations Pakistan",
    "Karachi",
    "Financial Services",
    "Services",
    "Amet Consectetur",
    " Professional Employers",
    "Islamabad",
    "None"
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // Get device width
    double height = MediaQuery.of(context).size.height; // Get device height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Create Account",
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.9,
                  child: TextFormField(
                    controller: _jobName,
                    decoration: InputDecoration(
                      hintText: "Job Name",
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.customb,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.9,
                  child: TextFormField(
                    controller: jobGradeController,
                    decoration: InputDecoration(
                      hintText: "Job Grade",
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.customb,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.9,
                  child: TextFormField(
                    controller: salaryPackageController,
                    decoration: InputDecoration(
                      hintText: "Salary Package",
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.customb,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.9,
                  child: TextFormField(
                    controller: qualificationController,
                    decoration: InputDecoration(
                      hintText: "Qualification Required",
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.customb,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.9,
                  child: TextFormField(
                    controller: selectedJobCategoryController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Select job Category",
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.customb,
                    ),
                    onTap: () {
                      _showJobCategoryDialog(context);
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.9,
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Description",
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.customb,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
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
                    const SizedBox(width: 30),
                    const Text(
                      'Attach a picture',
                      style: TextStyle(fontSize: 20, color: AppColors.customPurple),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _validateAndUpload, // Disable button if already uploading
                    child: _isUploading ? CircularProgressIndicator() : const Text(
                      "Upload",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customPurple,
                      minimumSize: Size(width * 0.9, 57),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showJobCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Job Category'),
          children: jobCategories.map((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                setState(() {
                  _selectedJobCategory = category;
                  selectedJobCategoryController.text = category;
                });
                Navigator.pop(context);
              },
              selected: _selectedJobCategory == category,
            );
          }).toList(),
        );
      },
    );
  }

  void _validateAndUpload() async {
    setState(() {
      _isUploading = true; // Set uploading flag to true
    });

    if (_imageFile == null) {
      // Show an alert dialog if no image is uploaded
      _showAlertDialog('Upload Error', 'Please upload an image.');
      setState(() {
        _isUploading = false; // Set uploading flag to false
      });
      return;
    }
    if (_selectedJobCategory == null) {
      // Show an alert dialog if no job category is selected
      _showAlertDialog('Upload Error', 'Please select a job category.');
      setState(() {
        _isUploading = false; // Set uploading flag to false
      });
      return;
    }
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('jobs').push();
      databaseRef.set({
        'jobName': _jobName.text,
        'jobCategory': _selectedJobCategory,
        'description': descriptionController.text,
        'job Grade': jobGradeController.text,
        'salary Package': salaryPackageController.text,
        'Qulification': qualificationController.text,
        'imageURL': downloadURL,
      });

      // Show a SnackBar to indicate successful upload
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload successful'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to the same screen after a delay
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShowUploadedData(),
          ),
        );
      });
    } catch (e, stackTrace) {
      print('Unexpected Error: $e');
      print(stackTrace);
      _showAlertDialog('Error', 'Unexpected error occurred.');
    } finally {
      setState(() {
        _isUploading = false; // Set uploading flag to false regardless of success or failure
      });
    }
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
