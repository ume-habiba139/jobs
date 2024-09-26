import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:jobs/CV_files/fetchCV.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyAppfetch2());
}

class MyAppfetch2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShowUploadedData(),
    );
  }
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 6, 76, 82);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
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

  Future<void> generateAndSharePdf() async {
    final pdf = pdfLib.Document();
    // First Page: Personal Details
    pdf.addPage(
      pdfLib.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pdfLib.Container(
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.only(bottom: 10),
            child: pdfLib.Text(
            'Personal Details',
            style: pdfLib.TextStyle(
              color: PdfColor.fromInt(AppColors.white.value),
              fontSize: 20,
              fontWeight: pdfLib.FontWeight.bold,
            ),
          ),
        ),
        pdfLib.SizedBox(height: 10),
        for (var data in userDataList) ...[
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                // Display user's picture
                 
                pdfLib.SizedBox(height: 10),
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
                    "Email: ${data['Email'] ?? 'N/A'}",
                    style: pdfLib.TextStyle(
                      color: PdfColor.fromInt(AppColors.white.value),
                    ),
                  ),
                ),
                pdfLib.Padding(
                  padding: pdfLib.EdgeInsets.all(8),
                  child: pdfLib.Text(
                    "Address: ${data['Address'] ?? 'N/A'}",
                    style: pdfLib.TextStyle(
                      color: PdfColor.fromInt(AppColors.white.value),
                    ),
                  ),
                ),
                  pdfLib.Padding(
                    padding: pdfLib.EdgeInsets.all(8),
                    child: pdfLib.Text(
                      "Date of Birth: ${data['Date of Birth'] ?? 'null'}",
                      style: pdfLib.TextStyle(
                        color: PdfColor.fromInt(AppColors.white.value),
                      ),
                    ),
                  ),
                  pdfLib.Padding(
                    padding: pdfLib.EdgeInsets.all(8),
                    child: pdfLib.Text(
                      "Website: ${data['Website(optional)'] ?? 'N/A'}",
                      style: pdfLib.TextStyle(
                        color: PdfColor.fromInt(AppColors.white.value),
                      ),
                    ),
                  ),
                  pdfLib.Padding(
                    padding: pdfLib.EdgeInsets.all(8),
                    child: pdfLib.Text(
                      "Phone: ${data['phone'] ?? 'N/A'}",
                      style: pdfLib.TextStyle(
                        color: PdfColor.fromInt(AppColors.white.value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
           pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Skills',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var skill in skillsList) ...[
                  pdfLib.Text(
                    '${skill['skills']}',
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Language',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
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
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Interests',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var inter in interestsList) ...[
                  pdfLib.Text(
                    '${inter['Interests']}',
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Project',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var pro in projectsList) ...[
                  pdfLib.Text(
                     // "Name: ${data['Name'] ?? 'N/A'}",
                    "Project Tittle:${pro['Project Title']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                  pdfLib.Text(
                    "Details:'${pro['Details']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Reference',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var refer in referenceList) ...[
                  pdfLib.Text(
                    "Reference Name:${refer['Reference Name']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                   pdfLib.Text(
                    "Job Title:${refer['Job Title']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                   pdfLib.Text(
                    "Company Name:${refer['Company Name']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                   pdfLib.Text(
                    "Email:${refer['Email']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                   pdfLib.Text(
                    "Phone:${refer['Phone']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    // Second Page: Objectives and Activities
    pdf.addPage(
      pdfLib.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Objectives',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var obj in objectiveList) ...[
                  pdfLib.Text(
                    '${obj['Objectives']}',
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Activities',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var activitie in activitiesList) ...[
                  pdfLib.Text(
                    '${activitie['Activities']}',
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Achievements',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var achie in achievementsList) ...[
                  pdfLib.Text(
                    '${achie['Achievements']}',
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Experience',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var exeper in experienceList) ...[
                  pdfLib.Text(
                    "Company Name:${exeper['Company Name']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                  pdfLib.Text(
                    "Job Title:${exeper['Job Title']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                  pdfLib.Text(
                    "Details:${exeper['Details']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Education',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var edu in educationList) ...[
                  pdfLib.Text(
                    "course:${edu['course']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                  pdfLib.Text(
                    "school:${edu['school']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                  pdfLib.Text(
                    "grade:${edu['grade']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                  pdfLib.Text(
                    "year:${edu['year']}",
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
          pdfLib.Container(
            width: 500,
            color: PdfColor.fromInt(AppColors.customPurple.value),
            padding: pdfLib.EdgeInsets.all(8),
            margin: pdfLib.EdgeInsets.only(top: 10),
            child: pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text(
                  'Additional Information',
                  style: pdfLib.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pdfLib.FontWeight.bold,
                  ),
                ),
                for (var aditio in additionalInfoList) ...[
                  pdfLib.Text(
                    '${aditio['Additional information']}',
                    style: pdfLib.TextStyle(color: PdfColors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

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
          " CV",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.customPurple, // Changed app bar color to blue
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: AppColors.customPurple, // Changed container color to blue
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    ),
                    // Display objectives
                    ...objectiveList.map((data) {
                      return Container(
                        color: AppColors.customPurple, // Changed container color to blue
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            "Objectives",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          subtitle: Text(
                            data['Objectives'] ?? '',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      );
                    }).toList(),
                    // Display activities
                    ...activitiesList.map((data) {
                      return Container(
                        color: AppColors.customPurple, // Changed container color to blue
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            "Activities",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
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
                      return Container(
                        color: AppColors.customPurple, // Changed container color to blue
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            "Achievements",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          subtitle: Text(
                            data['Achievements'] ?? '',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      );
                    }).toList(),
                    // Display education
                    ...educationList.map((data) {
                    return Container(
  color: AppColors.customPurple,
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Education",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
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
  color: AppColors.customPurple, // Changed container color to blue
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Experience",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
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
  color: AppColors.customPurple, // Changed container color to blue
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Additional Information",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      SizedBox(height: 8), // Adding some space between heading and information
      ListTile(
        title: Text(
          data['Additional Information'] ?? '',
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
                        color: AppColors.customPurple, // Changed container color to blue
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            "Language",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
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
  color: AppColors.customPurple, // Changed container color to blue
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Interests:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
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
  color: AppColors.customPurple, // Changed container color to blue
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Project",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
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
          "Details : ${data[' Details'] ?? ''}",
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
  color: AppColors.customPurple, // Changed container color to blue
  padding: EdgeInsets.all(8),
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Reference",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
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
                    // Display skills
                    ...skillsList.map((data) {
                      return Container(
                        color: AppColors.customPurple, // Changed container color to blue
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            "Skills",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          subtitle: Text(
                             "Skills: ${data['Skills'] ?? ''}",
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      );

                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
        
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
        tooltip: 'Change Foramt',
      ),
      Text(
        'Change Foramt',
        style: TextStyle(color: Colors.white),
      ),
      IconButton(
        onPressed: () async {
          await generateAndSharePdf();
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
