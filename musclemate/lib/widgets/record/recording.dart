
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/widgets/record/searchBar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class recording extends StatefulWidget {
   final String buttonName;
 const recording({Key? key, required this.buttonName,}) : super(key: key);

 @override
  _recordingState createState()=> _recordingState();
}
class _recordingState extends State<recording> {
  late Timer timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isPaused = false;

  bool showCompleteButton = false;
  bool showContinueButton = false;

  Duration pausedDuration = Duration.zero;


  @override
  void initState() {
    super.initState();
    startTimer();
    _loadTextFromLocalStorage();
    generateButtons();

  }

    void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused) { // Verificar se o timer não está pausado
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
      }
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

// Salvar tempo de pausa do timer
Future<void> _savePausedDuration(Duration duration) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String formattedDuration = '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  await prefs.setString('PausedDuration', formattedDuration);
}



//Limpar tempo de pausa do timer
Future<void> _clearPausedDuration() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('PausedDuration');
}


//Gerar botões
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


Future<void> saveTraining() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String trainingType = prefs.getString('SelectedExercise')!;
    String time = prefs.getString('PausedDuration')!;
    int savedRepsTotais = prefs.getInt('repsTotais') ?? 0;
    double savedKgsTotais = prefs.getDouble('kgsTotais') ?? 0.0;
    int seriesTotais = prefs.getInt('seriesTotais') ?? 0;

    double mediaDePesoUtilizado = savedKgsTotais / seriesTotais;
    double mediaDePesoUtilizadoArredondada = mediaDePesoUtilizado.ceilToDouble();

    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];
    final userTokenData = JwtDecoder.decode(token);
    String userId = (userTokenData['sub']);
     String url = '$apiUrl/treinos';

  Map<String, dynamic> userData = {
  "tipoDeTreino": trainingType,
  "totalDeRepeticoes": savedRepsTotais,
  "mediaDePesoUtilizado": mediaDePesoUtilizadoArredondada,
  "dataDoTreino": currentDate,
  "tempo": time,
  "totalDeSeries": seriesTotais,
	"user":{"id":userId}
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

Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();

  final keys = prefs.getKeys();

  final seriesKeys = keys.where((key) => key.startsWith("series_")).toList();
  final repsKeys = keys.where((key) => key.startsWith("reps_")).toList();
  final kgsKeys = keys.where((key) => key.startsWith("kgs_")).toList();

  for (final key in seriesKeys) {
    await prefs.remove(key);
  }
  for (final key in repsKeys) {
    await prefs.remove(key);
  }
  for (final key in kgsKeys) {
    await prefs.remove(key);
  }
  await prefs.remove('seriesTotais');
  await prefs.remove('repsTotais');
  await prefs.remove('kgsTotais');

}


@override
Widget build(BuildContext context) {
  barraPesquisa(
  onButtonSelected: _handleButtonSelected,
  );
  String formattedTime = '${(hours + pausedDuration.inHours).toString().padLeft(2, '0')}:${((minutes + pausedDuration.inMinutes) % 60).toString().padLeft(2, '0')}:${((seconds + pausedDuration.inSeconds) % 60).toString().padLeft(2, '0')}';


  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
    },

    child: Scaffold(
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
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
                    barraPesquisa(onButtonSelected: (String ) {  },),

                  ],
                ),
              ),
            ),
          ),
         Padding(
  padding: const EdgeInsets.only(bottom: 56.0),
  child: Container(
    width: double.infinity,
    height: 92,
    color: const Color.fromRGBO(228, 232, 248, 1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!showCompleteButton && !showContinueButton) // Exibir o botão de pausa
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(184, 0, 0, 1),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isPaused = !isPaused; // Inverter o estado de pausa do timer

                      if (isPaused) {
                      pausedDuration += Duration(hours: hours, minutes: minutes, seconds: seconds);
                      // Redefinir os contadores de tempo
                      seconds = 0;
                      minutes = 0;
                      hours = 0;

                      _savePausedDuration(pausedDuration);
                    }


                  // Mostrar os botões apropriados com base no estado de pausa
                  showCompleteButton = isPaused;
                  showContinueButton = isPaused;
                });
              },
              icon: const Icon(
                Icons.square,
                color: Colors.white,
                size: 28,
              ),
              iconSize: 60,
            ),
          ),
        if (showCompleteButton) // Exibir o botão "Concluir"
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(215, 242, 132, 1),

            ),
            child: IconButton(
              onPressed: () {
                clearData();
                saveTraining();
              },
            icon: const Icon(
                Icons.check,
                color: Colors.black,
                size: 30,
              ),
              iconSize: 60,
            ),
          ),
        if (showContinueButton)
        const SizedBox(width: 40,),
        if (showContinueButton) // Exibir o botão "Continuar"
          Container(
            width: 70,
            height: 70,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isPaused = !isPaused;
                  showCompleteButton = false;
                  showContinueButton = false;
                  _clearPausedDuration();
                });
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 30,
              ),
              iconSize: 60,
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
