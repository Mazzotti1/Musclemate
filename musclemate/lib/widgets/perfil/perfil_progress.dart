

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:musclemate/widgets/charts/exercise_time_chart.dart';
import 'package:musclemate/widgets/charts/exercise_volume_chart.dart';
import 'package:musclemate/widgets/charts/weight_progress_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


class PerfilProgress extends StatefulWidget {
  const PerfilProgress({super.key});

  @override
  State<PerfilProgress> createState() => _PerfilProgressState();
}

class _PerfilProgressState extends State<PerfilProgress> {



  List<double> pesos = [];
  List<int> meses = [];

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

  pesos.add(mediaDePesoUtilizado.toDouble());
  meses.add(int.parse(dataDoTreino.split('/')[1]));
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

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const Text(
                    'Carga máxima atingida: 42kg',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
                const SizedBox(height: 12),
                WeightProgressChart(
                  pesos: pesos,
                  meses: meses,
                ),
            const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const Text(
                        'Tempo total de treino no ano: 23h',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const ExerciseTimeChart(),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Vol. de treino',
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
                      const Text(
                        'Volume máximo atingido: 230kg',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                     padding: EdgeInsets.only(bottom: 50.0),
                    child: ExerciseVolumeChart(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
