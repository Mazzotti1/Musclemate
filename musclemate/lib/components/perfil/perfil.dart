

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/screen/perfil/followers/perfil_followers_page.dart';
import 'package:musclemate/screen/perfil/followers/perfil_following_page.dart';
import 'package:musclemate/screen/perfil/perfil_activitys_onpage.dart';

import 'package:musclemate/screen/perfil/perfil_edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screen/perfil/perfil_statistic_page.dart';

import 'package:http/http.dart' as http;

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState()=> _PerfilState();
}
class _PerfilState extends State<Perfil>{

 void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilStatisticPage()),
    );
  }

 void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilEditPage()),
    );
  }
   void _navigateToActivitys() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilActivitysOnPage()),
    );
  }

    void _navigateToFollowers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilFollowersPage()),
    );
  }
      void _navigateToFollowing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilFollowingPage()),
    );
  }

    String userName = '';

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
        userName=  userData['nome'] ?? '';

      });

      } else {
        print('${response.statusCode}');
      }
    } catch (e) {
      print('$e');
    }
  }



@override
Widget build(BuildContext context) {
  return Column(
    children: [
       Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top:30.0, left: 40.0),
            child: Column(
              children: [
                Icon(Icons.person_outline_rounded, size: 50),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top:20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 0,),
      Padding(
        padding: const EdgeInsets.only(left:40.0),
        child: Row(
          children: [
            TextButton(
              onPressed: _navigateToFollowing,
              child: Column(
                children: const [
                  Text('Seguindo', style: TextStyle(color: Color.fromRGBO(189, 172, 103, 1))),
                  SizedBox(width: 5),
                  Text('4', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),

            const SizedBox(width: 10),
            TextButton(
              onPressed:_navigateToFollowers,
              child: Column(
                children: const [
                  Text('Seguidores', style: TextStyle(color: Color.fromRGBO(189, 172, 103, 1))),
                  SizedBox(width: 5),
                  Text('6', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(width: 60),
            OutlinedButton.icon(
              onPressed: _navigateToEdit,
              icon: const Icon(Icons.edit, color: Color.fromRGBO(189, 172, 103, 1,), size: 18,),
              label: const Text('Editar', style: TextStyle(color: Color.fromRGBO(189, 172, 103, 1))),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(30, 30)),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10,),
      Container(
        width: double.infinity,
        height: 15,
        color: const Color.fromRGBO(242, 242, 242, 1),
      ),
      InkWell(
        onTap: _navigateToActivitys,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:20.0, left: 20),
              child: Row(
                children: [
                  Column(
                    children: const [
                      Icon(Icons.insert_chart_outlined, size: 50),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Atividades'),
                      SizedBox(height: 5),
                      Text(
                        '10 de março de 2023',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 0.6,
          color: Colors.black,
        )
      ],
    ),
  ),
   InkWell(
    //Função pra levar para algum lugar
    onTap: _navigateToStatistics,
     child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:20.0, left: 20),
          child: Row(
            children: [
              Column(
                children: const [
                  Icon(Icons.show_chart_outlined, size: 50),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Estatísticas'),
                    SizedBox(height: 5),
                    Text('...',
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
     ),
   ),
      ],

    );

  }
}