import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobs/CV_files/cv_format.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UploadRefer());
}

class UploadRefer extends StatelessWidget {
  const UploadRefer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourWidget5(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class YourWidget5 extends StatefulWidget {
  @override
  _YourWidgetState5 createState() => _YourWidgetState5();
}

class _YourWidgetState5 extends State<YourWidget5> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: const Text(
          "Reference",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextInputLayoutWidget(
                hintText: 'Reference Name',
                controller: _nameController,
              ),
              SizedBox(height: 20),
              TextInputLayoutWidget(
                hintText: 'Job Title',
                controller: _jobController,
              ),
              SizedBox(height: 20),
              TextInputLayoutWidget(
                hintText: 'Company Name',
                controller: _companyController,
              ),
              SizedBox(height: 20),
              TextInputLayoutWidget(
                hintText: 'Email',
                controller: _emailController,
              ),
              SizedBox(height: 20),
              TextInputLayoutWidget(
                hintText: 'Phone',
                controller: _phoneController,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveToDatabase,
                  child: Text(
                    'Save Reference Information',
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
    DatabaseReference cvRef = _database.child('CV_Reference');

    Map<String, dynamic> referenceInfo = {
      'Reference Name': _nameController.text,
      'Job Title': _jobController.text,
      'Company Name': _companyController.text,
      'Email': _emailController.text,
      'Phone': _phoneController.text,
    };

    cvRef.push().set(referenceInfo);

    // Clear fields after saving
    _nameController.clear();
    _jobController.clear();
    _companyController.clear();
    _emailController.clear();
    _phoneController.clear();

    // Show a snackbar to indicate successful save
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reference information saved successfully.'),
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
