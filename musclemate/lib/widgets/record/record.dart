
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/RecordPages/defaultExercises_page.dart';

import 'package:musclemate/pages/RecordPages/recording_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;




class record extends StatefulWidget {
  const record({Key? key}) : super(key: key);

@override
  _recordState createState()=> _recordState();
}
class _recordState extends State<record>{

  @override
  void initState() {
    super.initState();
    findDefault();
  }


 final List<Map<String, dynamic>> items = [
    {"title": "Peito", "isSelected": false, "isDefault": true},
    {"title": "Biceps", "isSelected": false, "isDefault": true},
    {"title": "Triceps", "isSelected": false, "isDefault": true},
    {"title": "Costas", "isSelected": false, "isDefault": true},
    {"title": "Ombros", "isSelected": false, "isDefault": true},
    {"title": "Pernas", "isSelected": false, "isDefault": true},
    {"title": "Cárdio", "isSelected": false, "isDefault": true},
  ];

late List<bool> checkedList = List.filled(items.length, false);



  void _openRecordingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecordingPage(buttonName: '',)),
    );
  }

  void _openDefaultExercises() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DefaultExercisePage(buttonName: '',)),
    );
  }

bool _errorDialog = false;
String _Message = '';
Color _messageColor = Colors.red;

Future<void> startExercise() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];

  String url = '$apiUrl/exercicios';

  List jsonData = items
      .where((item) => item['isSelected'] == true)
      .map((item) => item.containsKey('isDefault') ? item['title'] : item['grupos'])
      .toList();

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('SelectedExercise', response.body);


      _openRecordingPage();

    } else {
      final error = jsonDecode(response.body)['error'];
      setState(() {
        _errorDialog = true;
      _Message = '$error';
      _messageColor = Colors.red;
      });
    }
  } catch (e) {
    setState(() {
      _errorDialog = true;
       _Message = 'Erro2: $e';
         _messageColor = Colors.red;
    });
  }
}

Future<void> createDefaultExercise() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];

  String url = '$apiUrl/exercicios';

  List jsonData = items
      .where((item) => item['isSelected'] == true && item.containsKey('isDefault'))
      .map((item) => item['title'] ?? '')
      .toList();

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('SelectedExercise', response.body);

      _openDefaultExercises();

    } else {
      final error = jsonDecode(response.body)['error'];
      setState(() {
        _errorDialog = true;
      _Message = '$error';
      _messageColor = Colors.red;
      });
    }
  } catch (e) {
    setState(() {
      _errorDialog = true;
       _Message = 'Erro2: $e';
         _messageColor = Colors.red;
    });
  }
}




Future<void> findDefault() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userId = (userTokenData['sub']);
  String url = '$apiUrl/treinosPadroes/$userId';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      for (var item in responseData) {
        final nomeTreino = item['nomeTreino'];
        final grupos = item['grupos'];
        final exercicios = item['exercicios'];

        items.add({
          "title": nomeTreino,
          "isSelected": false,
          "grupos": grupos,
          "exercicios": exercicios,
        });
      }
      setState(() {});
    } else {
      if (response.statusCode == 400) {
        final error = jsonDecode(response.body)['error'];
        print('Erro: $error');
      } else {
        setState(() {
          print('Erro: ${response.statusCode}');
        });
      }
    }
  } catch (e) {
    print('Erro: $e');
  }
}




@override
Widget build(BuildContext context) {
  if (_errorDialog) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Ops')),
          content:  Text(_Message,textAlign: TextAlign.center, style: TextStyle(color: _messageColor, fontSize: 17 ),),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _errorDialog = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  });
}
  return Scaffold(
    body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Center(
              child: Column(
                children: [
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
                        createDefaultExercise();
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
                          onPressed: (){
                            startExercise();
                          },
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