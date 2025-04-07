import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/Alphabetssound/Alphasound.dart';
import 'package:kids_learning/utils/model.dart';

class Alphabet extends StatefulWidget {
  @override
  State<Alphabet> createState() => _AlphabetState();
}

List<Numbermodel> kidslist = KidsList1();

class _AlphabetState extends State<Alphabet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: Center(
            child: Text(
          'Alphabet',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          child: GridView.builder(
            itemCount: kidslist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  print(kidslist);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlphaSound(index),
                      ));
                },
                child: Card(
                  color: Colors.purple[50],
                  elevation: 4,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.deepPurple[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        kidslist[index].image!,
                        height: 120,
                      ),
                      Text(
                        kidslist[index].Text!,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: "arlrdbd",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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
