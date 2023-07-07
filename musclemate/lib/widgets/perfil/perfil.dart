

import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/pages/perfil/followers/perfil_followers_page.dart';
import 'package:musclemate/pages/perfil/followers/perfil_following_page.dart';
import 'package:musclemate/pages/perfil/perfil_activitys_onpage.dart';

import 'package:musclemate/pages/perfil/perfil_edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/perfil/perfil_statistic_page.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';



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
    String userId = '';

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

String imageUrlController = '';

Future<void> selecionarImagem(String userId, String userName) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);

   final storage = FirebaseStorage.instance;
final storageRef = storage.ref().child('imagePerfil/$userName/$userId/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}');

    final uploadTask = storageRef.putFile(imageFile);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Upload em andamento: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
    }, onError: (Object e) {
      print('Erro durante o upload: $e');
    });

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    imageUrlController = downloadUrl;
      setState(() {
    imageUrlController = downloadUrl;
  });
    print('Imagem salva com sucesso: $downloadUrl');
    await updateUser();
  }
}

Map<String, dynamic> getModifiedFields() {
  Map<String, dynamic> modifiedFields = {};

  if (imageUrlController.isNotEmpty) {
    modifiedFields['imageUrl'] = imageUrlController;
  }

  return modifiedFields;
}

Future<void> updateUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  String? apiUrl = dotenv.env['API_URL'];

  String token = prefs.getString('token')!;

  final userData = JwtDecoder.decode(token);
  String userId = (userData['sub'] ?? '');

  String url = '$apiUrl/users/update/data/$userId';

  try {
    final modifiedFields = getModifiedFields();
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode(modifiedFields),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
        print('Url atualizada com sucesso');
    } else {
      print('Usuario não pode ser atualizado');
    }
  } catch (e) {
    print(e);
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
                onTap: () {
                  selecionarImagem(userId, userName);
                },
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
              child: const Column(
                children: [
                  Text('Seguindo', style: TextStyle(color: Color.fromRGBO(189, 172, 103, 1))),
                  SizedBox(width: 5),
                  Text('4', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),

            const SizedBox(width: 10),
            TextButton(
              onPressed:_navigateToFollowers,
              child: const Column(
                children: [
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
            const Padding(
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