import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jobs/CV_files/Achievements.dart';
import 'package:jobs/CV_files/Activities.dart';
import 'package:jobs/CV_files/Additional.dart';
import 'package:jobs/CV_files/Interests.dart';
import 'package:jobs/CV_files/Language.dart';
import 'package:jobs/CV_files/education.dart';
import 'package:jobs/CV_files/exper.dart';
import 'package:jobs/CV_files/fetchCV.dart';
import 'package:jobs/CV_files/object.dart';
import 'package:jobs/CV_files/personal_details.dart';
import 'package:jobs/CV_files/projects.dart';
import 'package:jobs/CV_files/refer.dart';
import 'package:jobs/CV_files/skill.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> selectedSections = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curriculum vitae',style:TextStyle(color: AppColors.white
        ,fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.customPurple,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PickScreen()),
              );
              // Navigate to view CV page or perform any action
            },
          ),
        ],
      ),
      backgroundColor: AppColors.customb,
      body: Column(
        children: [
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSimpleContainer(
                'Details',
                Icons.person,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadP_Details()),
                  );
                },
              ),
              _buildSimpleContainer(
                'Education',
                Icons.cast_for_education,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Uploadedu()),
                  );
                },
              ),
              _buildSimpleContainer(
                'Experiences',
                Icons.work,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Uploadexper()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSimpleContainer(
                'Skills',
                Icons.star,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadSkill()),
                  );
                },
              ),
              _buildSimpleContainer(
                'Objective',
                Icons.lightbulb,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadOBJ()),
                  );
                },
              ),
              _buildSimpleContainer(
                'Reference',
                Icons.person,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UploadRefer()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          _buildSectionsRow(selectedSections),
          SizedBox(height: height * 0.025),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.1),
                child: Text(
                  'More Sections:',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.1),
                child: InkWell(
                  onTap: () async {
                    final List<String> result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddSectionsScreen(selectedSections)),
                    );
                    if (result != null) {
                      setState(() {
                        selectedSections = result;
                      });
                    }
                  },
                  child: Container(
                    height: height * 0.06,
                    width: width * 0.6,
                    color: AppColors.white,
                    child: Center(
                      child: Text(
                        'Add more sections +',
                        style: TextStyle(
                          color: AppColors.customPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleContainer(String text, IconData iconData, {VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      onDoubleTap: () {
        if (text == 'Projects') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadPro()),
          );
        }
        if (text == 'Additional information') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadINFO()),
          );
        }
        if (text == 'Interests') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Interests()),
          );
        }
        if (text == 'Activities') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Activities()),
          );
        }
        if (text == 'Achievement') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Achievements(deviceID: '',)),
          );
        }
        if (text == 'Language') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Language()),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 30, color: AppColors.customPurple),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.customPurple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionsRow(List<String> sections) {
    List<Widget> sectionWidgets = [];
    List<Widget> currentRowChildren = [];
    for (int i = 0; i < sections.length; i++) {
      if (i % 3 == 0 && i != 0) {
        // Create a new row for every third section
        sectionWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: currentRowChildren,
          ),
        );
        currentRowChildren = [];
      }
      currentRowChildren.add(_buildSimpleContainer(sections[i], Icons.folder));
    }
    if (currentRowChildren.isNotEmpty) {
      // Add the last row if it's not empty
      sectionWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: currentRowChildren,
        ),
      );
    }
    return Column(children: sectionWidgets);
  }
}

class AddSectionsScreen extends StatefulWidget {
  final List<String> selectedSections;

  AddSectionsScreen(this.selectedSections);

  @override
  _AddSectionsScreenState createState() => _AddSectionsScreenState();
}

class _AddSectionsScreenState extends State<AddSectionsScreen> {
  final List<bool> _switchValues = [false, false, false, false, false, false];
  final List<String> _titles = [
    'Additional information',
    'Interests',
    'Activities',
    'Achievement',
    'Language',
    'Projects'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize switch values based on selected sections
    for (int i = 0; i < _titles.length; i++) {
      _switchValues[i] = widget.selectedSections.contains(_titles[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add More Sections"),
        backgroundColor: AppColors.customPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: _titles.map((title) {
            int index = _titles.indexOf(title);
            return buildSwitchRow(title, _switchValues[index], (value) {
              setState(() {
                _switchValues[index] = value;
              });
            });
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pass back selected sections to previous screen
          List<String> selectedSections = [];
          for (int i = 0; i < _titles.length; i++) {
            if (_switchValues[i]) {
              selectedSections.add(_titles[i]);
            }
          }
          Navigator.pop(context, selectedSections);
        },
        backgroundColor: AppColors.customPurple,
        child: const Icon(Icons.check, color: AppColors.white),
      ),
    );
  }

  Widget buildSwitchRow(String title, bool switchValue, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.customb,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          Switch(
            value: switchValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
