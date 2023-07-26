import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:musclemate/widgets/home/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musclemate/pages/forget_password/forget_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musclemate/widgets/google/google_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

   void _navigateToFeed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage ()),
    );
  }

     void _navigateToForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordPage ()),
    );
  }

  String capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}


  String _errorMessage = '';


  Future<void> loginUser() async {

    await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];

     String url = '$apiUrl/users/login';

  Map<String, dynamic> userData = {
    'email': capitalize(_emailController.text),
    'password': _senhaController.text,
  };

    String jsonData = jsonEncode(userData);
try {
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonData,
  );

 if (response.statusCode == 200) {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', response.body);

  print(response.body);
  _navigateToFeed();
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
  title: Row(
    children: [
      const Text(
        'Voltar',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      const Spacer(),
      TextButton(
        onPressed: loginUser,
        child: const Text(
          'Fazer login',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
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
         const GoogleButton(),
          Center(
            child: Text(
            _errorMessage,
            style: const TextStyle(

              color: Colors.red,
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
            child: TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha', labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),

              ),

            ),

          ),
          Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextButton(
                onPressed: _navigateToForgetPassword,
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black54,
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
                    onPressed: loginUser,
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(230, 230, 230, 1))),
                    child: const Text('Fazer Login', style: TextStyle(color: Colors.black)),
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