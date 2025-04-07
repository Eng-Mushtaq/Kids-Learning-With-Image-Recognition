import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/Alphabetssound/VegitableSound.dart';
import 'package:kids_learning/utils/model.dart';

class Vegitable extends StatefulWidget {
  @override
  State<Vegitable> createState() => _VegitableState();
}

List<Numbermodel> vegitablelist = vegitable1();

class _VegitableState extends State<Vegitable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[500],
          elevation: 0,
          title: Center(
              child: Text(
            'Vegetable',
            style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: vegitablelist.length,
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
                      print(vegitablelist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VegitableSound(index),
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
                              vegitablelist[index].image!,
                              height: 120,
                            ),
                            Text(
                              vegitablelist[index].Text,
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
