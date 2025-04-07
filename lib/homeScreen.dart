import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/LetsStartLearning.dart';
import 'Pages/LookAndChooes.dart';
import 'Pages/VideoLearning.dart';
import 'Pages/listen_and_guess.dart';
import 'package:kids_learning/Learning/Animals.dart';
import 'package:kids_learning/Learning/Brids.dart';
import 'package:kids_learning/Learning/Flowers.dart';
import 'package:kids_learning/Learning/Fruit.dart';
import 'package:kids_learning/Learning/Month.dart';
import 'package:kids_learning/Learning/Vegitable.dart';
import 'package:kids_learning/ObjectDetection/object_detection_screen.dart';
import 'package:kids_learning/RealTimeDetection/real_time_detection_screen.dart';
import 'package:kids_learning/RealTimeDetection/tflite_detection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? url =
      "https://play.google.com/store/apps/details?id=" + "com.example.kids";
  int? index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Exit App',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              content: const Text(
                'Do you want to exit an App?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return OverflowBar(
      children: [
        WillPopScope(
          onWillPop: showExitPopup,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple[500],
              elevation: 0,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.25,
                    child: Stack(
                      children: [
                        Container(
                          height: size.height * 0.25 - 27,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[500],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/logo.png",
                                  height: 100,
                                  width: 100,
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Kids",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "arlrdbd",
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Learning!",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: "arlrdbd",
                                          color: Color(0xFFF19335),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return _buildGridItem(context, index);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: InkWell(
                      splashColor: Colors.deepPurple[200],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TFLiteDetectionScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.amber[50],
                          border:
                              Border.all(color: Colors.amber[200]!, width: 2),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 45,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Advanced Detection',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "arlrdbd",
                                      color: Colors.amber[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Better detect animals, vegetables & fruits',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "arlrdbd",
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LetsStartLearning(index!)));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/number.png",
                  height: 90,
                ),
                const Text(
                  ' Start Learning',
                  style: TextStyle(
                      fontFamily: "arlrdbd", color: Color(0xFF6DB072)),
                ),
              ],
            ),
          ),
        );

      case 1:
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoLearning()),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/video.png",
                  height: 90,
                ),
                const Text(
                  'Video Learning',
                  style: TextStyle(
                      fontFamily: "arlrdbd",
                      color: Color.fromARGB(255, 1, 60, 163)),
                ),
              ],
            ),
          ),
        );

      case 2:
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LookAndChooes(0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/apple.png",
                  height: 90,
                ),
                const Text(
                  'Look And Choose',
                  style: TextStyle(
                      fontFamily: "arlrdbd", color: Color(0xFFF2CC2B)),
                ),
              ],
            ),
          ),
        );

      case 3:
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListenGuess()),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/lione.png",
                  height: 90,
                ),
                const Text(
                  'Listen and Guess',
                  style: TextStyle(
                      fontFamily: "arlrdbd", color: Color(0xFF8770E4)),
                ),
              ],
            ),
          ),
        );

      case 4:
        return InkWell(
          splashColor: Colors.deepPurple[200],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ObjectDetectionScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.purple[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 90,
                  color: Colors.deepPurple,
                ),
                Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple[100],
                  ),
                  child: Center(
                    child: Text(
                      'Object Detection',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "arlrdbd",
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case 5:
        return InkWell(
          splashColor: Colors.deepPurple[200],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RealTimeDetectionScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.purple[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pets,
                      size: 30,
                      color: Colors.brown,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.restaurant,
                      size: 30,
                      color: Colors.green,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.apple,
                      size: 30,
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Icon(
                  Icons.camera_enhance,
                  size: 45,
                  color: Colors.deepPurple,
                ),
                Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple[100],
                  ),
                  child: Center(
                    child: Text(
                      'Real-Time Detection',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "arlrdbd",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      default:
        return Container();
    }
  }
}
