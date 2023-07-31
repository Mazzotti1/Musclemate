
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/perfil_users/perfi_Users_page.dart';
import 'package:musclemate/widgets/home/Comment.dart';
import 'package:musclemate/widgets/home/PlaceholderPost.dart';
import 'package:musclemate/widgets/home/likesFromPost.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState()=> _FeedState();
}
class _FeedState extends State<Feed>{

 @override
  void initState() {
    super.initState();
    findMyTraining();
    findTraining();
    getLikesByUser();
    updateUser();
  }



    Map<int, bool> isLikedPost = {};
    Map<int, int> likedIds = {};

    List<int> postsIds = [];
    List<Map<String, dynamic>> trainingList = [];
    bool isLoading = true;
    String searchText = '';

    int userId = 0;

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

void _navigateToCommentPage(int postId, int userId) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Comment(postId: postId, userId:userId)),
  );
}

void _navigateToLikesPage(int postId) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LikesFromPost(postId: postId)),
  );
}

  Future<void> findTraining() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userId = (userTokenData['sub']);
  String url = '$apiUrl/treinos/feed/$userId';

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
    int postId = trainingData['id'];

    var tipoDeTreino = trainingData['tipoDeTreino'];
   if (tipoDeTreino is String) {
      tipoDeTreino = tipoDeTreino.replaceAll(RegExp(r'[\[\]"]'), '');
      tipoDeTreino = tipoDeTreino.replaceAll('\\', '');
    }
    int totalDeRepeticoes = trainingData['totalDeRepeticoes'];
    int mediaDePesoUtilizado = trainingData['mediaDePesoUtilizado'];
    String dataDoTreino = trainingData['dataDoTreino'];
    String tempo = trainingData['tempo'];
    int totalDeSeries = trainingData['totalDeSeries'];
    String userName = trainingData['user'] != null ? trainingData['user']['nome'] : '';
    String imageUrl = trainingData['user'] != null ? trainingData['user']['imageUrl'] : '';
    int userId = trainingData['user'] != null ? trainingData['user']['id'] : '';
    int likesCount = await getLikesByPost(postId);
    int commentsCount = await getCommentsByPost(postId);
    String fcmToken = trainingData['user'] != null ? trainingData['user']['fcmToken'] : '';
    bool likeNotification = trainingData['user'] != null ? trainingData['user']['likeNotification'] : false;

    trainingList.add({
      'postId':postId,
      'tipoDeTreino': tipoDeTreino,
      'totalDeRepeticoes': totalDeRepeticoes,
      'mediaDePesoUtilizado': mediaDePesoUtilizado,
      'dataDoTreino': dataDoTreino,
      'tempo': tempo,
      'totalDeSeries': totalDeSeries,
      'nome': userName,
      'imageUrl': imageUrl,
      'id':userId,
      'likesCount':likesCount,
      'commentsCount':commentsCount,
      'fcmToken':fcmToken,
      'likeNotification':likeNotification,
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

  Future<void> findMyTraining() async {
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

       for (var trainingData in responseData) {
    int postId = trainingData['id'];
    int userId = trainingData['user'] != null ? trainingData['user']['id'] : '';
    var tipoDeTreino = trainingData['tipoDeTreino'];
     if (tipoDeTreino is String) {
      tipoDeTreino = tipoDeTreino.replaceAll(RegExp(r'[\[\]"]'), '');
      tipoDeTreino = tipoDeTreino.replaceAll('\\', '');
    }
    print(tipoDeTreino);
    int totalDeRepeticoes = trainingData['totalDeRepeticoes'];
    int mediaDePesoUtilizado = trainingData['mediaDePesoUtilizado'];
    String dataDoTreino = trainingData['dataDoTreino'];
    String tempo = trainingData['tempo'];
    int totalDeSeries = trainingData['totalDeSeries'];
    String imageUrl = trainingData['user'] != null ? trainingData['user']['imageUrl'] : '';
    int likesCount = await getLikesByPost(postId);
    int commentsCount = await getCommentsByPost(postId);
    String userName = trainingData['user'] != null ? trainingData['user']['nome'] : '';
        setState(() {
        isLoading = false;
      });
    trainingList.add({
      'postId':postId,
      'id':userId,
      'tipoDeTreino': tipoDeTreino,
      'totalDeRepeticoes': totalDeRepeticoes,
      'mediaDePesoUtilizado': mediaDePesoUtilizado,
      'dataDoTreino': dataDoTreino,
      'tempo': tempo,
      'totalDeSeries': totalDeSeries,
      'imageUrl': imageUrl,
      'likesCount':likesCount,
      'commentsCount':commentsCount,
      'nome': userName,
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

Future<void> infoNotification(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);
  String userNameFollowing = (userData['nome']);
  String url = '$apiUrl/notifications/addNotification/$userId';

Map<String, dynamic> jsonData = {
  'atividade': '$userNameFollowing deu um like em sua atividade!',
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

Future<void> likeNotification(String fcmToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? serverKey = dotenv.env['FIREBASE_SERVER_KEY'];

    String token = prefs.getString('token')!;
    final userData = JwtDecoder.decode(token);
    String userIdLiker = (userData['sub']);

  Map<String, dynamic> notificationData = {
    'to': fcmToken,
    'notification': {
      'title': 'Novo Like!',
      'body': 'Você tem um novo like no seu treino!',
    },
    'data': {
      'type': 'like_notification',
      'Liker_id': userIdLiker,
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
      print(fcmToken);
    } else {
      print('Falha ao enviar a notificação push. Código de resposta: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao enviar a notificação push: $e');
  }
}

Future<void> addLike(int postId, String fcmToken, int userId, bool likeNotificationUser) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userIdMe = (userTokenData['sub']);
  String url = '$apiUrl/likes/addLike/$userIdMe/$postId';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
       final responseData = jsonDecode(response.body);
       final likeId = responseData['id'];
      setState(() {
        isLikedPost[postId] = true;
        likedIds[postId] = likeId;
      });

      if (likeNotificationUser == true) {
        likeNotification(fcmToken);
      }

       infoNotification(userId);
       setState(() {
         userId = userId;
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

Future<void> removeLike(int likeId, int postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];

  String url = '$apiUrl/likes/dislike/$likeId';

  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
 setState(() {

        isLikedPost[postId] = false;
        likedIds.remove(postId);

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

Future<void> getLikesByUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userId = (userTokenData['sub']);
  String url = '$apiUrl/likes/user/$userId';

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

      for (var likeData in responseData) {
        int likeId = likeData['id'] != null ? likeData['id'] : '';
        int postId = likeData['treinoId'] != null ? likeData['treinoId']['id'] : '';
        setState(() {
            isLikedPost[postId] = true;
             likedIds[postId] = likeId;
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

Future<int> getLikesByPost(int postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  String url = '$apiUrl/likes/treino/$postId';

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
      return responseData.length;
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
  return 0;
}

Future<int> getCommentsByPost(int postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  String url = '$apiUrl/comments/treino/$postId';

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
      return responseData.length;
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
  return 0;
}

Future<String?> getFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  return await messaging.getToken();
}

Future<void> updateUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  String? apiUrl = dotenv.env['API_URL'];

  String? fcmToken = await getFcmToken();
  String token = prefs.getString('token')!;

  final userData = JwtDecoder.decode(token);
  String userId = (userData['sub'] ?? '');

  String url = '$apiUrl/users/update/data/$userId';

  try {
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode(
        {"fcmToken": fcmToken}
        ),
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


Widget build(BuildContext context) {
  initializeDateFormatting();
  return Column(
    children: [
     Padding(
       padding: const EdgeInsets.only(top:25.0),
       child: Text(
            'Bom treino!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
     ),
      Expanded(
        child: isLoading  &&  trainingList.isEmpty
          ? const Center(
  child: Column(

    children: [
      SizedBox(height: 150,),
      Icon(
        Icons.warning,
        size: 48,
        color: Colors.yellow,
      ),
      SizedBox(height: 10),
      Text(
        'Ops...',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: Text(
          'Ainda não há nada no feed. Conecte-se com outros usuários para começar a ver os treinos de seus amigos!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
)
            : isLoading
                ?
                 Center(
              child: PlaceholderPost(),
            )
              : FutureBuilder<void>(
                  future: Future.delayed(Duration(milliseconds: 500)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {

                      return Center(
                        child: PlaceholderPost(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: trainingList.length,
                        itemBuilder: (context, index) {
                          var trainingData = trainingList.reversed.toList()[index];
                          String tipoDeTreino = trainingData['tipoDeTreino'];
                          int totalDeRepeticoes = trainingData['totalDeRepeticoes'];
                          int mediaDePesoUtilizado = trainingData['mediaDePesoUtilizado'];
                          String dataDoTreino = trainingData['dataDoTreino'];
                          DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dataDoTreino);
                          String dataFormatada = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR').format(dateTime);
                          String tempo = trainingData['tempo'];
                          int totalDeSeries = trainingData['totalDeSeries'];
                          String userName = trainingData['nome'] != null ? trainingData['nome'] : '';
                          String imageUrl = trainingData['imageUrl'] != null ? trainingData['imageUrl'] : '';
                          int userId = trainingData['id'] != null ? trainingData['id'] : '';
                          int postId = trainingData ['postId'] != null ? trainingData ['postId'] : '';
                          int likesCount = trainingData ['likesCount'] != null ? trainingData ['likesCount'] : '';
                          int commentsCount = trainingData ['commentsCount'] != null ? trainingData ['commentsCount'] : '';
                          String fcmToken = trainingData ['fcmToken'] != null ? trainingData ['fcmToken'] : '';
                          bool likeNotificationUser = trainingData['likeNotification'] != null ? trainingData['likeNotification'] : false ;
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, left: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          GestureDetector(
                                          onTap: () => _navigateToChoosedPerfil(userId.toString()),
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
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    userName,
                                                    style: TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 2.5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    dataFormatada,
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: EdgeInsets.only(left: 9),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Text('Hoje eu treinei $tipoDeTreino!',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('Duração',
                                                style: TextStyle(fontSize: 13)),
                                            Text(tempo,
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                          child: Container(
                                            height: 35,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text('Treino',
                                                style: TextStyle(fontSize: 13)),
                                            Text(tipoDeTreino,
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('Séries',
                                                style: TextStyle(fontSize: 13)),
                                            Text(totalDeSeries.toString(),
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                          child: Container(
                                            height: 35,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text('Média de peso utilizado',
                                                style: TextStyle(fontSize: 13)),
                                            Text('$mediaDePesoUtilizado kg',
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                          child: Container(
                                            height: 35,
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text('Repetições',
                                                style: TextStyle(fontSize: 13)),
                                            Text(totalDeRepeticoes.toString(),
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ),

                                ),
                                SizedBox(height: 10,),
                              Container(
                                        width: double.infinity,
                                        height: 10,
                                        color: const Color.fromRGBO(240, 240, 240, 1),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(left:50, top:0,),
                                  child: Row(
                                    children: [
                                        Column(
                                            children: [
                                              Row(
                                                children: [
                                             TextButton(
                                                  onPressed: () {
                                                   _navigateToLikesPage(postId);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Curtidas',
                                                        style: TextStyle(fontSize: 13, color: Colors.black),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        likesCount.toString(),
                                                        style: TextStyle(fontSize: 13, color: Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 130,),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  TextButton(
                                                  onPressed: () {
                                                   _navigateToCommentPage(postId, userId);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Comentários',
                                                        style: TextStyle(fontSize: 13, color: Colors.black),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        commentsCount.toString(),
                                                        style: TextStyle(fontSize: 13, color: Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                ],
                                              ),
                                            ],
                                          ),
                                       ],
                                    ),
                                ),
                                const SizedBox(height: 0,),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        color: const Color.fromRGBO(240, 240, 240, 1),
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (isLikedPost.containsKey(postId) && isLikedPost[postId] == true) {
                                                int? likeId = likedIds[postId];

                                                if (likeId != null) {
                                                  await removeLike(likeId, postId);
                                                  setState(() {
                                                    isLikedPost[postId] = false;
                                                   int currentLikes = trainingList.firstWhere((training) => training['postId'] == postId)['likesCount'];
                                                    trainingList.firstWhere((training) => training['postId'] == postId)['likesCount'] = currentLikes - 1;
                                                  });
                                                }
                                              } else {
                                                await addLike(postId, fcmToken, userId, likeNotificationUser);
                                                setState(() {
                                                 int currentLikes = trainingList
                                                .firstWhere((training) => training['postId'] == postId)['likesCount'];
                                                 trainingList.firstWhere((training) => training['postId'] == postId)
                                                ['likesCount'] = currentLikes + 1;



                                                  isLikedPost[postId] = true;
                                                });
                                              }
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              color: isLikedPost.containsKey(postId) && isLikedPost[postId] == true
                                                  ? Colors.red
                                                  : const Color.fromARGB(255, 39, 38, 38),
                                            ),
                                          ),
                                            VerticalDivider(
                                              color: Colors.grey,
                                              thickness: 1,
                                              width: 20,
                                              indent: 15,
                                              endIndent: 10,
                                            ),
                                           GestureDetector(
                                            onTap: () => _navigateToCommentPage(postId, userId),
                                            child: Icon(Icons.mode_comment),
                                          )
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 30,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                    }

                  },

                ),

      ),
       SizedBox(height: 30,)
    ],
  );
}
}