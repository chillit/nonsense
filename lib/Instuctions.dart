import 'package:flutter/material.dart';
import 'package:nonsense/people_list.dart';
class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key}) : super(key: key);

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7030A0),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Первая помощь"),
        leading: IconButton( // Use leading property instead of actions
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PeopleList()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageTextContainer(imagePath: 'assets/res2.png', text: "Прекратить воздействие поражающего фактора.",number: "1", isRight: false,),
            ImageTextContainer(imagePath: 'assets/res4.png', text: "Подставить ожог подхолодную воду(приложить к нему пакет со льдом).",number: "2", isRight: true,),
            ImageTextContainer(imagePath: 'assets/res1.png', text: "Накрыть ожог чистой сухой тканью, на которую положить холод..",number: "3", isRight: false,),
            ImageTextContainer(imagePath: 'assets/res3.png', text: "Вызвать скорую помощь.\n Позвоните по номеру 103",number: "4", isRight: true,),
            ImageTextContainer(imagePath: 'assets/res6.png', text: "Предложить пострадавшему обильное питье.",number: "5", isRight: false,),
            ImageTextContainer(imagePath: 'assets/res5.png', text: "Дать пострадавшему обезболивающее..",number: "6", isRight: true,),
            SizedBox(height: 50),
            // Padding(
            //   padding: const EdgeInsets.only(top: 23.0,bottom: 40),
            //   child: GestureDetector(
            //     child: Text(
            //       'Перейти к плану эвакуации',
            //       style: TextStyle(color: Color(
            //           0xFF4838D1),
            //         decoration: TextDecoration.underline,
            //         decorationColor: Color(
            //             0xFF4838D1),
            //         decorationThickness: 1, ),
            //     ),
            //     onTap: () {
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(builder: (context) => Escape_plan()),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),

    );
  }

}



class ImageTextContainer extends StatelessWidget {
  final String imagePath; // Path to the image asset
  final String text;
  final String number;
  final bool isRight;

  ImageTextContainer({
    required this.imagePath,
    required this.text,
    required this.number,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 120,
            color: Color.fromRGBO(47, 16, 91, 1),
            child: Center(
              child: Text(
                number,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(
                  text,
                  style: TextStyle(fontSize: 16),
                  textAlign: isRight ? TextAlign.right : TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Escape_plan extends StatefulWidget {
  const Escape_plan({Key? key}) : super(key: key);

  @override
  State<Escape_plan> createState() => _Escape_planState();
}

class _Escape_planState extends State<Escape_plan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("План эвакуации"),
        leading: IconButton( // Use leading property instead of actions
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PeopleList()),
            );
          },
        ),
      ),
      body: GestureDetector(
        child: Text(
          'Как оказывать первую помощь при ожоге',
          style: TextStyle(color: Color(
              0xFF4838D1),
            decoration: TextDecoration.underline,
            decorationColor: Color(
                0xFF4838D1),
            decorationThickness: 1, ),
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InstructionPage()),
          );
        },
      ),

    );
  }
}



