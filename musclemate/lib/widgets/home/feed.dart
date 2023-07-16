
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/perfil_users/perfi_Users_page.dart';
import 'package:musclemate/widgets/home/PlaceholderPost.dart';

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
    findTraining();
  }



    List<Map<String, dynamic>> trainingList = [];
    bool isLoading = true;
    String searchText = '';

void _navigateToChoosedPerfil(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('choosedPerfil', userId);

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PerfilPageUsers()),
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

    String tipoDeTreino = trainingData['tipoDeTreino'];
    int totalDeRepeticoes = trainingData['totalDeRepeticoes'];
    int mediaDePesoUtilizado = trainingData['mediaDePesoUtilizado'];
    String dataDoTreino = trainingData['dataDoTreino'];
    String tempo = trainingData['tempo'];
    int totalDeSeries = trainingData['totalDeSeries'];
    String userName = trainingData['user'] != null ? trainingData['user']['nome'] : '';
    String imageUrl = trainingData['user'] != null ? trainingData['user']['imageUrl'] : '';
    int userId = trainingData['user'] != null ? trainingData['user']['id'] : '';
    trainingList.add({

      'tipoDeTreino': tipoDeTreino,
      'totalDeRepeticoes': totalDeRepeticoes,
      'mediaDePesoUtilizado': mediaDePesoUtilizado,
      'dataDoTreino': dataDoTreino,
      'tempo': tempo,
      'totalDeSeries': totalDeSeries,
      'nome': userName,
      'imageUrl': imageUrl,
      'id':userId
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
                                            hintText: 'Pesquisar novas pessoas',
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
                      );
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
                                const SizedBox(height: 15,),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        color: const Color.fromRGBO(240, 240, 240, 1),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.favorite),
                                            VerticalDivider(
                                              color: Colors.grey,
                                              thickness: 1,
                                              width: 20,
                                              indent: 15,
                                              endIndent: 10,
                                            ),
                                            Icon(Icons.mode_comment),
                                          ],
                                        ),
                                      ),
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
    ],
  );
}
}