

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


class PerfilStatistic extends StatefulWidget {
  const PerfilStatistic({Key? key}) : super(key: key);

@override
  _PerfilStatisticState createState()=> _PerfilStatisticState();
}
class _PerfilStatisticState extends State<PerfilStatistic>{


@override
  void initState() {
    super.initState();
    findTraining();
  }

  double mediaMaximaAtingida = 0.0;
  Duration tempoMaximoAtingido = Duration.zero;
  int treinosTotais = 0;

  List<String> tempos = [];
  List<double> pesos = [];
  List<String> dataTreino = [];




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
  String tempo = data['tempo'];
  String dataDoTreino = data['dataDoTreino'];

  tempos.add(tempo);
  pesos.add(mediaDePesoUtilizado.toDouble());
  dataTreino.add(dataDoTreino);

double maxPeso = 0;
for (var peso in pesos) {
  maxPeso += peso;
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



setState(() {
  mediaMaximaAtingida = maxPeso;
  tempoMaximoAtingido = maxTempos;
  treinosTotais = dataTreino.length;
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

@override
  Widget build(BuildContext context) {
  final List<Map<String, String>> items = [
    {
      "title": "Média de treinos mensal",
      "treinos": "1",
      "tempo": "1h13min",
      "pesoLevantado": "62kg",
      "tempoCardio": "Em breve"
    },
    {
      "title": "Acumulado anual",
      "treinos": "1",
      "tempo": "1h13min",
      "pesoLevantado": "62kg",
      "tempoCardio": "Em breve"
    },
    {
      "title": "Total",
      "treinos": '${treinosTotais}',
      "tempo": '${formatDuration(tempoMaximoAtingido)}',
      "pesoLevantado": '${mediaMaximaAtingida}',
      "tempoCardio": "Em breve"
    },
  ];

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: double.infinity,
              height: 25,
              color: const Color.fromRGBO(237, 237, 237, 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                child: Text(item['title'] ?? '', style: const TextStyle(color: Colors.black54),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Treinos'),
                const Spacer(),
                Text(item['treinos'] ?? ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const Text('Tempo'),
               const Spacer(),
                Text(item['tempo'] ?? ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const Text('Peso levantado'),
                const Spacer(),
                Text(item['pesoLevantado'] ?? ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const Text('Tempo de cárdio'),
               const Spacer(),
                Text(item['tempoCardio'] ?? ''),
              ],
            ),
          ),
        ],
      );
    },
  );
}
}