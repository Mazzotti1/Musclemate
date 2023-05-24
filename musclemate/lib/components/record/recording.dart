
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musclemate/components/record/searchBar.dart';
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
    generateButtons();
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

List<String> exerciseList = [];
int selectedIndex = -1;

//Carregar os grupos musculares escolhidos
Future<void> _loadTextFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedText = prefs.getString('SelectedExercise');
  if (savedText != null) {
    setState(() {
      exerciseList = savedText.split(","); // Converte a string em lista de strings
    });
  }
}
//Salvar a escolha do grupo muscular
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

//Gerar botões
List<Widget> generateButtons() {
  return exerciseList.asMap().entries.map((entry) {
    final index = entry.key;
    final exercise = entry.value;
    final buttonText = exercise.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');

    final isSelected = index == selectedIndex; // Verificar se o botão está selecionado

//Rota GET dos exercicios


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

@override
Widget build(BuildContext context) {
  String formattedTime =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: generateButtons(),
                ),
              ),
              const SizedBox(height: 20,),
              barraPesquisa()
            ],
          ),
        ),
      ),
    ),
  );
}

}