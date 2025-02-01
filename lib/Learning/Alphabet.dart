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
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.purple[50],
        title: const Center(
            child: Text(
          'Alphabet',
          style: TextStyle(color: Colors.black, fontFamily: "arlrdbd"),
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
                splashColor: Colors.redAccent,
                onTap: () {
                  print(kidslist);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlphaSound(index),
                      ));
                },
                child: Card(
                    color: const Color.fromARGB(255, 233, 213, 255),
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    shadowColor: Colors.purpleAccent,
                    child: Center(
                      child: Image.asset(
                        kidslist[index].image!,
                        height: 120,
                      ),
                    )),
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
