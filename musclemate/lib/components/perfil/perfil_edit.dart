
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class PerfilEdit extends StatefulWidget {
  const PerfilEdit({Key? key}) : super(key: key);

@override
  _PerfilEditState createState()=> _PerfilEditState();
}
class _PerfilEditState extends State<PerfilEdit>{

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController biografiaController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();

  Map<String, dynamic> getModifiedFields() {
  Map<String, dynamic> modifiedFields = {};

  if (nomeController.text.isNotEmpty) {
    modifiedFields['nome'] = nomeController.text;
  }
  if (sobrenomeController.text.isNotEmpty) {
    modifiedFields['sobrenome'] = sobrenomeController.text;
  }
  if (cidadeController.text.isNotEmpty) {
    modifiedFields['cidade'] = cidadeController.text;
  }
   if (estadoController.text.isNotEmpty) {
    modifiedFields['estado'] = estadoController.text;
  }
    if (biografiaController.text.isNotEmpty) {
    modifiedFields['bio'] = biografiaController.text;
  }
   if (dataNascimentoController.text.isNotEmpty) {
    modifiedFields['dataDeNascimento'] = dataNascimentoController.text;
  }
   if (pesoController.text.isNotEmpty) {
    modifiedFields['peso'] = pesoController.text;
  }



  return modifiedFields;
}


Future<void> updateUser(String id) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];

     String url = '$apiUrl/users/update/data/122';

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

      print('Usuário atualizado');
    } else {

      print('Erro durante a atualização do usuário: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro durante a solicitação HTTP: $e');
  }
}

Future<void> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token != null) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    nomeController.text = decodedToken['nome'] ?? '';
    sobrenomeController.text = decodedToken['sobrenome'] ?? '';
    cidadeController.text = decodedToken['cidade'] ?? '';
    estadoController.text = decodedToken['estado'] ?? '';
    biografiaController.text = decodedToken['bio'] ?? '';
    dataNascimentoController.text = decodedToken['dataDeNascimento'] ?? '';
    pesoController.text = decodedToken['peso'] ?? '';
  }
}
 @override
void didChangeDependencies() {
  super.didChangeDependencies();
  fetchUserData();
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      const Padding(
        padding: EdgeInsets.only(top:40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline_rounded, size: 90),
            SizedBox(width: 20),
          ],
        ),
      ),
      const SizedBox(height: 20), // Espaço entre o ícone e a nova linha
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
               const Padding(
                 padding: EdgeInsets.only(right:130.0),
                 child: Text(
                      'Nome',
                      style: TextStyle(color: Colors.black54),
                    ),
               ),
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Digite seu nome',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           const SizedBox(width: 20),
          Column(
            children: [
               const Padding(
                 padding: EdgeInsets.only(right:90.0),
                 child: Text(
                      'Sobrenome',
                      style: TextStyle(color: Colors.black54),
                    ),
               ),
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: sobrenomeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Digite seu sobrenome',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

      ),
       const SizedBox(height: 40),
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: cidadeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Cidade',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           const SizedBox(width: 20),
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: estadoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Estado',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],

      ),
    const SizedBox(height: 40),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Column(
      children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black45),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child:  Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: biografiaController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Biografia',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),

    const  SizedBox(height: 60),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Column(
      children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black45),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: dataNascimentoController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Data de nascimento',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),
 const SizedBox(height: 40),
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                          decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Gênero',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           const SizedBox(width: 20),
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: pesoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Peso',
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ],
      ),
          Padding(
  padding: const EdgeInsets.all(16.0),
  child: Center(
    child: Column(
      children: [
        ElevatedButton(
        onPressed: () {
            updateUser('122');
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Color.fromRGBO(230, 230, 230, 1)),
          ),
          child: const Text('Concluído', style: TextStyle(color: Colors.black)),
        ),
      ],
    ),
  ),
)

    ]
  );
}
}