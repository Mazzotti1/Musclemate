
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class changeEmail extends StatefulWidget {
  const changeEmail({Key? key}) : super(key: key);

  @override
  _changeEmailState createState()=> _changeEmailState();
}
class _changeEmailState extends State<changeEmail>{

    final emailController = (TextEditingController());


  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }


String _Message = '';
Color _messageColor = Colors.red;

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return '';

  return text[0].toUpperCase() + text.substring(1);
}

   Future<void> changeUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    await dotenv.load(fileName: ".env");

    String? apiUrl = dotenv.env['API_URL'];

    final userData = JwtDecoder.decode(token);
    String userId = (userData['sub']);
    String url = '$apiUrl/users/update/email/$userId';



    Map<String, dynamic> userBody = {
    'email': capitalizeFirstLetter(emailController.text),
  };
    String jsonData = jsonEncode(userBody);

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        setState(() {
          _Message = 'Usuário atualizado com sucesso';
          _messageColor = Colors.green;
            });
      } else {
         final error = jsonDecode(response.body)['error'];
    setState(() {
      _Message = 'Erro: $error';
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
  return Column(
    children: [
      const SizedBox(height: 50),
      const Text(
        'Passe seu novo email',
        style: TextStyle(fontSize: 17, color: Colors.black45),
      ),
      const SizedBox(height: 40),
       const Row(
         children: [
           SizedBox(width: 20),
           Text(
            'Email',
            style: TextStyle(fontSize: 17, color: Colors.black),
      ),
         ],
       ),
      TextField(
        controller: emailController,
        decoration: const InputDecoration(
          hintText: 'Ex:. joão@gmail.com',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 126, 9, 9),
              width: 200,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: Text(
          _Message,
          style: TextStyle(
            color: _messageColor,
          ),
        ),
      ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Column(
        children: [
          ElevatedButton(
          onPressed: ()  {
              changeUserEmail();
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color.fromRGBO(230, 230, 230, 1)),
            ),
            child: const Text('Concluído', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 20,),
      const Text(
        'Lembre-se, se você criou sua conta com Google, e mudar seu email, sua conta será excluída e será criado uma nova no lugar ao logar novamente!',
        style: TextStyle(fontSize: 17, color: Colors.black45), textAlign: TextAlign.center,
      ),
      const Text(
        'Você irá perder todos os dados da conta!',
        style: TextStyle(fontSize: 17, color: Colors.red), textAlign: TextAlign.center,
      ),
        ],

      ),

    ),
  )
    ],

  );
}
}