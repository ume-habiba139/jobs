import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobs/CV_files/cv_format.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UploadOBJ());
}

class UploadOBJ extends StatelessWidget {
  const UploadOBJ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget2(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class YourWidget2 extends StatefulWidget {
  @override
  _YourWidgetState2 createState() => _YourWidgetState2();
}

class _YourWidgetState2 extends State<YourWidget2> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _objecteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Objectives",
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
            SizedBox(height: screenHeight * 0.02),
            TextInputLayoutWidget(
              hintText: 'Objectives',
              controller: _objecteController,
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: ElevatedButton(
                onPressed: _saveToDatabase,
                child: Text(
                  'Save Objective Information',
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
    DatabaseReference cvRef = _database.child('CV_Objective');

    Map<String, dynamic> objectiveInfo = {
      'Objectives': _objecteController.text,
    };

    cvRef.push().set(objectiveInfo).then((value) {
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
