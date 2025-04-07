import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids_learning/Quiz/ABCQuize.dart';
import 'package:kids_learning/Quiz/AnimalQuize.dart';
import 'package:kids_learning/Quiz/BirdQuize.dart';
import 'package:kids_learning/Quiz/ColorQuiz.dart';
import 'package:kids_learning/Quiz/FlowerQuize.dart';
import 'package:kids_learning/Quiz/FruitQuize.dart';
import 'package:kids_learning/Quiz/MonthQuize.dart';
import 'package:kids_learning/Quiz/NumberQuiz.dart';
import 'package:kids_learning/Quiz/ShapeQuiz.dart';
import 'package:kids_learning/Quiz/VegitableQuiz.dart';

class LookAndChooes extends StatelessWidget {
  int index;
  LookAndChooes(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: Center(
            child: Text(
          'Look And Choose',
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ABCQuiz()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                  'ABC Songs',
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
                              builder: (context) => Numberquiz()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                  'Number Songs',
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
                          MaterialPageRoute(builder: (context) => Colorquiz()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                  'Color Songs',
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
                          MaterialPageRoute(builder: (context) => Shapequiz()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                  'Shape Songs',
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
                              builder: (context) => AnimalQuiz()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                  'Animal Songs',
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
                          MaterialPageRoute(builder: (context) => Birdquiz()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                  'Bird Songs',
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
                              builder: (context) => Flowerquiz()));
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
                                  'Flower Songs',
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
                          MaterialPageRoute(builder: (context) => Fruitquiz()));
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
                                  'Fruit Songs',
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
                          MaterialPageRoute(builder: (context) => Monthquiz()));
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
                                  'Month Songs',
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
                              builder: (context) => Vegitablequiz()));
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
                                  'Vegetable Songs',
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
