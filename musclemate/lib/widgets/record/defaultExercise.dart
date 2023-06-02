

import 'package:flutter/material.dart';
import 'package:musclemate/widgets/record/searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DefaultExercises extends StatefulWidget {
  const DefaultExercises({Key? key}) : super(key: key);

@override
  _DefaultExercisesState createState()=> _DefaultExercisesState();
}
class _DefaultExercisesState extends State<DefaultExercises>{

List<String> exerciseList = [];
int selectedIndex = -1;

@override
  void initState() {
    super.initState();
    _loadTextFromLocalStorage();
    generateButtons();

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

@override
Widget build(BuildContext context) {
barraPesquisa(
  onButtonSelected: _handleButtonSelected,
  );

  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
    },

  child:  Scaffold(
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
                    barraPesquisa(onButtonSelected: (String ) {  },),

                  ],
                ),
          ]
            ),

        ),

  );


}
}