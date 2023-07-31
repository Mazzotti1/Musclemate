

import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../pages/perfil_users/perfi_Users_page.dart';



class notificacoes extends StatefulWidget {
  const notificacoes({Key? key}) : super(key: key);

  @override
  _notificacoesState createState()=> _notificacoesState();
}
class _notificacoesState extends State<notificacoes>{

   @override
  void initState() {
    super.initState();
    infoNotification();
  }

List<Map<String, dynamic>> notificationList = [];
bool isLoading = true;
int userIdChoosed = 0;

void _navigateToChoosedPerfil(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    final userData = JwtDecoder.decode(token);
    String loggedInUserId = (userData['sub']);
  if (userId != loggedInUserId) {
    prefs.setString('choosedPerfil', userId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilPageUsers()),
    );
  } else {
    return;
  }
}

 infoNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);
  String userId = (userData['sub']);
  String url = '$apiUrl/notifications/$userId';

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
     for (var notificationData in responseData) {
    String imageUrl = notificationData['user'] != null ? notificationData['user']['imageUrl'] : '';
    String atividade = notificationData['atividade'];
    String at = notificationData['at'];
    int userId = notificationData['user'] != null ? notificationData['user']['id'] : '';
    notificationList.add({
      'atividade': atividade,
      'imageUrl': imageUrl,
      'at':at,
      'id':userId,
    });
  }
        setState(() {
        isLoading = false;
      });
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

String formatCommentedAt(String time) {
  DateTime originalDateTime = DateTime.parse(time).toLocal();
  DateTime now = DateTime.now();

  int differenceInMinutes = now.difference(originalDateTime).inMinutes;
   print('Difference in minutes: $differenceInMinutes');
  int weeks = differenceInMinutes ~/ (60 * 24 * 7);
  int days = differenceInMinutes ~/ (60 * 24) % 7;
  int hours = (differenceInMinutes % (60 * 24)) ~/ 60;
  int minutes = differenceInMinutes % 60;

  if (weeks > 0) {
    return "há $weeks ${weeks == 1 ? 'semana' : 'semanas'}";
  } else if (days > 0) {
    return "há $days ${days == 1 ? 'dia' : 'd'}";
  } else if (hours > 0) {
    return "há $hours ${hours == 1 ? 'hora' : 'h'}";
  } else if (minutes > 0) {
    return "há $minutes ${minutes == 1 ? 'minuto' : 'min'}";
  } else {
    return "agora";
  }
}

@override
Widget build(BuildContext context) {
  if (notificationList.isEmpty) {

    return Center(
      child: Text('Você ainda não tem nenhuma notificação!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24),),
    );
  } else {
  return ListView.builder(
   itemCount: notificationList.length,
    itemBuilder: (context, index) {
      var notificationData = notificationList.reversed.toList()[index];
        String imageUrl = notificationData['user'] != null ? notificationData['user']['imageUrl'] : '';
        String atividade = notificationData['atividade'] !=null ? notificationData['atividade'] : '';
        String at = notificationData['at'] !=null ? notificationData['at'] : '';

    return Column(
      children: [
         Padding(
          padding: EdgeInsets.only(top:20.0, left: 20),
          child: Row(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String token = prefs.getString('token')!;
                        await dotenv.load(fileName: ".env");

                        String? apiUrl = dotenv.env['API_URL'];
                        String userName = atividade.split(' ').first;
                        String url = '$apiUrl/users/nome/$userName';

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
                            setState(() {
                              userIdChoosed = responseData['id'];
                            });
                            _navigateToChoosedPerfil(userIdChoosed.toString());
                          } else {
                            if (response.statusCode == 400) {
                              final error = jsonDecode(response.body)['error'];
                              print('Erro: $error');
                            } else {
                              print('Erro: ${response.statusCode}');
                            }
                          }
                        } catch (e) {
                          print('Erro: $e');
                        }
                      },
                    child: imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        )
                      : Icon(Icons.person_outline_rounded, size: 50),
                    ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$atividade', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                   Text(
                    formatCommentedAt(at),
                      style: TextStyle(fontSize: 15),
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
  );
  }
}
}