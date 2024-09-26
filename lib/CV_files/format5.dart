import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:jobs/CV_files/fetchCV.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

void main() async 
{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyAppfetch5());
}

class MyAppfetch5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShowUploadedData(),
    );
  }
}

class AppColors {
  static const white = Color.fromARGB(255, 255, 255, 255);
static const customPurple = Color.fromARGB(255, 2, 56, 130);
}

class ShowUploadedData extends StatefulWidget {
  @override
  _ShowUploadedDataState createState() => _ShowUploadedDataState();
}

class _ShowUploadedDataState extends State<ShowUploadedData> {
  List<Map<dynamic, dynamic>> userDataList = [];
  List<Map<dynamic, dynamic>> objectiveList = [];
  List<Map<dynamic, dynamic>> languageList = [];
  List<Map<dynamic, dynamic>> additionalInfoList = [];
  List<Map<dynamic, dynamic>> activitiesList = [];
  List<Map<dynamic, dynamic>> experienceList = [];
  List<Map<dynamic, dynamic>> interestsList = [];
  List<Map<dynamic, dynamic>> projectsList = [];
  List<Map<dynamic, dynamic>> referenceList = [];
  List<Map<dynamic, dynamic>> skillsList = [];
  List<Map<dynamic, dynamic>> educationList = [];
  List<Map<dynamic, dynamic>> achievementsList = [];

  late String currentUserId;
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    currentUserId = generateOrRetrieveUserId();
    fetchDataForNodes();
  }

  String generateOrRetrieveUserId() {
    String? userId = '';
    if (userId == null || userId.isEmpty) {
      userId = Uuid().v4();
    }
    return userId!;
  }

  Future<void> fetchDataForNodes() async {
    try {
       await fetchNodeData('Additional-Info', additionalInfoList);
      await fetchNodeData('CV_Education', educationList);
      await fetchNodeData('CV_Activities', activitiesList);
       await fetchNodeData('CV_Achievements', achievementsList);
      await fetchNodeData('CV_Experience', experienceList);
      await fetchNodeData('CV_Interests', interestsList);
      await fetchNodeData('CV_Language', languageList);
      await fetchNodeData('CV_Objective', objectiveList);
      await fetchNodeData('CV_Projects', projectsList);
      await fetchNodeData('CV_Reference', referenceList);
      await fetchNodeData('CV_Skills', skillsList);
      await fetchNodeData('P-Details', userDataList);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
Future<void> fetchNodeData(
    String nodeName, List<Map<dynamic, dynamic>> dataList) async {
  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref().child(nodeName);

  DatabaseEvent event = await databaseRef.once();

  if (event.snapshot.value != null) {
    Map<dynamic, dynamic>? data =
        event.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      setState(() {
        dataList.clear();
        data.forEach((key, value) {
          if (value != null && value is Map<dynamic, dynamic>) {
            dataList.add(value);
          }
        });
      });
    }
  }
}

Future<void> generateAndSharePdf(BuildContext context) async {
  final pdf = pdfLib.Document();
  screenWidth = MediaQuery.of(context).size.width;
  pdf.addPage(
  pdfLib.MultiPage(
  pageFormat: PdfPageFormat.a4,
  build: (context) => [
    pdfLib.Row(
      crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
      children: [
        // Left Side Content
        pdfLib.Container(
  width: screenWidth * 0.7,
  color: PdfColor.fromInt(AppColors.customPurple.value),
  padding: pdfLib.EdgeInsets.all(8),
  child: pdfLib.Column(
    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
    children: [
     pdfLib.Container(
      width: 150,
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Personal Details',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
      for (var data in userDataList) ...[
        pdfLib.Padding(
          padding: pdfLib.EdgeInsets.all(8),
          child: pdfLib.Text(
            "Name: ${data['Name'] ?? 'N/A'}",
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
            ),
          ),
        ),
        pdfLib.Padding(
          padding: pdfLib.EdgeInsets.all(8),
          child: pdfLib.Text(
            "Email: ${data['Email'] ?? ''}",
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
            ),
          ),
        ),
        pdfLib.Padding(
          padding: pdfLib.EdgeInsets.all(8),
          child: pdfLib.Text(
            "Address: ${data['Address'] ?? ''}",
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
            ),
          ),
        ),
        pdfLib.Padding(
          padding: pdfLib.EdgeInsets.all(8),
          child: pdfLib.Text(
            "Date of Birth: ${data['Date of Birth'] ?? ''}",
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
            ),
          ),
        ),
        pdfLib.Padding(
          padding: pdfLib.EdgeInsets.all(8),
          child: pdfLib.Text(
            "Website: ${data['Website(optional)'] ?? ''}",
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
            ),
          ),
        ),
        pdfLib.Padding(
          padding: pdfLib.EdgeInsets.all(8),
          child: pdfLib.Text(
            "Phone: ${data['phone'] ?? ''}",
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
            ),
          ),
        ),
        // Add more personal details here...
      ],
      
      // Add space between personal details and objectives
      pdfLib.SizedBox(height: 10),
      
      // Objectives
      pdfLib.Container(
      width: 150,
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Objectives',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
      for (var obj in objectiveList) ...[
        pdfLib.Text(
          '${obj['Objectives']}',
          style: pdfLib.TextStyle(color: PdfColor.fromInt(AppColors.white.value)),
        ),
      ],
    ],
  ),
),

                   
        // Add space between left and right side
        pdfLib.SizedBox(width: 10),
        
       pdfLib.Container(
  width: screenWidth * 0.7,
  child: pdfLib.Column(
    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
    children: [
      // Activities Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
           pdfLib.Container(
      width: 150,
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Activities',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var Activities in activitiesList) ...[
              pdfLib.Text(
                '${Activities['Activities']}',
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ), 
      // Experience Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
            pdfLib.Container(
      width: 150,
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Experience',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var lan in languageList) ...[
              pdfLib.Text(
                "Company Name:${lan['Company Name']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
              pdfLib.Text(
                "Job Title:${lan['Job Title']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
              pdfLib.Text(
                "Details:${lan['Details']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ),
      
      // Additional Information Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
           pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Education',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var lan in educationList) ...[
              pdfLib.Text(
                "course:${lan['course']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
               pdfLib.Text(
                "school:${lan['school']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
               pdfLib.Text(
                "grade:${lan['grade']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
               pdfLib.Text(
                "year:${lan['year']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ),// Add space between sections
      
      // Language Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
              pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Language',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var lan in languageList) ...[
              pdfLib.Text(
                '${lan['Language']}',
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ),
      // Interests Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
             pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Interests',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var lan in languageList) ...[
              pdfLib.Text(
                "Interests:${lan['Interests']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ),
      // Project Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
              pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Project',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var proj in projectsList) ...[
              pdfLib.Text(
                "Project Title:${proj['Project Title']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
              pdfLib.Text(
                "Details:${proj['Details']}",
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ),// Add space between sections
      
      // Reference Container
      pdfLib.Container(
        width: screenWidth * 0.7,
        color: PdfColor.fromInt(AppColors.customPurple.value),
        padding: pdfLib.EdgeInsets.all(8),
        child: pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
             pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Achievements',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
            for (var refer in referenceList) ...[
              pdfLib.Text(
                '${refer['Achievements']}',
                style: pdfLib.TextStyle(color: PdfColors.white),
              ),
            ],
          ],
        ),
      ),
    ],
  ),
),

          ],
        ),
      ]) );
    // Second Page: Additional Information
    pdf.addPage(
      pdfLib.MultiPage(
  pageFormat: PdfPageFormat.a4,
  build: (context) => [
    pdfLib.Container(
      width: 500,
      color: PdfColor.fromInt(AppColors.customPurple.value),
      padding: pdfLib.EdgeInsets.all(8),
      margin: pdfLib.EdgeInsets.only(top: 5),
      child: pdfLib.Column(
        crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
        children: [
            pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Additional information',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
          for (var aditio in additionalInfoList) ...[
            pdfLib.Text(
              '${aditio['Additional information']}',
              style: pdfLib.TextStyle(color: PdfColors.white),
            ),
          ],
          pdfLib.SizedBox(height: 20), // Add space between sections
            pdfLib.Container(
     
  decoration: pdfLib.BoxDecoration(
    color: PdfColor.fromInt(AppColors.white.value),
    borderRadius: pdfLib.BorderRadius.circular(10.0), // Adjust the radius as needed
  ),
  child: pdfLib.Padding(
    padding: pdfLib.EdgeInsets.all(8.0),
    child: pdfLib.Text(
      'Refernce',
      style: pdfLib.TextStyle(
        color: PdfColor.fromInt(AppColors.customPurple.value),
        fontSize: 20,
        fontWeight: pdfLib.FontWeight.bold,
      ),
    ),
  ),
),
          for (var aditio in additionalInfoList) ...[
            pdfLib.Text(
              "Reference Name:${aditio['Reference Name']}",
              style: pdfLib.TextStyle(color: PdfColors.white),
            ),
            pdfLib.Text(
              "Job Title:${aditio['Job Title']}",
              style: pdfLib.TextStyle(color: PdfColors.white),
            ),
            pdfLib.Text(
              "Company Name:${aditio['Company Name']}",
              style: pdfLib.TextStyle(color: PdfColors.white),
            ),
            pdfLib.Text(
              "Email:${aditio['Email']}",
              style: pdfLib.TextStyle(color: PdfColors.white),
            ),
            pdfLib.Text(
              "Phone:${aditio['Phone']}",
              style: pdfLib.TextStyle(color: PdfColors.white),
            ),
          ],
        ],
      ),
    ),
  ],
));


    // Save and Share PDF
    final output = await getExternalStorageDirectory();
    final pdfPath = '${output!.path}/user_details.pdf';
    final file = File(pdfPath);
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([pdfPath], text: 'Sharing user details');
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "CV",
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.customPurple, // Changed app bar color to blue
    ),
    body: SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side container
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side details container
                    Container(
                      color: AppColors.customPurple, // Changed container color to blue
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),),
                              child: Center(
                                child: Text(
                                  "Personal Details",
                                  style: TextStyle(
                                    color: AppColors.customPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Display user data
                          ...userDataList.map((data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white, // Set the background color of the circle
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        data['imageURL'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Name: ${data['Name']}",
                                        style: TextStyle(color: AppColors.white)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Email: ${data['Email']}",
                                        style:
                                        TextStyle(color: AppColors.white)),
                                  ),
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Address: ${data['Address']}",
                                        style:
                                        TextStyle(color: AppColors.white)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Date of Birth: ${data['Date of Birth']}",
                                        style:
                                        TextStyle(color: AppColors.white)),
                                  ),
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Website: ${data['Website(optional)']}",
                                        style:
                                        TextStyle(color: AppColors.white)),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Phone: ${data['phone']}",
                                        style:
                                        TextStyle(color: AppColors.white)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          // Display objectives
                          ...objectiveList.map((data) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: AppColors.customPurple, // Changed container color to blue
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),),
                                    child: Center(
                                      child: Text(
                                        "Objectives",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  data['Objectives'] ?? '',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side container
          Container(
            color: AppColors.customPurple,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Right side details
                    // Display activities
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...activitiesList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10), 
                                  ),
                                 
                                  width: 100,
                                  child: Center(
                                    child: Text(
                                      "Activities",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.customPurple,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                data['Activities'] ?? '',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        }).toList(),
                        // Display achievements
                        ...achievementsList.map((data) {
                          return Center(
                            child: Container(
                              color: AppColors.customPurple, // Changed container color to blue
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Container(
                                  decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),),
                                  child: Text(
                                    "Achievements",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.customPurple,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  data['Achievements'] ?? '',
                                  style: TextStyle(color: AppColors.customPurple),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Display education
                        ...educationList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple,
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 150,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),),
                                    child: Center(
                                      child: Text(
                                        "Education",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8), // Adding some space between heading and information
                                ListTile(
                                  title: Text(
                                    "course: ${data['course'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "school: ${data['school'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "grade: ${data['grade'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "year: ${data['year'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                // You can add more widgets to display additional information here
                              ],
                            ),
                          );
                        }).toList(),
                        // Display experience
                        ...experienceList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),),
                                              width: 150,
                                    child: Center(
                                      child: Text(
                                        "Experience",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8), // Adding some space between heading and information
                                ListTile(
                                  title: Text(
                                    "Company Name: ${data['Company Name'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Job Title: ${data['Job Title'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Details: ${data['Details'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                // You can add more widgets to display additional information here
                              ],
                            ),
                          );
                        }).toList(),
                        // Display additional information
                        ...additionalInfoList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                              color: AppColors.white,
                               borderRadius: BorderRadius.circular(10),),
                                    child: const Center(
                                      child: Text(
                                        "Additional Information",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8), // Adding some space between heading and information
                                ListTile(
                                  title: Text(
                                    data['Additional information'] ?? '',
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                // You can add more widgets to display additional information here
                              ],
                            ),
                          );
                        }).toList(),
                        // Display language
                        ...languageList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Center(
                                child: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),),
                                  child: Center(
                                    child: Text(
                                      "Language",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.customPurple,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                data['Language'] ?? '',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        }).toList(),
                        // Display interests
                        ...interestsList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),),
                                    child: Center(
                                      child: Text(
                                        "Interests",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2), // Adding some space between heading and information
                                ListTile(
                                  title: Text(
                                    data['Interests'] ?? '',
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                // You can add more widgets to display additional information here
                              ],
                            ),
                          );
                        }).toList(),
                        // Display projects
                        ...projectsList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                    
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),),
                                    child: Center(
                                      child: Text(
                                        "Project",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2), // Adding some space between heading and information
                                ListTile(
                                  title: Text(
                                    "Project Title: ${data['Project Title'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Details : ${data['Details'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                // You can add more widgets to display additional information here
                              ],
                            ),
                          );
                        }).toList(),
                        // Display reference
                        ...referenceList.map((data) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: AppColors.customPurple, // Changed container color to blue
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),),
                                    child: Center(
                                      child: Text(
                                        "Reference",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.customPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8), // Adding some space between heading and information
                                ListTile(
                                  title: Text(
                                    "Reference Name : ${data[' Reference Name'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Job Title: ${data['Job Title'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Company Name: ${data['Company Name'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Email: ${data['Email'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Phone: ${data['Phone'] ?? ''}",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                // You can add more widgets to display additional information here
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: BottomAppBar(
      height: 62,
      color: AppColors.customPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PickScreen()),
              );
            },
            icon: Icon(Icons.change_circle, color: Colors.white),
            tooltip: 'Change Format',
          ),
          Text(
            'Change Format',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await generateAndSharePdf(context);
              // myFunction(context);
            },
            icon: Icon(Icons.share, color: Colors.white),
            tooltip: 'Share',
          ),
          Text(
            'Share',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
}