import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/utils/model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import 'ABCQuize.dart';

class Colorquiz extends StatefulWidget {
  @override
  State<Colorquiz> createState() => _ColorquizState();
}

List<Numbermodel> colorlist = COLOR1();

class _ColorquizState extends State<Colorquiz> {
  bool isPressed = false;
  Color istrue = Colors.deepPurple;
  Color isWrong = Colors.red;
  Color btnColor = Colors.deepPurple[100]!;
  int score = 0;
  @override
  Widget build(BuildContext context) {
    PageController _controller = new PageController(initialPage: 0);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.deepPurple[500],
          title: Center(
              child: Text(
            'Colors Quiz',
            style: TextStyle(fontFamily: "arlrdbd", color: Colors.white),
          )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (page) {
                    isPressed = false;
                  },
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: colorquestion.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Image.asset(
                          colorlist[index].image!,
                          height: 180,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                        Expanded(
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(50),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount: 2,
                            primary: false,
                            children: [
                              for (int i = 0;
                                  i < colorquestion[index].answer.length;
                                  i++)
                                MaterialButton(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 10.0,
                                  height: 10,
                                  minWidth: double.infinity,
                                  color: isPressed
                                      ? colorquestion[index]
                                              .answer
                                              .entries
                                              .toList()[i]
                                              .value
                                          ? istrue
                                          : isWrong
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 18.0),
                                  onPressed: isPressed
                                      ? () {}
                                      : () {
                                          if (colorquestion[index]
                                              .answer
                                              .entries
                                              .toList()[i]
                                              .value) {
                                            setState(() {
                                              isPressed = true;
                                            });
                                            score += 1;
                                            print(score);
                                            MotionToast.success(
                                              borderRadius: 5,
                                              animationDuration:
                                                  Duration(seconds: 2),
                                              title: Text(
                                                "Your Answer is Right",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              description: Text('Description'),
                                            ).show(context);
                                          } else {
                                            setState(() {
                                              isPressed = true;
                                            });
                                            MotionToast.error(
                                              borderRadius: 5,
                                              animationDuration:
                                                  Duration(seconds: 2),
                                              title: Text(
                                                "Your Answer is Wrong",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              description: Text('Description'),
                                            ).show(context);
                                          }
                                        },
                                  child: Text(
                                    colorquestion[index]
                                        .answer
                                        .keys
                                        .toList()[i],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "arlrdbd",
                                        fontSize: 20.0),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              heightFactor: 2.7,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: isPressed
                                    ? index + 1 == colorquestion.length
                                        ? () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultSrceen(score)));
                                          }
                                        : () {
                                            _controller.nextPage(
                                                duration:
                                                    Duration(microseconds: 500),
                                                curve: Curves.linear);
                                          }
                                    : null,
                                child: Text(
                                  index + 1 == colorquestion.length
                                      ? "See Result"
                                      : "Next Question",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontFamily: "arlrdbd",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
