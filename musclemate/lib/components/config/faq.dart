
import 'package:flutter/material.dart';


class faq extends StatefulWidget {
  const faq({Key? key}) : super(key: key);

@override
  _faqState createState()=> _faqState();
}
class _faqState extends State<faq>{

  final List<Map<String, String>> items = [
    {"title": "Como faz para completar o gráfico do perfil?", "subtitle": "O gráfico do perfil é baseado nas atividades diárias que são registradas nos seu perfil, basta publicar suas atividades diárias"},
       {"title": "Se apagar o registro diário depois de postado ele vai ser contabilizado no gráfico do perfil?", "subtitle": "Sim, mesmo que a atividade diária seja apagado do perfil depois de postada ela vai ficar com as estatísticas registradas no geral do perfil"},
          ];

@override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(top:30, left: 20),
        child: const Text(
          'FAQ',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),

      Expanded(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
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