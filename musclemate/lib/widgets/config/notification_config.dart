
import 'package:flutter/material.dart';


class notificationConfig extends StatefulWidget {
  const notificationConfig({Key? key}) : super(key: key);

@override
  _notificationConfigState createState()=> _notificationConfigState();
}
class _notificationConfigState extends State<notificationConfig>{



 final List<Map<String, String>> items = [
    {"title": "Likes", "subtitle": "Enviar notificações quando receber\n likes nos meus treinos"},
       {"title": "Comentários", "subtitle": "Enviar notificações quando receber\n comentários nos meus treinos"},
          {"title": "Seguidores", "subtitle": "Enviar notificações quando receber\n novos seguidores"},  ];

 late List<bool> checkedList = List.filled(items.length, false);

  void onChanged(bool? value, int index) {
    setState(() {
      checkedList[index] = value ?? false;
    });
  }

 @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 35),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items[index]["title"]!,
                    style: const TextStyle(fontSize: 17),
                  ),
                  Text(items[index]["subtitle"]!,
                    style: const TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  Checkbox(
                    value: checkedList[index],
                    onChanged: (value) => onChanged(value, index),
                    activeColor: const Color.fromRGBO(255, 204, 0, 1),
                    visualDensity: VisualDensity.comfortable,
                  )
                ],
              )
            ]
          ),
        );
      },
    );
  }
}