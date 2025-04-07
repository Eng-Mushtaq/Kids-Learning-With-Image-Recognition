import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/Alphabetssound/FruitSound.dart';
import 'package:kids_learning/utils/model.dart';

class Fruits extends StatefulWidget {
  @override
  State<Fruits> createState() => _FruitsState();
}

List<Numbermodel> FRUITlist = fruit1();

class _FruitsState extends State<Fruits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[500],
          elevation: 0,
          title: Center(
              child: Text(
            'Fruit',
            style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: FRUITlist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return InkWell(
                    splashColor: Colors.deepPurple[200],
                    onTap: () {
                      print(FRUITlist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FruitSound(index),
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
                              FRUITlist[index].image!,
                              height: 120,
                            ),
                            Text(
                              FRUITlist[index].Text,
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
