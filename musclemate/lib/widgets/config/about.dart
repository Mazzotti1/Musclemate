
import 'package:flutter/material.dart';


class about extends StatefulWidget {
  const about({Key? key}) : super(key: key);

@override
  _aboutState createState()=> _aboutState();
}
class _aboutState extends State<about>{

  final List<Map<String, String>> items = [
    {"title": "Sobre Musclemate", "subtitle": "Musclemate é muito mais do que um aplicativo de treino. É uma comunidade vibrante de atletas que compartilham a mesma paixão por desafiar seus limites e alcançar seus objetivos de fitness. Com Musclemate, você pode experimentar uma nova forma de treinar e acompanhar o seu progresso de maneira fácil e intuitiva. Desde a definição de objetivos pessoais até a análise detalhada de seus resultados, Musclemate está sempre ao seu lado para ajudá-lo a atingir seus objetivos de treinamento."},
       {"title": "Versão", "subtitle": "Musclemate versão 0.1"},
          ];

@override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 30, right: 30),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index]["title"]!,
                          style: const TextStyle(fontSize: 17, color: Colors.black),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          items[index]["subtitle"]!,
                          style: const TextStyle(fontSize: 15, color: Colors.black38),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}
}