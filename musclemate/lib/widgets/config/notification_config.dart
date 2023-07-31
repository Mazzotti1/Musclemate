
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;



class notificationConfig extends StatefulWidget {
  const notificationConfig({Key? key}) : super(key: key);

@override
  _notificationConfigState createState()=> _notificationConfigState();
}
class _notificationConfigState extends State<notificationConfig> {
  final List<Map<String, String>> items = [
    {"title": "Likes", "subtitle": "Enviar notificações quando receber\n likes nos meus treinos"},
    {"title": "Comentários", "subtitle": "Enviar notificações quando receber\n comentários nos meus treinos"},
    {"title": "Seguidores", "subtitle": "Enviar notificações quando receber\n novos seguidores"},
  ];

  late List<bool> checkedList = List.filled(items.length, false);

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

Future<void> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");
  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);
  String userId = (userData['sub']);
  String url = '$apiUrl/users/$userId';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body) as Map<String, dynamic>;

      setState(() {
        checkedList[0] = userData['likeNotification'] ?? false;
        checkedList[1] = userData['commentNotification'] ?? false;
        checkedList[2] = userData['followNotification'] ?? false;
      });

      } else {

      }
    } catch (e) {
      print('$e');
    }
  }

  void onChanged(bool? value, int index) {
    setState(() {
      checkedList[index] = value ?? false;
    });
  }

  Future<void> updateUserNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  String? apiUrl = dotenv.env['API_URL'];

  String token = prefs.getString('token')!;
  final userData = JwtDecoder.decode(token);
  String userId = (userData['sub'] ?? '');

  String url = '$apiUrl/users/update/notifications/$userId';

  try {
    final response = await http.patch(
      Uri.parse(url),

      body: jsonEncode({
        "likeNotification": checkedList[0],
        "commentNotification": checkedList[1],
        "followNotification": checkedList[2],
  }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
    } else {
      print('Erro: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
  }
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
                                      onChanged: (value) {
                    setState(() {
                      checkedList[index] = value ?? false;
                    });
                    updateUserNotifications();
                  },
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