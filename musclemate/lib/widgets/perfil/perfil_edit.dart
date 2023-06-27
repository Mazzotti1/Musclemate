
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    modifiedFields['nome'] = capitalizeFirstLetter(nomeController.text);
  }
  if (sobrenomeController.text.isNotEmpty) {
    modifiedFields['sobrenome'] = capitalizeFirstLetter(sobrenomeController.text);
  }
  if (cidadeController.text.isNotEmpty) {
    modifiedFields['cidade'] = capitalizeFirstLetter(cidadeController.text);
  }
   if (estadoController.text.isNotEmpty) {
    modifiedFields['estado'] = capitalizeFirstLetter(estadoController.text);
  }
    if (biografiaController.text.isNotEmpty) {
    modifiedFields['bio'] = capitalizeFirstLetter(biografiaController.text);
  }
   if (dataNascimentoController.text.isNotEmpty) {
    modifiedFields['dataDeNascimento'] = capitalizeFirstLetter(dataNascimentoController.text);
  }
   if (pesoController.text.isNotEmpty) {
    modifiedFields['peso'] = capitalizeFirstLetter(pesoController.text);
  }


  return modifiedFields;
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return '';

  return text[0].toUpperCase() + text.substring(1);
}

String _Message = '';
Color _messageColor = Colors.red;

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
  String userId = (userData['sub'] ?? '');

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
        nomeController.text = userData['nome'] ?? '';
        sobrenomeController.text = userData['sobrenome'] ?? '';
        cidadeController.text = userData['cidade'] ?? '';
        estadoController.text = userData['estado'] ?? '';
        biografiaController.text = userData['bio'] ?? '';
        dataNascimentoController.text = userData['dataDeNascimento'] ?? '';
        pesoController.text = userData['peso'] ?? '';
      });
    } else {
        setState(() {
      _Message = 'Erro: ${response.statusCode}';
    });
    }
  } catch (e) {
    setState(() {
      _Message = 'Erro: $e';
    });
  }
}

Future<void> updateUser(String id) async {
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
      setState(() {
        _Message = 'Usuário atualizado com sucesso';
        _messageColor = Colors.green;
      });
    } else {
      setState(() {
        _Message = 'Erro: ${response.statusCode}';
        _messageColor = Colors.red;
      });
    }
  } catch (e) {
    setState(() {
      _Message = 'Erro: $e';
      _messageColor = Colors.red;
    });
  }
}



@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
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
        Center(
        child: Text(
          _Message,
          style: TextStyle(
            color: _messageColor,
          ),
        ),
      ),

        const SizedBox(height: 10), // Espaço entre o ícone e a nova linha
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: sobrenomeController,
                          decoration: const InputDecoration(
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
         const SizedBox(height: 20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: cidadeController,
                          decoration: const InputDecoration(
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
                 const Padding(
                   padding: EdgeInsets.only(right:130.0),
                   child: Text(
                        'Estado',
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
                    children:  [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: estadoController,
                          decoration: const InputDecoration(
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
      const SizedBox(height: 20),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
           const Padding(
                   padding: EdgeInsets.only(right:0.0),
                   child: Text(
                        'Biografia',
                        style: TextStyle(color: Colors.black54),
                      ),
                 ),
          Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black45),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child:  Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: biografiaController,
                    decoration: const InputDecoration(
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

      const  SizedBox(height: 30),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [

          const Padding(
                   padding: EdgeInsets.only(right:0.0),
                   child: Text(
                        'Data de nascimento',
                        style: TextStyle(color: Colors.black54),
                      ),
                 ),
          Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black45),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: dataNascimentoController,
                    decoration: const InputDecoration(
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
   const SizedBox(height: 20),
        Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Padding(
                   padding: EdgeInsets.only(right:130.0),
                   child: Text(
                        'Gênero',
                        style: TextStyle(color: Colors.black54),
                      ),
                 ),
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
                const Padding(
                   padding: EdgeInsets.only(right:130.0),
                   child: Text(
                        'Peso',
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: pesoController,
                          decoration: const InputDecoration(
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
          onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? token = prefs.getString('token');
              if (token != null) {
                final userData = JwtDecoder.decode(token);
                String userId = (userData['sub'] ?? '');
                updateUser(userId);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color.fromRGBO(230, 230, 230, 1)),
            ),
            child: const Text('Concluído', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    ),
  )

      ]
    ),
  );
}
}