import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobs/CV_files/cv_format.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UploadSkill());
}

class UploadSkill extends StatelessWidget {
  const UploadSkill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget6(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class YourWidget6 extends StatefulWidget {
  @override
  _YourWidgetState6 createState() => _YourWidgetState6();
}

class _YourWidgetState6 extends State<YourWidget6> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _skillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Skills",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white, // Setting background color to white
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextInputLayoutWidget(
                hintText: 'Skills',
                controller: _skillController,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveToDatabase,
                  child: Text(
                    'Save Skills Information',
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
      ),
    );
  }

  void _saveToDatabase() {
    DatabaseReference cvRef = _database.child('CV_Skills');

    Map<String, dynamic> skillsInfo = {
      'Skills': _skillController.text,
    };

    cvRef.push().set(skillsInfo);

    // Clear the text field after saving
    _skillController.clear();

    // Show a snackbar to indicate successful save
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Skills information saved successfully.'),
        duration: Duration(seconds: 2), // Adjust as needed
      ),
    );
     Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
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
