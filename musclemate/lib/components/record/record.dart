
import 'package:flutter/material.dart';
import 'package:musclemate/screen/RecordPages/recording_page.dart';


class record extends StatefulWidget {
  const record({Key? key}) : super(key: key);

@override
  _recordState createState()=> _recordState();
}
class _recordState extends State<record>{

 final List<Map<String, dynamic>> items = [
    {"title": "Peito", "isSelected": false},
    {"title": "Biceps", "isSelected": false},
    {"title": "Triceps", "isSelected": false},
    {"title": "Costas", "isSelected": false},
    {"title": "Ombros", "isSelected": false},
    {"title": "Inferiores", "isSelected": false},
    {"title": "Cárdio", "isSelected": false},
  ];

late List<bool> checkedList = List.filled(items.length, false);

  void _openRecordingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecordingPage()),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: Column(
                children: const [
                  Text(
                    'Qual vai ser o treino de hoje?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'BourbonGrotesque'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        item['isSelected'] = !item['isSelected'];
                      });
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (item['isSelected'] == true) {
                            return const Color.fromRGBO(255, 204, 0, 1);
                          }
                          return const Color.fromRGBO(217, 217, 217, 1);
                        },
                      ),
                    ),
                    child: Text(
                      item['title'] ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 360.0,
              child: Image.asset('assets/recordImage.png'),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 57,
       child: Container(
              height: 92,
              color: const Color.fromRGBO(228, 232, 248, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: TextButton(
                      onPressed: () {
                        // Lógica do botão
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(217, 217, 217, 1),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(50, 50),
                        ),
                      ),
                      child: const Icon(Icons.fitness_center_rounded, color: Colors.black87),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 100.0),
                        child: TextButton(
                          onPressed: _openRecordingPage,
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(194, 255, 26, 1),
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
                          child: const Text('Iniciar', style: TextStyle(color: Colors.black)),
                        ),
                      ),

                ),
              ),
            ],
          ),

        ),
     ),
    ],
  )
  );
}
}