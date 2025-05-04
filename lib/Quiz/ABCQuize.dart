import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/utils/model.dart';
import 'package:kids_learning/components/learning_tracker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class ABCQuiz extends StatefulWidget {
  @override
  State<ABCQuiz> createState() => _ABCQuizState();
}

List<Numbermodel> kidslist = KidsList1();

class _ABCQuizState extends State<ABCQuiz> {
  bool isPressed = false;
  bool? isselected;
// int i;
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
          'ABC Quiz',
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
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Image.asset(
                        kidslist[index].image!,
                        height: 180,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.all(50),
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          primary: false,
                          children: [
                            for (int i = 0;
                                i < questions[index].answer.length;
                                i++)
                              MaterialButton(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 4.0,
                                height: 10,
                                minWidth: double.infinity,
                                color: isPressed
                                    ? questions[index]
                                            .answer
                                            .entries
                                            .toList()[i]
                                            .value
                                        ? istrue
                                        : isWrong
                                    : Colors.purple[50],
                                padding: EdgeInsets.symmetric(vertical: 18.0),
                                onPressed: isPressed
                                    ? () {}
                                    : () {
                                        if (questions[index]
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
                                  questions[index].answer.keys.toList()[i],
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
                            heightFactor: 3,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isPressed
                                  ? index + 1 == questions.length
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
                                index + 1 == questions.length
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultSrceen extends StatefulWidget {
  final int score;
  ResultSrceen(this.score);
  @override
  _ResultSrceenState createState() => _ResultSrceenState();
}

class _ResultSrceenState extends State<ResultSrceen> {
  @override
  void initState() {
    super.initState();
    // Track quiz completion
    _trackQuizCompletion();
  }

  void _trackQuizCompletion() {
    // Track quiz progress
    LearningTracker.trackQuizCompletion(
      context: context,
      category: 'alphabet',
      totalQuestions: questions.length,
      correctAnswers: widget.score,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Congratulation",
            style: TextStyle(
                color: Colors.black, fontFamily: "arlrdbd", fontSize: 38.0),
          )),
          Center(
              child: Text(
            "Your Score is:",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "arlrdbd",
                fontSize: 25.0,
                fontWeight: FontWeight.w500),
          )),
          SizedBox(
            height: 50.0,
          ),
          Center(
              child: Text(
            "${widget.score}",
            style: TextStyle(
                color: Colors.black, fontFamily: "arlrdbd", fontSize: 80.0),
          )),
          SizedBox(
            height: 50.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Back to Quiz",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "arlrdbd",
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
