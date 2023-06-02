import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musclemate/pages/Login&Register/login_page.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();



   void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage ()),
    );
  }

  String capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}


  String _errorMessage = '';

  Future<void> registerUser() async {
    await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];

     String url = '$apiUrl/users/register';

  Map<String, dynamic> userData = {
    'nome': capitalize(_nomeController.text),
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
  print('Usuário registrado com sucesso');
  _navigateToLogin();
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
  // Trate o erro de acordo com sua necessidade
}
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Voltar',
          style: TextStyle(
            color: Colors.black,
          ),
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
              'Cadastrar-se com o email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
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
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome', labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),

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
           const Padding(
             padding: EdgeInsets.only(left:16.0),
             child: Text(
                    'A senha deve conter no mínimo 6 caracteres',
                    style: TextStyle(fontSize: 12),
                  ),
           ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: registerUser,
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(230, 230, 230, 1))),
                    child: const Text('Cadastrar-se', style: TextStyle(color: Colors.black)),
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