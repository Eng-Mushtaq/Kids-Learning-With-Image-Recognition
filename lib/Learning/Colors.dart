import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_learning/Alphabetssound/ColorSound.dart';
import 'package:kids_learning/utils/model.dart';

class ColorsLearning extends StatelessWidget {
  int index;
  ColorsLearning(this.index, {super.key});
  List<Numbermodel> colorlist = COLOR1();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[500],
          elevation: 0,
          title: Center(
              child: Text(
            'Color',
            style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: colorlist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      print(colorlist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorSound(index),
                          ));
                    },
                    child: Card(
                      color: Colors.purple[50],
                      elevation: 4,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      shadowColor: Colors.deepPurple[300],
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              colorlist[index].image!,
                              height: 120,
                            ),
                            Text(
                              colorlist[index].Text,
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontFamily: "arlrdbd"),
                            )
                          ]),
                    ));
              },
            ),
          ),
        ));
  }
}

final FlutterTts flutterTts = FlutterTts();
