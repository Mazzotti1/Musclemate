
import 'package:flutter/material.dart';


class notificacoes extends StatelessWidget {
  const notificacoes({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top:20.0, left: 20),
        child: Row(
          children: [
            Column(
              children: const [
                Icon(Icons.person, size: 50),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Matheus deu like em uma atividade sua!'),
                  SizedBox(height: 5),
                  Text('Hoje 13:20',
                  style:TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            )
          ]
        ),
      ),
      const SizedBox(height: 5),
      Container(
        width: double.infinity,
        height: 0.6,
        color: Colors.black,
      )
    ],
  );
}
}