import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids_learning/ListenGuessSongs/Alphabet.dart';
import 'package:kids_learning/ListenGuessSongs/Animal.dart';
import 'package:kids_learning/ListenGuessSongs/Brid.dart';
import 'package:kids_learning/ListenGuessSongs/Color.dart';
import 'package:kids_learning/ListenGuessSongs/Flower.dart';
import 'package:kids_learning/ListenGuessSongs/Fruit.dart';
import 'package:kids_learning/ListenGuessSongs/Month.dart';
import 'package:kids_learning/ListenGuessSongs/Number.dart';
import 'package:kids_learning/ListenGuessSongs/Shapes.dart';
import 'package:kids_learning/ListenGuessSongs/Vegitable.dart';

class ListenGuess extends StatefulWidget {
  @override
  State<ListenGuess> createState() => _ListenGuessState();
}

class _ListenGuessState extends State<ListenGuess> {
  int? index;

  @override
  Widget build(BuildContext context) {
    final FlutterTts flutterTts = FlutterTts();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: Center(
          child: Text(
            'Listen And Guess',
            style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
                padding: EdgeInsets.all(35),
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                  InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      flutterTts.speak('Apple');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlphabetSong()));
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
                                  'Alphabet',
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
                      flutterTts.speak('Zero');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NumberSong()));
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
                                  'Number',
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
                      flutterTts.speak('AQUA');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ColorSong()));
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
                                  'Color',
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
                      flutterTts.speak('ARROW');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShapesSong()));
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
                                  'Shape',
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
                      flutterTts.speak('BEER');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimalsSong()));
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
                                  'Animal',
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
                      flutterTts.speak('ARARAT');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BirdsSong()));
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
                                  'Bird',
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
                      flutterTts.speak('BLACK ROSE');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlowerSong()));
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
                                  'Flower',
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
                      flutterTts.speak('APPLE');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FruitSong()));
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
                                  'Fruit',
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
                      flutterTts.speak('JANUARY');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MonthSong()));
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
                                  'Month',
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
                      flutterTts.speak('BELL PEPPER');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VegitableSong()));
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
                                  'Vegetable',
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
