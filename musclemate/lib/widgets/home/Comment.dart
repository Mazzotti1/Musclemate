
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/perfil_users/perfi_Users_page.dart';
import 'package:musclemate/widgets/home/PlaceholderComments.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;



class Comment extends StatefulWidget {
  final int postId;
  const Comment({Key? key, required this.postId}) : super(key: key);

@override
  _CommentState createState()=> _CommentState();
}
class _CommentState extends State<Comment>{

  bool isLoading = true;
  String newComment = '';

  void _onCommentChanged(String text) {
    setState(() {
      newComment = text;
    });
  }

  @override
  void initState() {
    super.initState();
    int postId = widget.postId;
    getCommentsByPost(postId);
  }

void _navigateToChoosedPerfil(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('choosedPerfil', userId);

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PerfilPageUsers()),
  );
}

List<Map<String, dynamic>> commentsList = [];

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

Future<void> addComment(int postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token')!;

  await dotenv.load(fileName: ".env");

  String? apiUrl = dotenv.env['API_URL'];
  final userTokenData = JwtDecoder.decode(token);
  String userId = (userTokenData['sub']);
  String url = '$apiUrl/comments/addComment/$userId/$postId';

  try {
    Map<String, dynamic> requestBody = {
      'commentText': 'Este é um comentário de exemplo.',
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
      final responseData = jsonDecode(response.body);
      final commentId = responseData['id'];

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

void _submitComment() {

    setState(() {
      commentsList.add({
        'userName': 'Your Username',
        'commentText': newComment,
      });

      newComment = '';
    });
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Comentários'),
      centerTitle: true,
      backgroundColor: Colors.black,
    ),
    body:  isLoading
        ? Center(
          )
        : commentsList.isEmpty
            ? Center(
                child: Text(
                  'Nenhum comentário disponível ainda.',
                  style: TextStyle(fontSize: 20),
                ),
              )
            :

                ListView.builder(
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
                                              onTap: () =>
                                                  _navigateToChoosedPerfil(userId.toString()),
                                              child: imageUrl.isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(30.0),
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
                                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
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
                                              padding: const EdgeInsets.only( right:20, top:6),
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


  );
}
}
