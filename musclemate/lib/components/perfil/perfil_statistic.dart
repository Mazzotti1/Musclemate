
import 'package:flutter/material.dart';





class PerfilStatistic extends StatefulWidget {
  const PerfilStatistic({Key? key}) : super(key: key);

@override
  _PerfilStatisticState createState()=> _PerfilStatisticState();
}
class _PerfilStatisticState extends State<PerfilStatistic>{


Widget build(BuildContext context) {
  final List<Map<String, String>> items = [
    {
      "title": "Média de treinos mensal",
      "treinos": "1",
      "tempo": "1h13min",
      "pesoLevantado": "62kg",
      "tempoCardio": "50min"
    },
    {
      "title": "Acumulado anual",
      "treinos": "1",
      "tempo": "1h13min",
      "pesoLevantado": "62kg",
      "tempoCardio": "50min"
    },
    {
      "title": "Total",
      "treinos": "1",
      "tempo": "1h13min",
      "pesoLevantado": "62kg",
      "tempoCardio": "50min"
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