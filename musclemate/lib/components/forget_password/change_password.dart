


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:musclemate/screen/Login&Register/login_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';



     void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage ()),
    );
  }

Future<String?> getEmailFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<void> changePassword(String email, String password) async {
  await dotenv.load();

  String? apiUrl = dotenv.env['API_URL'];
  String url = '$apiUrl/resetPassword';

  Map<String, String> requestBody = {'email': email, 'newPassword': password};
  String jsonBody = json.encode(requestBody);

  try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        _navigateToLogin();
        print('Senha redefinida com sucesso');
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Senha proibida';
        });
      } else {
  if (response.statusCode == 400) {
    final error = jsonDecode(response.body)['error'];
    setState(() {
      _errorMessage = 'Erro: $error';
    });
  } else {
    setState(() {
      _errorMessage = 'Erro: ${response.statusCode}';
    });
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
              'Troca de senha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left:16.0, right: 16),
            child: Text(
                'Digite a sua nova senha',
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
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Nova senha', labelStyle: TextStyle(color: Colors.black),
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
                    onPressed: () async {
                    String? email = await getEmailFromLocalStorage();
                    String password = _passwordController.text;
                    await changePassword(email!, password);
  },
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(230, 230, 230, 1))),
                    child: const Text('Mudar senha', style: TextStyle(color: Colors.black)),
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