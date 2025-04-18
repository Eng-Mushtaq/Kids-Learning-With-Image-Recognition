import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/privacypolicy.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final flutterWebviewPlugin = new PrivacyPolicy();

  _openMap() async {
    const url = "https://play.google.com/store/apps/details?id=" + "";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // _Share() async{
  //   FlutterShare.share(title: 'SHare',linkUrl: "https://play.google.com/store/apps/details?id=" + "com.example.kids");
  // }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height * 0.3,
              child: Stack(
                children: [
                  Container(
                      height: size.height * 0.3 - 27,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[500],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              width: 100,
                              height: 100,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Kids",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "arlrdbd",
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Learning!",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: "arlrdbd",
                                      color: Color(0xFFF19335),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  return _openMap();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFE4F2E6),
                      borderRadius: BorderRadius.circular(10)),
                  height: 80,
                  width: 300,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Rate Us',
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: true),
                      style: TextStyle(
                        color: Color(0xFF5EA763),
                        fontFamily: "arlrdbd",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  // return _Share();
                },
                splashColor: const Color(0xFFF2CF37),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 213, 255),
                      borderRadius: BorderRadius.circular(10)),
                  height: 80,
                  width: 300,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: const Text(
                      'Share',
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: true),
                      style: TextStyle(
                        color: Color.fromARGB(255, 119, 2, 158),
                        fontFamily: "arlrdbd",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
