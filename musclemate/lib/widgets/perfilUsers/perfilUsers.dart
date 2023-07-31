

import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:musclemate/pages/perfil/perfil_activitys_onpage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../pages/perfil_users/perfilUsers_activitys_page.dart';
import '../../pages/perfil_users/perfilUsers_statistic_page.dart';


class PerfilUsers extends StatefulWidget {
  const PerfilUsers({Key? key}) : super(key: key);

  @override
  _PerfilUsersState createState()=> _PerfilUsersState();
}
class _PerfilUsersState extends State<PerfilUsers>{

 void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilUsersStatisticPage()),
    );
  }

   void _navigateToActivitys() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilUsersActivitysPage()),
    );
  }

    void _navigateToFollowers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilActivitysOnPage()),
    );
  }
      void _navigateToFollowing() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PerfilActivitysOnPage()),
    );
  }

    String userName = '';
    String userId = '';
    String imageUrlController = '';
    String bio = '';
    List<Map<String, dynamic>> trainingList = [];
    String lastTrainingDate = '';
    String fcmToken = '';
    bool followNotificationUser = true;
     @override
  void initState() {
    super.initState();
    fetchUserData();
    findFollowing();
    findFollowers();
    findLastDate();
    getFolloweds();


  }


 Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    await dotenv.load(fileName: ".env");
    String? apiUrl = dotenv.env['API_URL'];

    String? userId = prefs.getString('choosedPerfil');
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
        userName  =  userData['nome'] ?? '';
        userId =  userData['sub'] ?? '';
        imageUrlController = userData['imageUrl'] ?? '';
        bio = userData['bio'] ?? '';
        fcmToken =userData['fcmToken'] ?? '';
        followNotificationUser = userData['followNotification'] ?? '';

      });
      } else {

      }
    } catch (e) {
      print('$e');
    }
  }


int seguindo = 0;
Future<void> findFollowing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    await dotenv.load(fileName: ".env");

    String? apiUrl = dotenv.env['API_URL'];

    String? userId = prefs.getString('choosedPerfil');
    String url = '$apiUrl/users/followed/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int numberOfIds = data.length;
      print(data);
      setState(() {
        seguindo = numberOfIds;
      });

    } else {
      print('${response.statusCode}');
    }
    } catch (e) {
      print('$e');
    }
  }

  int seguidores = 0;
Future<void> findFollowers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    await dotenv.load(fileName: ".env");

    String? apiUrl = dotenv.env['API_URL'];

    String? userId = prefs.getString('choosedPerfil');
    String url = '$apiUrl/users/followers/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int numberOfIds = data.length;
      setState(() {
        seguidores = numberOfIds;
      });

    } else {
      print('${response.statusCode}');
    }
    } catch (e) {
      print('$e');
    }
  }

   Future<void> findLastDate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];

  String? userId = prefs.getString('choosedPerfil');
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

       for (var trainingData in responseData) {
    String dataDoTreino = trainingData['dataDoTreino'];
    // Adicione as variáveis à lista
    trainingList.add({
      'dataDoTreino': dataDoTreino,
    });
     lastTrainingDate = dataDoTreino;
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

Future<void> infoNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);
  String? userPerfilId = prefs.getString('choosedPerfil');
  String userNameFollowing = (userData['nome']);
  String url = '$apiUrl/notifications/addNotification/$userPerfilId';

Map<String, dynamic> jsonData = {
  'atividade': '$userNameFollowing comecou a seguir voce!',
};

    String jsonString = jsonEncode(jsonData);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
       body: jsonString
    );

    if (response.statusCode == 200) {
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

Future<void> followNotification() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? serverKey = dotenv.env['FIREBASE_SERVER_KEY'];

    String token = prefs.getString('token')!;
    final userData = JwtDecoder.decode(token);
    String userIdFollower = (userData['sub']);

  Map<String, dynamic> notificationData = {
    'to': fcmToken,
    'notification': {
      'title': 'Novo seguidor',
      'body': 'Você tem um novo seguidor!',
    },
    'data': {
      'type': 'follow_notification',
      'follower_id': userIdFollower,
    },
  };

  try {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      print('Notificação push enviada com sucesso!');

    } else {
      print('Falha ao enviar a notificação push. Código de resposta: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao enviar a notificação push: $e');
  }
}


  Follow() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);

  String userId = (userData['sub']);
  String? userPerfilId = prefs.getString('choosedPerfil');
  String url = '$apiUrl/users/follow';

Map<String, dynamic> bodyData = {
  'follower': {'id': int.parse(userId)},
  'followed': {'id': int.parse(userPerfilId!)},

};

Map<String, dynamic> jsonData = {
  'follower': {'id': bodyData['follower']['id']},
  'followed': {'id': bodyData['followed']['id']},

};

    String jsonString = jsonEncode(jsonData);
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
       body: jsonString
    );

    if (response.statusCode == 200) {
       setState(() {
      nomesFolloweds.add(userName);
      seguidores += 1;
    });

    if (followNotificationUser == true) {
       followNotification();
    }

     infoNotification();
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

Unfollow() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);

  String userId = (userData['sub']);
  String? userPerfilId = prefs.getString('choosedPerfil');
  String url = '$apiUrl/users/unfollow';

Map<String, dynamic> bodyData = {
  'follower': {'id': int.parse(userId)},
  'followed': {'id': int.parse(userPerfilId!)},
};

Map<String, dynamic> jsonData = {
  'follower': {'id': bodyData['follower']['id']},
  'followed': {'id': bodyData['followed']['id']},
};

    String jsonString = jsonEncode(jsonData);
  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
       body: jsonString
    );

    if (response.statusCode == 200) {
       setState(() {
      nomesFolloweds.remove(userName);
      seguidores -= 1;
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

List<String> nomesFolloweds = [];

Future<void> getFolloweds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    await dotenv.load(fileName: ".env");

    String? apiUrl = dotenv.env['API_URL'];

      final userData = JwtDecoder.decode(token);
    String userId = (userData['sub']);

    String url = '$apiUrl/users/followed/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<String> nomes = [];

      for (var item in data) {
        String nome = item['nome'];
        nomes.add(nome);
      }
      print(nomes);
       setState(() {
        nomesFolloweds = nomes ;
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
          padding: EdgeInsets.only(top: 30.0, left: 40.0),
          child: Column(
            children: [
              GestureDetector(

                  child: imageUrlController.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.network(
                          imageUrlController,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      )
                    : Icon(Icons.person_outline_rounded, size: 50),
              ),
            ],
          ),
        ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontSize: 18),
                        ),

                      ],

                    ),

                  ),
                  SizedBox(height: 3,),
                   Text(bio),
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
              child:  Column(
                children: [
                  Text('Seguindo', style: TextStyle(color: Color.fromRGBO(189, 172, 103, 1))),
                  SizedBox(width: 5),
                  Text(
                seguindo.toString(),
                style: TextStyle(color: Colors.black),
                  ),

                ],
              ),
            ),

            const SizedBox(width: 10),
            TextButton(
              onPressed:_navigateToFollowers,
              child:  Column(
                children: [
                  Text('Seguidores', style: TextStyle(color: Color.fromRGBO(189, 172, 103, 1))),
                  SizedBox(width: 5),
                   Text(
                seguidores.toString(),
                style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
           ElevatedButton(
          onPressed: () {
            if (nomesFolloweds.contains(userName)) {
              Unfollow();
            } else {
              Follow();
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                nomesFolloweds.contains(userName)
                    ? Color.fromARGB(209, 240, 225, 91) // cor para unfollow
                    : Colors.blue // cor para follow
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            minimumSize: MaterialStateProperty.all<Size>(const Size(30, 30)),
          ),
          child: Text(
            nomesFolloweds.contains(userName) ? 'Deixar de Seguir' : 'Seguir',
          ),
        )
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
              padding: EdgeInsets.only(top:20.0, left: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(Icons.insert_chart_outlined, size: 50),
                    ],
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Atividades'),
                      SizedBox(height: 5),
                      Text(
                        lastTrainingDate,
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
    onTap: _navigateToStatistics,
     child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top:20.0, left: 20),
          child: Row(
            children: [
              Column(
                children: [
                  Icon(Icons.show_chart_outlined, size: 50),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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