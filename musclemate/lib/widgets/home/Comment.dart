
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

   Comment({Key? key, required this.postId}) : super(key: key);

@override
  _CommentState createState()=> _CommentState();
}
class _CommentState extends State<Comment>{

  bool isLoading = true;
  final TextEditingController commentController = TextEditingController();


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
    commentsList.add({
      'userName':userName,
      'imageUrl': imageUrl,
      'commentText': commentText,
      'commentedAt': commentedAt,
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
        print('Erro: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Erro: $e');
  }
  return 0;
}

String formatCommentedAt(String commentedAt) {
  DateTime originalDateTime = DateTime.parse(commentedAt);
  DateTime now = DateTime.now();

  int differenceInMinutes = now.difference(originalDateTime).inMinutes;
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
  } else {
    return "há $minutes ${minutes == 1 ? 'minuto' : 'min'}";
  }
}

Future<void> addComment(int postId, String commentText) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userId = (userTokenData['sub']);
  String url = '$apiUrl/comments/addComment/$userId/$postId';

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
                    if (commentText.isNotEmpty) {
                     await addComment(postId, commentText);
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

