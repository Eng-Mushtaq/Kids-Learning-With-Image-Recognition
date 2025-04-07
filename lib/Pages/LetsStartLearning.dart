import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_learning/Learning/Alphabet.dart';
import 'package:kids_learning/Learning/Number.dart';

import '../Learning/Animals.dart';
import '../Learning/Brids.dart';
import '../Learning/Colors.dart';
import '../Learning/Flowers.dart';
import '../Learning/Fruit.dart';
import '../Learning/Month.dart';
import '../Learning/Shapes.dart';
import '../Learning/Vegitable.dart';


class LetsStartLearning extends StatefulWidget {
  int index;
  LetsStartLearning(this.index, {super.key});

  @override
  State<LetsStartLearning> createState() => _LetsStartLearningState();
}

class _LetsStartLearningState extends State<LetsStartLearning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.deepPurple[500],
        elevation: 0,
        title: const Text(
          "Letters and Numbers Learning",
          style: TextStyle(color: Colors.white, fontFamily: "arlrdbd"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(35),
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                    _buildLearningCard(
              context: context,
              title: 'Alphabet',
              imagePath: 'assets/images/Alphabet.png',
              
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Alphabet()),
              ),
            ),
                   _buildLearningCard(
              context: context,
              title: 'Numbers',
              imagePath: 'assets/images/Numbers.png',
             
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Numbers()),
              ),
            ), 
            _buildLearningCard(
              context: context,
              title: 'Colors',
              imagePath: 'assets/images/Color.png',
             
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ColorsLearning(2)),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Shapes',
              imagePath: 'assets/images/Shapes.png',
        
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Shapes()),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Animals',
              imagePath: 'assets/images/Animals.png',
              
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Animal()),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Birds',
              imagePath: 'assets/images/Birds.png',
        
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Brids()),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Flowers',
              imagePath: 'assets/images/Flowers.png',
              
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Flower()),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Fruits',
              imagePath: 'assets/images/Fruit.png',
            
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Fruits()),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Months',
              imagePath: 'assets/images/Month.png',
            
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Month()),
              ),
            ),
            _buildLearningCard(
              context: context,
              title: 'Vegetables',
              imagePath: 'assets/images/Vegitable.png',
              
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Vegitable()),
              ),
            ),
         
                ]),
          ),
        ],
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
 Widget _buildLearningCard({
    required BuildContext context,
    required String title,
    required String imagePath,

    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
                    splashColor: Colors.redAccent,
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(imagePath ,
                                height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100]),
                                child:  Center(
                                    child: Text(
                                 title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "arlrdbd",
                                      fontSize: 18),
                                ))),
                          ]),
                    ),),
    );
  }
