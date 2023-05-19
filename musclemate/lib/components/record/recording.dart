
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class recording extends StatefulWidget {
  const recording({Key? key}) : super(key: key);

 @override
  _recordingState createState()=> _recordingState();
}
class _recordingState extends State<recording> {
  late Timer timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
    _loadTextFromLocalStorage();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
        if (seconds >= 60) {
          seconds = 0;
          minutes++;
          if (minutes >= 60) {
            minutes = 0;
            hours++;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String buttonText = '';
  Future<void> _loadTextFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedText = prefs.getString('SelectedExercise');
    setState(() {
      buttonText = savedText!;
    });
  }

@override
Widget build(BuildContext context) {
   String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer_sharp, color: Colors.black45, size: 50),
                      const SizedBox(width: 15,),
                      Text(formattedTime, style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextButton(
                        onPressed: () {
                          // Ação quando o primeiro TextButton for pressionado
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                          minimumSize: const Size(100, 50),
                        ),
                        child:  Text(buttonText, style: const TextStyle(color: Colors.black),),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 217, 217, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.black45),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Encontre um exercício',
                                hintStyle: TextStyle(color: Colors.black45),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // O container fixo no bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 55,
            child: Container(
              width: double.infinity,
              height: 92,
              color: const Color.fromRGBO(228, 232, 248, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(227, 227, 227, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(80, 80),
          ),
        ),
        child: const Text('Continuar', style: TextStyle(color: Colors.black)),
      ),
      const SizedBox(width: 20), // Adiciona um espaçamento entre os botões
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromRGBO(184, 0, 0, 1),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(80, 80),
          ),
        ),
        child: const Text('Parar', style: TextStyle(color: Colors.white)),
      ),
    ],
  ),
)
          )

    ],

  )
  );
}

}