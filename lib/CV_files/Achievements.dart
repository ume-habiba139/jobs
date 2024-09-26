import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jobs/CV_files/cv_format.dart'; // Import the correct file

class Achievements extends StatelessWidget {
  final String deviceID; // Add deviceID parameter

  const Achievements({Key? key, required this.deviceID}) : super(key: key); // Update constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget13(deviceID: deviceID), // Pass deviceID to YourWidget13
    );
  }
}

class YourWidget13 extends StatefulWidget {
  final String deviceID; // Add deviceID parameter

  const YourWidget13({Key? key, required this.deviceID}) : super(key: key); // Update constructor

  @override
  _YourWidgetState13 createState() => _YourWidgetState13();
}


class _YourWidgetState13 extends State<YourWidget13> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _skillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Achievements",
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
              hintText: 'Details..',
              controller: _skillController,
            ),
            SizedBox(height: height * 0.05),
            Center(
              child: ElevatedButton(
                onPressed: _saveToDatabase,
                child: Text(
                  'Save Achievements Information',
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
    DatabaseReference cvRef = _database.child('CV_Achievements');

    Map<String, dynamic> achievementsInfo = {
      'Achievements': _skillController.text,
    };

    cvRef.push().set(achievementsInfo).then((value) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save Successful'),
          duration: Duration(seconds: 1), // Adjust the duration as per your requirement
        ),
      );

      // Navigate to CV Format screen
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
          duration: Duration(seconds: 2), // Adjust the duration as per your requirement
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

