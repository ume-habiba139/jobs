import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobs/CV_files/cv_format.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Uploadedu());
}

class Uploadedu extends StatelessWidget {
  const Uploadedu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Education",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppColors.white, // Set background color to white
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            TextInputLayoutWidget(
              hintText: 'Course/Degree',
              controller: _courseController,
            ),
            SizedBox(height: height * 0.02),
            TextInputLayoutWidget(
              hintText: 'School/University',
              controller: _schoolController,
            ),
            SizedBox(height: height * 0.02),
            TextInputLayoutWidget(
              hintText: 'Grade/Score',
              controller: _gradeController,
            ),
            SizedBox(height: height * 0.02),
            TextInputLayoutWidget(
              hintText: 'Year',
              controller: _yearController,
            ),
            SizedBox(height: height * 0.05),
            Center(
              child: ElevatedButton(
                onPressed: _saveToDatabase,
                child: Text(
                  'Save Education Information',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.customPurple,
                  minimumSize: Size(300, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveToDatabase() {
    DatabaseReference cvRef = _database.child('CV_Education');

    Map<String, dynamic> educationInfo = {
      'course': _courseController.text,
      'school': _schoolController.text,
      'grade': _gradeController.text,
      'year': _yearController.text,
    };

    cvRef.push().set(educationInfo).then((value) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save Successful'),
          duration: Duration(seconds: 2), // Adjust the duration as per your requirement
        ),
      );

      // Navigate to Next Screen
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      });
    }).catchError((error) {
      // Show error message if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          duration: Duration(seconds: 1), // Adjust the duration as per your requirement
        ),
      );
    });
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
