import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kids_learning/utils/model.dart';
import 'package:url_launcher/url_launcher.dart';

class BirdVideo extends StatefulWidget {
  @override
  State<BirdVideo> createState() => _BirdVideoState();
}

List<Numbermodel> bridvideolist = bridvideo1();
List<String> bridvideoURLlist = bridvideoURL();

class _BirdVideoState extends State<BirdVideo> {
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
          'Birds Video Songs',
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        )),
      ),
      body: Container(
        child: GridView.builder(
          itemCount: bridvideolist.length,
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
              splashColor: Colors.redAccent,
              onTap: () {
                _launchYoutubeVideo(bridvideoURLlist[index]);
                print(bridvideoURLlist[index]);
              },
              child: Card(
                color: Color(0xFFEBE8FD),
                elevation: 5,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: Colors.redAccent,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(bridvideolist[index].image!,
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          height: 122),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          bridvideolist[index].Text,
                          style: TextStyle(
                              color: Colors.redAccent,
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
    );
  }
}
