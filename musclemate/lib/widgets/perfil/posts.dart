
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/widgets/home/PlaceholderPost.dart';
import 'package:musclemate/widgets/perfil/CommentPerfil.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../home/likesFromPost.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState()=> _PostsState();
}
class _PostsState extends State<Posts>{

 @override
  void initState() {
    super.initState();
    fetchUserData();
    findTraining();

  }

    String userName = '';
    String userId = '';
    String imageUrlController = '';

    Map<int, bool> isLikedPost = {};
    Map<int, int> likedIds = {};

List<Map<String, dynamic>> trainingList = [];
String searchText = '';
bool isLoading = true;

void _navigateToCommentPage(int postId) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CommentPerfil(postId: postId)),
  );
}

void _navigateToLikesPage(int postId) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LikesFromPost(postId: postId)),
  );
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
        userName  =  userData['nome'] ?? '';
        userId =  userData['sub'] ?? '';
         imageUrlController = userData['imageUrl'] ?? '';
      });

      } else {
        print('${response.statusCode}');
      }
    } catch (e) {
      print('$e');
    }
  }

  Future<void> findTraining() async {
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
    int id = trainingData['id'];
    var tipoDeTreino = trainingData['tipoDeTreino'];
     if (tipoDeTreino is List) {
      tipoDeTreino = tipoDeTreino.join(" e ");
    } else if (tipoDeTreino is String) {
      tipoDeTreino = tipoDeTreino.replaceAll(RegExp(r'[\[\]"]'), '');
      tipoDeTreino = tipoDeTreino.replaceAll('\\', '');
    }
    int totalDeRepeticoes = trainingData['totalDeRepeticoes'];
    int mediaDePesoUtilizado = trainingData['mediaDePesoUtilizado'];
    String dataDoTreino = trainingData['dataDoTreino'];
    String tempo = trainingData['tempo'];
    int totalDeSeries = trainingData['totalDeSeries'];
    String imageUrl = trainingData['user'] != null ? trainingData['user']['imageUrl'] : '';
    int likesCount = await getLikesByPost(postId);
    int commentsCount = await getCommentsByPost(postId);
        setState(() {
        isLoading = false;
      });
    // Adicione as variáveis à lista
    trainingList.add({
      'postId':postId,
      'id': id,
      'tipoDeTreino': tipoDeTreino,
      'totalDeRepeticoes': totalDeRepeticoes,
      'mediaDePesoUtilizado': mediaDePesoUtilizado,
      'dataDoTreino': dataDoTreino,
      'tempo': tempo,
      'totalDeSeries': totalDeSeries,
      'imageUrl': imageUrl,
      'likesCount':likesCount,
      'commentsCount':commentsCount,
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

  @override
Widget build(BuildContext context) {
  initializeDateFormatting();
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 242, 242, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black45),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                          decoration: InputDecoration(
                            hintText: 'Pesquisar atividade pela data',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          'Você ainda não realizou nenhum treino! Aqui você pode ver suas atividades!',
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
      String imageUrl = trainingData['imageUrl'] != null ? trainingData['imageUrl'] : '';
      String tempo = trainingData['tempo'];
      int totalDeSeries = trainingData['totalDeSeries'];
      int likesCount = trainingData ['likesCount'] != null ? trainingData ['likesCount'] : '';
      int commentsCount = trainingData ['commentsCount'] != null ? trainingData ['commentsCount'] : '';
      int postId = trainingData ['postId'] != null ? trainingData ['postId'] : '';
      if (searchText.isNotEmpty &&
    !dataDoTreino.toLowerCase().contains(searchText.toLowerCase()) &&
    !dataFormatada.toLowerCase().contains(searchText.toLowerCase())) {
  // Retorna um item vazio se o texto de pesquisa não estiver contido na data do treino nem na data formatada
  return SizedBox.shrink();
}


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
                                SizedBox(height: 0,),
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
                                          SizedBox(width: 150,),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  TextButton(
                                                  onPressed: () {
                                                   _navigateToCommentPage(postId);
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
                                            onTap: () => _navigateToCommentPage(postId),
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
