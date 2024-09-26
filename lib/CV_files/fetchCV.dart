import 'package:flutter/material.dart';
import 'package:jobs/CV_files/foramt4.dart';
import 'package:jobs/CV_files/format1.dart';
import 'package:jobs/CV_files/format2.dart';
import 'package:jobs/CV_files/format3.dart';
import 'package:jobs/CV_files/format5.dart';
import 'package:jobs/CV_files/format6.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PickScreen(),
    );
  }
}

class PickScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose format',style: TextStyle(color:Colors.white,
        fontWeight: FontWeight.bold),),
        backgroundColor:  Color.fromARGB(255, 2, 56, 130)
      ),
      backgroundColor: Color.fromARGB(255, 220, 218, 218),
      body: ListView(
        
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppfetch4()),
                      );
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/foramt1.png',
                        fit: BoxFit.contain, // Adjust container size to fit image
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppformat1()),
                      );
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/format2.png',
                        fit: BoxFit.contain, // Adjust container size to fit image
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppfetch2()),
                      );
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/format3.png',
                        fit: BoxFit.contain, // Adjust container size to fit image
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppfetch3()),
                      );
                    },
                    child: Container(
                     
                      child: Image.asset(
                        'assets/images/format4.png',
                        fit: BoxFit.contain, // Adjust container size to fit image
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
             Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppfetch5()),
                      );
                    },
                    child: Container(
                    
                      child: Image.asset(
                        'assets/images/format5.png',
                        fit: BoxFit.contain, // Adjust container size to fit image
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAppfetch6()),
                      );
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/format6.png',
                        fit: BoxFit.contain, // Adjust container size to fit image
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
