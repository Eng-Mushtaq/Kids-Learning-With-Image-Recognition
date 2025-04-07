import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kids_learning/utils/model.dart';

import 'package:url_launcher/url_launcher.dart';

class ABCVideo extends StatefulWidget {
  @override
  State<ABCVideo> createState() => _ABCVideoState();
}

List<Numbermodel> alphabetvideolist = alphabetvideo1();
List<String> alphabetvideoURLlist = alphabetvideoURL();

class _ABCVideoState extends State<ABCVideo> {
  Future<void> _launchYoutubeVideo(String url) async {
    await launch(url);
  }

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
          'ABC Video',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        )),
      ),
      body: Container(
        child: GridView.builder(
          itemCount: alphabetvideolist.length,
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
                _launchYoutubeVideo(alphabetvideoURLlist[index]);
              },
              child: Card(
                color: Colors.purple[50],
                elevation: 4,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.deepPurple[300],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(alphabetvideolist[index].image!,
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          height: 122),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          alphabetvideolist[index].Text,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontFamily: "arlrdbd",
                              fontSize: 15),
                        )),
                      )
                    ]),
              ),
            );
          },
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
