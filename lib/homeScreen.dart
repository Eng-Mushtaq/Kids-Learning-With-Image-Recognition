import 'package:flutter/material.dart';
import 'Pages/LetsStartLearning.dart';
import 'Pages/LookAndChooes.dart';
import 'Pages/VideoLearning.dart';
import 'Pages/listen_and_guess.dart';
import 'object_detection/object_detector_view.dart';

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
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildGridItem(context, index);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    builder: (context) => LetsStartLearning(index)));
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ObjectDetectorView()),
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
                  "assets/images/camera.png",
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.camera_alt,
                        size: 90, color: Colors.deepPurple);
                  },
                ),
                const Text(
                  'Object Detection',
                  style: TextStyle(
                      fontFamily: "arlrdbd", color: Color(0xFF6DB072)),
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
