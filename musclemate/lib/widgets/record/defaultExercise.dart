

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/RecordPages/record_page.dart';
import 'package:musclemate/widgets/record/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';


class DefaultExercises extends StatefulWidget {
  const DefaultExercises({Key? key}) : super(key: key);

@override
  _DefaultExercisesState createState()=> _DefaultExercisesState();
}
class _DefaultExercisesState extends State<DefaultExercises>{

TextEditingController _nameController = TextEditingController();

List<String> exerciseList = [];
int selectedIndex = -1;

@override
  void initState() {
    super.initState();
    _loadTextFromLocalStorage();
    generateButtons();

  }

  void _openRecordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecordPage()),
    );
  }

Future<void> _saveSelectedExercise(String exercise) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('Exercise', exercise);
  print('Salvo: $exercise');
}

//Limpar o grupo muscular escolhido anteriormente
Future<void> _clearSelectedExercise() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('Exercise');
  print('clear');
}

Future<void> _loadTextFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedText = prefs.getString('SelectedExercise');
  if (savedText != null) {
    setState(() {
      exerciseList = savedText.split(","); // Converte a string em lista de strings
    });
  }
}

List<Widget> generateButtons() {
  return exerciseList.asMap().entries.map((entry) {
    final index = entry.key;
    final exercise = entry.value;
    final buttonText = exercise.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');

    final isSelected = index == selectedIndex; // Verificar se o botão está selecionado


//Modelo botões
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: TextButton(
          onPressed: () {
            setState(() {
              if (isSelected) {
                selectedIndex = -1; // Desselecionar o botão
                _clearSelectedExercise(); // Limpar a string salva
              } else {
                selectedIndex = index; // Selecionar o botão
                _saveSelectedExercise(exercise);
              }
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? const Color.fromRGBO(255, 204, 0, 1) : const Color.fromRGBO(217, 217, 217, 1),
            minimumSize: const Size(100, 50),
          ),
          child: Text(buttonText, style: TextStyle(color: isSelected ? Colors.black : Colors.black)),
        ),
      ),
    );
  }).toList();
}

void _handleButtonSelected(String buttonName) {
  setState(() {
    // Adicione o botão selecionado à lista de botões do componente pai
    exerciseList.add(buttonName);
  });
}

Future<void> saveDefaultTraining() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String trainingType = prefs.getString('SelectedExercise')!;
    List<String> exercises = prefs.getStringList('buttonNames')!;
    String nomeTreino = _nameController.text;
     String? apiUrl = dotenv.env['API_URL'];

    final userTokenData = JwtDecoder.decode(token);
    String userId = (userTokenData['sub']);

    String url = '$apiUrl/treinosPadroes';

  Map<String, dynamic> userData = {
  "nomeTreino": nomeTreino,
  "exercicios": exercises,
  "grupos": trainingType,
  "user": {
    "id": userId
  }
};

    String jsonData = jsonEncode(userData);
try {
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonData,
  );

 if (response.statusCode == 200) {
  _openRecordPage();
  print(response.body);

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
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: Scaffold(
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
                      'Monte e salve seus treinos para agilizar o processo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontFamily: 'BourbonGrotesque'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: generateButtons(),
                ),
              ),
              const SizedBox(height: 20,),
              barraPesquisa(onButtonSelected: (String) {}),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Container(
              width: double.infinity,
              height: 92,
              color: const Color.fromRGBO(228, 232, 248, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(215, 242, 132, 1),
                    ),
                    child: TextButton(
                     onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('De um nome para esse treino'),
                                content: CupertinoTextField(
                                  controller: _nameController,
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Fechar o diálogo
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('Salvar'),
                                    onPressed: () {
                                      saveDefaultTraining();
                                      Navigator.of(context).pop(); // Fechar o diálogo
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }, child: const Text('Salvar', style: TextStyle(color: Colors.black),),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}