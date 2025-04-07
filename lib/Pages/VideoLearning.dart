import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids_learning/VideoLearning/ABC%20song.dart';
import 'package:kids_learning/VideoLearning/AnimalVideo.dart';
import 'package:kids_learning/VideoLearning/BirdVideo.dart';
import 'package:kids_learning/VideoLearning/FlowerVideo.dart';
import 'package:kids_learning/VideoLearning/FruitVideo.dart';
import 'package:kids_learning/VideoLearning/MonthVideo.dart';
import 'package:kids_learning/VideoLearning/Number%20video.dart';
import 'package:kids_learning/VideoLearning/ShapeVideo.dart';
import 'package:kids_learning/VideoLearning/VegitableVideo.dart';
import 'package:kids_learning/VideoLearning/colorvideo.dart';

class VideoLearning extends StatefulWidget {
  @override
  State<VideoLearning> createState() => _VideoLearningState();
}

class _VideoLearningState extends State<VideoLearning> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple[500],
        title: Center(
            child: Text(
          'Video Learning',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
                padding: EdgeInsets.all(35),
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                primary: false,
                children: [
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      // admobHelper.showInterad();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ABCVideo()));
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
                            Image.asset(
                              'assets/images/Alphabet.png',
                              height: 90,
                            ),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'ABC Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NumberVideo()));
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
                            Image.asset('assets/images/Numbers.png',
                                height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Number Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ColorVideo()));
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
                            Image.asset('assets/images/Color.png', height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Color Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShapeVideo()));
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
                            Image.asset('assets/images/Shapes.png', height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Shape Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimalVideo()));
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
                            Image.asset('assets/images/Animals.png',
                                height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Animal Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BirdVideo()));
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
                            Image.asset('assets/images/Birds.png', height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Bird Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlowerVideo()));
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
                            Image.asset('assets/images/Flowers.png',
                                height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Flower Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FruitVideo()));
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
                            Image.asset('assets/images/Fruit.png', height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Fruit Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonthVideo()));
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
                            Image.asset('assets/images/Month.png', height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Month Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      // admobHelper.showInterad();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VegitableVideo()));
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
                            Image.asset('assets/images/Vegitable.png',
                                height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child: Center(
                                    child: Text(
                                  'Vegetable Video',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),
                  )
                ]),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: MediaQuery.of(context).size.width *0.13,
      //   width: 25,
      //   child: AdWidget(
      //     ad:AdmobHelper.getBannerAd()..load(),
      //   ),
      // ),
    );
  }
}
