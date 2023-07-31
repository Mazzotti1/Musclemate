
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/Feed_page.dart';
import 'package:musclemate/pages/perfil_users/perfi_Users_page.dart';
import 'package:musclemate/widgets/home/PlaceholderComments.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;



class Comment extends StatefulWidget {
  final int postId;
  final int userId;
   Comment({Key? key, required this.postId, required this.userId,}) : super(key: key);

@override
  _CommentState createState()=> _CommentState();
}
class _CommentState extends State<Comment>{

  bool isLoading = true;
  final TextEditingController commentController = TextEditingController();

bool commentNotificationUser = true;
String fcmToken = '';
  @override
  void initState() {
    super.initState();
     fetchUserData();
    int postId = widget.postId;
    getCommentsByPost(postId);
  }




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


void _navigateToFeed() async {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedPage()),
    );
}

List<Map<String, dynamic>> commentsList = [];
String imageUrlFix = '';
String userNameFix = '';
String userIdFix = '';

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
        userNameFix  =  userData['nome'] ?? '';
        userIdFix =  userData['sub'] ?? '';
        imageUrlFix = userData['imageUrl'] ?? '';
      });

      } else {
        print('${response.statusCode}');
      }
    } catch (e) {
      print('$e');
    }
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

     for (var postData in responseData) {
        String userName = postData['user']['nome'];
        String imageUrl = postData['user']['imageUrl'];
        String commentText = postData['commentText'];
        String commentedAt = postData['commented_at'];
        int userId = postData['user'] != null ? postData['user']['id'] : '';
        String fcmToken = postData['treinoId']['user'] != null ? postData['treinoId']['user']['fcmToken'] : '';
        bool commentNotificationUser = postData['treinoId']['user'] != null ? postData['treinoId']['user']['commentNotification'] : false;

    commentsList.add({
      'userName':userName,
      'imageUrl': imageUrl,
      'commentText': commentText,
      'commentedAt': commentedAt,
      'id':userId,
      'fcmToken':fcmToken,
      'commentNotification':commentNotificationUser,
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
        print('Erro: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Erro: $e');
  }
  return 0;
}

String formatCommentedAt(String commentedAt) {
  DateTime originalDateTime = DateTime.parse(commentedAt).toLocal();
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

Future<void> infoNotification(int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;
  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userData = JwtDecoder.decode(token);
  String userNameFollowing = (userData['nome']);
  String url = '$apiUrl/notifications/addNotification/$userId';

Map<String, dynamic> jsonData = {
  'atividade': '$userNameFollowing comentou na sua atividade!',
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

Future<void> commentNotification(String fcmToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? serverKey = dotenv.env['FIREBASE_SERVER_KEY'];

    String token = prefs.getString('token')!;
    final userData = JwtDecoder.decode(token);
    String userIdCommenter = (userData['sub']);

  Map<String, dynamic> notificationData = {
    'to': fcmToken,
    'notification': {
      'title': 'Novo Comentário!',
      'body': 'Você tem um novo comentário no seu treino!',
    },
    'data': {
      'type': 'comment_notification',
      'Commenter_id': userIdCommenter,
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

Future<void> addComment(int postId, String commentText, String fcmToken, int userId, bool commentNotificationUser) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userIdMe = (userTokenData['sub']);
  String url = '$apiUrl/comments/addComment/$userIdMe/$postId';

  try {
    Map<String, dynamic> requestBody = {
      'commentText': commentText,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
       print('Comentário feito');

    } else {
      if (response.statusCode == 400) {
        final error = jsonDecode(response.body)['error'];
        print('Erro: $error');
      } else {
        print('Erro: ${response.statusCode}');
    if (commentNotificationUser == true) {
         commentNotification(fcmToken);
    }
         infoNotification(userId);
      }
    }
  } catch (e) {
    print('Erro: $e');

  }
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: Colors.black,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      IconButton(
        onPressed: _navigateToFeed,
        icon: const Icon(Icons.arrow_back),
      ),
      Text('Comentários'),
    ],
  ),
),


    body: Column(
      children: [
        Visibility(
          visible: isLoading,
          child: Center(),
        ),
        Visibility(
          visible: !isLoading && commentsList.isEmpty,
          child: Expanded(
            child: Center(
              child: Text(
                'Nenhum comentário disponível ainda.',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isLoading && commentsList.isNotEmpty,
          child: Expanded(

            child: ListView.builder(
              itemCount: commentsList.length,
              itemBuilder: (context, index) {
                          var postData = commentsList.reversed.toList()[index];
                          String userName = postData['userName'];
                          String imageUrl = postData['imageUrl'];
                          String commentText = postData['commentText'];
                          String commentedAt = postData['commentedAt'];
                          int userId = postData['id'] != null ? postData['id'] : '';
                          fcmToken = postData['fcmToken'] != null ? postData['fcmToken'] : '';
                           commentNotificationUser = postData['commentNotification'] != null ? postData['commentNotification']: false ;
                          return FutureBuilder<void>(
                            future: Future.delayed(Duration(milliseconds: 500)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: PlaceholderComments(),
                                );
                              } else {
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
                                                            width: 40,
                                                            height: 40,
                                                          ),
                                                        )
                                                      : Icon(Icons.person_outline_rounded, size: 40),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 0.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          userName,
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              formatCommentedAt(commentedAt),
                                                              style: TextStyle(fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 20, top: 6),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            commentText,
                                                            style: TextStyle(fontSize: 15),
                                                          ),
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
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                 ),
        Container(
          padding: const EdgeInsets.only(bottom: 50.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: imageUrlFix.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.network(
                          imageUrlFix,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      )
                    : Icon(Icons.person_outline_rounded, size: 40),
              ),
              Expanded(
                child: Container(

                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Comentar como $userNameFix",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () async {
                  String commentText = commentController.text;
                  int postId = widget.postId;
                  int userId = widget.userId;
                    if (commentText.isNotEmpty) {
                     await addComment(postId, commentText, fcmToken, userId, commentNotificationUser);
                      commentController.clear();
                    }
                  setState(() {
                      commentsList.clear();
                      getCommentsByPost(postId);
                  });
                },

                child: Text(
                  "Publicar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
}

