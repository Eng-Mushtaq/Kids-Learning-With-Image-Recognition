import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/Alphabetssound/MonthSound.dart';

import 'package:kids_learning/utils/model.dart';

class Month extends StatelessWidget {
  List<Numbermodel> monthlist = month1();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[500],
          elevation: 0,
          title: Center(
              child: Text(
            'Month',
            style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: monthlist.length,
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
                      print(monthlist);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthSound(index),
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
                              monthlist[index].image!,
                              height: 120,
                            ),
                            Text(
                              monthlist[index].Text,
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
