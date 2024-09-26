import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobs/show.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCZmcWiELdP7GyXkakAJ9V-GqmqKdypzwk',
      appId: '1:321526863414:android:bc745fe86cc72c99626a97',
      messagingSenderId: '321526863414',
      projectId: 'all-search-job',
      storageBucket: 'all-search-job.appspot.com',
      databaseURL: 'https://all-search-job-default-rtdb.firebaseio.com',
    ),
  );
  runApp(MyApp());
}

class AppColors {
  static const customPurple = Color.fromARGB(255, 2, 56, 130);
  static const Color white = Colors.white;
  static const Color customb = Color.fromARGB(255, 229, 226, 229);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainActivity(),
    );
  }
}

class MainActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set the background as transparent
      body: Stack(
        children: [
          VideoBackground(), // Display the video background
          ConstraintLayout(), // Display the content on top of the video
        ],
      ),
    );
  }
}

class VideoBackground extends StatefulWidget {
  @override
  _VideoBackgroundState createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/your_video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class ConstraintLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.customPurple,
        title: Center(
          child: Text(
            "Find , Work and Get More!",
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Adjust width dynamically
              height: MediaQuery.of(context).size.height * 0.7, // Adjust height dynamically
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 10),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Find Yours today!',
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: true, // Set to true for continuous animation
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Exciting career opportunities',
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: AppColors.customPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Create your own opportunities.',
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: AppColors.customPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: true, // Set to true for continuous animation
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowUploadedData()),
                      );
                    },
                    child: const Text(
                      'Start Yours Today',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.customPurple,
                      minimumSize: const Size(180, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
