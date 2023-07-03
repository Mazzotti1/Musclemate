

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:musclemate/widgets/charts/exercise_time_chart.dart';

import 'package:musclemate/widgets/charts/weight_progress_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


class PerfilProgress extends StatefulWidget {
  const PerfilProgress({super.key});

  @override
  State<PerfilProgress> createState() => _PerfilProgressState();
}

class _PerfilProgressState extends State<PerfilProgress> {


  double mediaMaximaAtingida = 0.0;
   Duration tempoMaximoAtingido = Duration.zero;

  List<double> pesos = [];
  List<String> dataTreino = [];
  List<String> tempos = [];
  List<double> temposDouble = [];


@override
  void initState() {
    super.initState();
    findTraining();

  }

  Future<void> findTraining() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userId = (userTokenData['sub']);
  String url = '$apiUrl/treinos/$userId';

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

for (var data in responseData) {
  int mediaDePesoUtilizado = data['mediaDePesoUtilizado'];
  String dataDoTreino = data['dataDoTreino'];
  String tempo = data['tempo'];

  tempos.add(tempo);
  pesos.add(mediaDePesoUtilizado.toDouble());
  dataTreino.add(dataDoTreino);


  double maxPeso = 0;
for (var peso in pesos) {
  if (peso > maxPeso) {
    maxPeso = peso;
  }
}

Duration maxTempos = Duration.zero;
for (String tempo in tempos) {
  List<String> tempoParts = tempo.split(':');
  int hours = int.parse(tempoParts[0]);
  int minutes = int.parse(tempoParts[1]);
  int seconds = int.parse(tempoParts[2]);

  Duration tempoDuration = Duration(hours: hours, minutes: minutes, seconds: seconds);
  maxTempos += tempoDuration;
}


temposDouble = tempos.map((tempo) {
  List<String> parts = tempo.split(':');
  int horas = int.parse(parts[0]);
  int minutos = int.parse(parts[1]);
  int segundos = int.parse(parts[2]);
  int totalMinutos = (horas * 60) + minutos + (segundos > 0 ? 1 : 0);

  return totalMinutos.toDouble();
}).toList();

print(temposDouble);



setState(() {
  mediaMaximaAtingida = maxPeso;
  tempoMaximoAtingido = maxTempos;
});
}

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

String formatDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
}

bool isModalVisible = false;
int currentGraphIndex = 1;

List<String> explanations = [
  'O gráfico é primeiramente baseado em peso (KGs) por dias, porém no momento que 6 dias são registrados ele começa a comparar media de peso dos 6 dias entre as semanas',
  'O gráfico é a duração dos seus treinos(Minutos) baseados em cada dia, no momento que 6 dias são registrados ele começa a comparar a media de minutos dos 6 dias entre as semanas ',
];


void _showExplanationModal(BuildContext context, String explanation) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Explicações do Gráfico'),
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o modal
            },
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

if (isModalVisible) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _showExplanationModal(context, explanations[currentGraphIndex]);
  });
}



    return Padding(
      padding: const EdgeInsets.only(top: 20.0,),
      child: Container(
        width: double.infinity,
        height: 600,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
               IconButton(
                  icon: Icon(Icons.help_outline_rounded),
                  onPressed: () {
                    setState(() {
                      currentGraphIndex = 0;
                      isModalVisible = true;
                    });
                  },
                ),
                  const Text(
                    'Progressão de peso',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 1,
                    height: 18,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),

                  Text(
                    'Média diária máxima atingida: ${mediaMaximaAtingida}kg',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
                const SizedBox(height: 35),
                  WeightProgressChart(
                      pesos: pesos,
                      dataTreino: dataTreino,
                    ),
            const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                         IconButton(
                            icon: Icon(Icons.help_outline_rounded),
                            onPressed: () {
                              setState(() {
                                currentGraphIndex = 1;
                                isModalVisible = true;
                              });
                            },
                          ),
                      const Text(
                        'Duração do treino',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 1,
                        height: 18,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                       Text(
                        'Tempo total de treino no ano: ${formatDuration(tempoMaximoAtingido)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12, ),
                   ExerciseTimeChart(
                      dataTreino: dataTreino,
                      tempos:temposDouble
                  ),
                const SizedBox(height: 20, ),
                ],

              )

              ]
            )
          )
        )
      );
  }
}
