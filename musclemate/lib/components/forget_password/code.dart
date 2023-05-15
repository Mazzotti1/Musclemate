
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:musclemate/screen/forget_password/change_password_page.dart';


import 'package:shared_preferences/shared_preferences.dart';

class Code extends StatefulWidget {
  const Code({Key? key}) : super(key: key);

  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {
  final TextEditingController _codeController = TextEditingController();

  String _errorMessage = '';

   void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage ()),
    );
  }

Future<String?> getEmailFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<void> verifyCode(String email, String code) async {
  await dotenv.load();

  String? apiUrl = dotenv.env['API_URL'];
  String url = '$apiUrl/sendCode';

  Map<String, String> requestBody = {'email': email, 'recoveryCode':code};
  String jsonBody = json.encode(requestBody);

  try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        _navigateToChangePassword();
        print('O código esta correto');
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Código não está correto.';
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
      title: const Text(
        'Voltar',
        style: TextStyle(
          fontSize: 18,
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
    body: Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _codeController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: '0 - 0 - 0 - 0',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
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
                    String code = _codeController.text;
                    await verifyCode(email!, code);
  },
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(230, 230, 230, 1))),
                    child: const Text('Verificar código', style: TextStyle(color: Colors.black)),
                  ),
               ],
              ),

            ),
          )
            ],
          ),
        ),
      ),
    ),
  );
}
}