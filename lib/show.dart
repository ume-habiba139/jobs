import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jobs/CV_files/cv_format.dart';
import 'package:jobs/job_categries/all_jobs.dart';
import 'package:jobs/upload_jobs.dart';
import 'package:jobs/upload_post.dart';

class ShowUploadedData extends StatefulWidget {
  @override
  _ShowUploadedDataState createState() => _ShowUploadedDataState();
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class _ShowUploadedDataState extends State<ShowUploadedData> {
  List<Map<dynamic, dynamic>> jobsList = [];
  List<Map<dynamic, dynamic>> postsList = [];
  List<Map<dynamic, dynamic>> filteredDataList = [];
  bool showNoResultsMessage = false;

  @override
  void initState() {
    super.initState();
    fetchJobsData();
    fetchPostsData();
  }

  Future<void> fetchJobsData() async {
    try {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('jobs');
      databaseRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          jobsList.clear();
          var snapshotValue = event.snapshot.value;
          if (snapshotValue is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> values = snapshotValue;
            values.forEach((key, value) {
              jobsList.add(Map<dynamic, dynamic>.from(value));
            });
            combineAndFilterData();
            setState(() {});
          }
        }
      }, onError: (error) {
        print("Error fetching jobs data: $error");
      }, cancelOnError: true);
    } catch (error) {
      print("Error fetching jobs data: $error");
    }
  }

  Future<void> fetchPostsData() async {
    try {
      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('posts');
      databaseRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          postsList.clear();
          var snapshotValue = event.snapshot.value;
          if (snapshotValue is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> values = snapshotValue;
            values.forEach((key, value) {
              postsList.add(Map<dynamic, dynamic>.from(value));
            });
            combineAndFilterData();
            setState(() {});
          }
        }
      }, onError: (error) {
        print("Error fetching posts data: $error");
      }, cancelOnError: true);
    } catch (error) {
      print("Error fetching posts data: $error");
    }
  }

  Future<String> getImageUrl(String imageURL) async {
    try {
      if (imageURL.isEmpty) {
        return ''; // Return empty string if imageURL is empty
      }
      String url = await FirebaseStorage.instance
          .refFromURL(imageURL)
          .getDownloadURL();
      return url;
    } catch (e) {
      print("Error fetching image URL: $e");
      return ''; // Return empty string in case of error
    }
  }

  void combineAndFilterData() {
    List<Map<dynamic, dynamic>> combinedList = [];
    combinedList.addAll(jobsList);
    combinedList.addAll(postsList);

    // Reverse the order of the combinedList
    combinedList = combinedList.reversed.toList();

    // Show all data initially
    filteredDataList.clear();
    filteredDataList.addAll(combinedList);
    setState(() {});
  }

  void filterData(String query) {
    List<Map<dynamic, dynamic>> matchedItems = [];
    List<Map<dynamic, dynamic>> remainingItems = [];

    for (var item in filteredDataList) {
      String jobName = (item['jobName'] ?? '').toString().toLowerCase();
      String postContent = (item['post'] ?? '').toString().toLowerCase();
      if (jobName.contains(query.toLowerCase()) ||
          postContent.contains(query.toLowerCase())) {
        matchedItems.add(item);
      } else {
        remainingItems.add(item);
      }
    }

    // Clear the filtered list
    filteredDataList.clear();

    // Add matched items to the top
    filteredDataList.addAll(matchedItems);
    // Add remaining items
    filteredDataList.addAll(remainingItems);

    // Update the visibility of "No results found" message
    setState(() {
      showNoResultsMessage = matchedItems.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Uploaded Jobs and Posts",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.customPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onChanged: (value) {
                        filterData(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredDataList.isEmpty
                ? Center(
                    child: showNoResultsMessage
                        ? Text(
                            'No results found',
                            style: TextStyle(fontSize: 16),
                          )
                        : CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: filteredDataList.length,
                    itemBuilder: (context, index) {
                      Map<dynamic, dynamic> item = filteredDataList[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.all(8),
                        color: AppColors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (filteredDataList[index].containsKey('jobName')) ...[
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: item['jobName'] != null &&
                                        item['jobName'].isNotEmpty
                                    ? Text('Job Name: ${item['jobName']}')
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: item['job Grade'] != null &&
                                        item['job Grade'].isNotEmpty
                                    ? Text('job Grade: ${item['job Grade']}')
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: item['salary Package'] != null &&
                                        item['salary Package'].isNotEmpty
                                    ? Text(
                                        'salary Package: ${item['salary Package']}')
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: item['Qulification'] != null &&
                                        item['Qulification'].isNotEmpty
                                    ? Text(
                                        'Qualification Required: ${item['Qulification']}')
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: item['jobCategory'] != null &&
                                        item['jobCategory'].isNotEmpty
                                    ? Text(
                                        'Job Category: ${item['jobCategory']}')
                                    : SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: item['description'] != null &&
                                        item['description'].isNotEmpty
                                    ? Text(
                                        'Description: ${item['description']}')
                                    : SizedBox.shrink(),
                              ),
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: GestureDetector(
                                  onTap: () {
                                    String postContent =
                                        filteredDataList[index]['post'];
                                    Clipboard.setData(
                                        ClipboardData(text: postContent));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Post copied to clipboard'),
                                    ));
                                  },
                                  child: SelectableText(
                                      filteredDataList[index]['post'] ?? ''),
                                ),
                              ),
                            ],
                            FutureBuilder<String>(
                              future: getImageUrl(
                                  filteredDataList[index]['imageURL'] ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  print(
                                      "Error loading image: ${snapshot.error}");
                                  return Text(
                                      'Error loading image: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    child: Image.network(
                                      snapshot.data ?? '',
                                      fit: BoxFit.cover,
                                      scale: 2.0,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print("Error loading image: $error");
                                        return Icon(Icons.error);
                                      },
                                    ),
                                  );
                                } else {
                                  return Text('No image URL available');
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            Divider(),
                          ],
                        ),
                      );
                    },
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
              icon: Icon(Icons.home, size: 30, color: AppColors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowUploadedData()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add, size: 30, color: AppColors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: AlertDialog(
                        title: Text("Upload"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UploadJobs()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Upload Job"),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UploadPost()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Upload Post"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.category, size: 30, color: AppColors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp1()),
                );
              },
            ),
             IconButton(
              icon: Icon(Icons.person, size: 30, color: AppColors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
