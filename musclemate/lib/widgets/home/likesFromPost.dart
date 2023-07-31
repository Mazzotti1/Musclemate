
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/Feed_page.dart';
import 'package:musclemate/pages/perfil_users/perfi_Users_page.dart';
import 'package:musclemate/widgets/home/PlaceholderComments.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;



class LikesFromPost extends StatefulWidget {
  final int postId;
   LikesFromPost({Key? key,required this.postId,}) : super(key: key);

@override
  _LikesFromPostState createState()=> _LikesFromPostState();
}
class _LikesFromPostState extends State<LikesFromPost>{

  bool isLoading = true;
  List<Map<String, dynamic>> likesList = [];


  @override
  void initState() {
    super.initState();
    int postId = widget.postId;
    getLikesByPost(postId);
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

     for (var likesData in responseData) {
        String userName = likesData['user']['nome'];
        String imageUrl = likesData['user']['imageUrl'];
        int userId = likesData['user'] != null ? likesData['user']['id'] : '';
        String likedAt = likesData['liked_at'];
    likesList.add({
      'userName':userName,
      'imageUrl': imageUrl,
      'id':userId,
      'liked_at':likedAt,
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
      Text('Curtidas'),
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
          visible: !isLoading && likesList.isEmpty,
          child: Expanded(
            child: Center(
              child: Text(
                'Nenhuma curtida ainda.',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isLoading && likesList.isNotEmpty,
          child: Expanded(

            child: ListView.builder(
              itemCount: likesList.length,
              itemBuilder: (context, index) {
                          var postData = likesList.reversed.toList()[index];
                          String userName = postData['userName'];
                          String imageUrl = postData['imageUrl'];
                          int userId = postData['id'] != null ? postData['id'] : '';
                          String likedAt = postData['liked_at'];
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
                                                              formatCommentedAt(likedAt),
                                                              style: TextStyle(fontSize: 15),
                                                            ),
                                                          ],
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
      ],
    ),
  );
}
}

