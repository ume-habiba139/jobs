import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp1());
}

class AppColors {
  static const Color customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Colors.white;
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
  static const Color customttex = Color.fromARGB(255, 169, 167, 169);
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: All_Jobs(),
    );
  }
}

class All_Jobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Text(
              "Find Your Dream Jobs",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ConstraintLayout(),
    );
  }
}

class ConstraintLayout extends StatefulWidget {
  @override
  _ConstraintLayoutState createState() => _ConstraintLayoutState();
}

class _ConstraintLayoutState extends State<ConstraintLayout> {
  final List<List<String>> customTexts = [
    ["Freelance projects", "Jobs By Software House", "Jobs By company", "Jobs By Industries", "Jobs BY City"],
    ["Latest Featured Jobs", "Call Center Services", " Counter Software ", "Employment Firms", "Lahore"],
    ["Jobs By Functional area", "Information Technology", "Zones IT Solutions", "Islamabad", "Faisalabad"],
    ["Business Development", "Manufacturing", "Jobs By Army", " United Nations Pakistan", "Karachi"],
    ["Financial Services", "Services", "Amet Consectetur", " Professional Employers", "Islamabad","Noun"],
  ];

  List<List<String>> filteredTexts = [];

  String searchText = '';

  @override
  void initState() {
    super.initState();
    filteredTexts = customTexts;
  }

  Future<void> filterJobs(String jobCategory) async {
    if (jobCategory.isEmpty) {
      // Show an alert dialog to inform the user to select a job category
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please select a job category"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('jobs');
      try {
        DatabaseEvent snapshotEvent = await databaseRef.orderByChild('jobCategory').equalTo(jobCategory).once();
        DataSnapshot snapshot = snapshotEvent.snapshot;
        if (snapshot.value != null) {
          Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;
          if (values != null) {
            List<Map<dynamic, dynamic>> jobList = [];
            values.forEach((key, value) {
              jobList.add(Map<dynamic, dynamic>.from(value));
            });

            // Navigate to job details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailsScreen(jobList: jobList),
              ),
            );
          }
        }
      } catch (error) {
        print('Error fetching jobs data: $error');
        // Handle error
      }
    }
  }

  void updateFilteredTexts() {
    if (searchText.isEmpty) {
      setState(() {
        filteredTexts = customTexts;
      });
    } else {
      setState(() {
        filteredTexts = customTexts.map((list) => list.where((text) => text.toLowerCase().contains(searchText.toLowerCase())).toList()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/jobs1.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const Text(
                  "Thousand of Success Stories.",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Start Yours Today.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 480,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        updateFilteredTexts(); // Update filteredTexts when search text changes
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search Job Category..... ",
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTexts.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.customPurple,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filteredTexts[index]
                      .map(
                        (text) => InkWell(
                          onTap: () {
                            filterJobs(text); // Call filterJobs with the selected category
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width - 40, // Adjust the width here
                            padding: EdgeInsets.all(10),
                            color: AppColors.white,
                            child: Text(
                              text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class JobDetailsScreen extends StatelessWidget {
  final List<Map<dynamic, dynamic>> jobList;

  const JobDetailsScreen({required this.jobList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Job Categories',style: TextStyle(color: AppColors.white),)),
        backgroundColor: AppColors.customPurple,
      ),
      body: ListView.builder(
        itemCount: jobList.length,
        itemBuilder: (context, index) {
          final job = jobList[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (job['jobName'] != null && job['jobName'].isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Job Name: ${job['jobName']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (job['job Grade'] != null && job['job Grade'].isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'job Grade: ${job['job Grade']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (job['salary Package'] != null && job['salary Package'].isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'salary Package: ${job['salary Package']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (job['Qulification'] != null && job['Qulification'].isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Qulification Required: ${job['Qulification']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (job['jobCategory'] != null && job['jobCategory'].isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'job Category: ${job['jobCategory']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (job['description'] != null && job['description'].isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Description: ${job['description']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                SizedBox(height: 8),
                FutureBuilder<String>(
                  future: getImageUrl(job['imageURL'] ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print("Error loading image: ${snapshot.error}");
                      return SizedBox(); // Return empty SizedBox if there's an error
                    } else if (snapshot.hasData) {
                      return Image.network(
                        snapshot.data ?? '',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading image: $error");
                          return Icon(Icons.error);
                        },
                      );
                    } else {
                      return SizedBox(); // Return empty SizedBox if no image URL available
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> getImageUrl(String imageURL) async {
    try {
      if (imageURL == null || imageURL.isEmpty) {
        return ''; // Return empty string if imageURL is null or empty
      }
      // Code to fetch image URL from imageURL
      return imageURL;
    } catch (e) {
      print("Error fetching image URL: $e");
      return ''; // Returfn empty string in case of error
    }
  }
}
