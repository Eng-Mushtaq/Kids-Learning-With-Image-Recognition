import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/Learning/Alphabet.dart';
import 'package:kids_learning/Learning/Number.dart';


class LetsStartLearning extends StatefulWidget {
  int index;
  LetsStartLearning(this.index, {super.key});

  @override
  State<LetsStartLearning> createState() => _LetsStartLearningState();
}

class _LetsStartLearningState extends State<LetsStartLearning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: const Text(
          "Letters and Numbers Learning",
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(35),
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Alphabet()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/number.png",
                            height: 90,
                          ),
                          Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.purple[100]),
                              child: const Center(
                                  child: Text(
                                'Alphabet',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "arlrdbd",
                                    fontSize: 18),
                              ))),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.redAccent,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Numbers()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(10.0)),
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
                                child: const Center(
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
