
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:musclemate/pages/forget_password/code_page.dart';

import 'package:shared_preferences/shared_preferences.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();



     void _navigateToCodePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CodePage ()),
    );
  }


  String capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}

String _errorMessage = '';


Future<void> sendResetPasswordEmail(String email) async {
  await dotenv.load();

  String? apiUrl = dotenv.env['API_URL'];
  String url = '$apiUrl/forgetPassword';
  email = capitalize(email);
  Map<String, String> requestBody = {'email': email};
  String jsonBody = json.encode(requestBody);

  try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {

        SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

        _navigateToCodePage();
        print('Email de redefinição de senha enviado com sucesso.');
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Email não encontrado.';
        });
      } else {
        setState(() {
          _errorMessage = 'Erro na solicitação: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro na solicitação: $e';
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  title: const Row(
    children: [
      Text(
        'Voltar',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    ],
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    color: Colors.black,
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  elevation: 1,
),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recuperação de senha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left:16.0, right: 16),
            child: Text(
                'Digite o seu email para receber o código de recuperação no seu email!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Text(
              _errorMessage,
              style: const TextStyle(

                color: Colors.red,
              ),
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email', labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),

                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text;
                      sendResetPasswordEmail(email);
                    },
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(230, 230, 230, 1))),
                    child: const Text('Enviar código', style: TextStyle(color: Colors.black)),
                  ),
               ],
              ),

            ),
          ),
        ],
      ),
    );
  }
}