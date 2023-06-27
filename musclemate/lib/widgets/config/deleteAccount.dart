
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../pages/Login&Register/welcome_page.dart';

class deleteAccount extends StatefulWidget {
  const deleteAccount({Key? key}) : super(key: key);

@override
  _deleteAccountState createState()=> _deleteAccountState();
}
class _deleteAccountState extends State<deleteAccount>{




    Future<void> deleteUser() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String token = prefs.getString('token')!;
     await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];

     final userData = JwtDecoder.decode(token);
     String userId = (userData['sub']);
     String url = '$apiUrl/users/$userId';

     try {
       final response = await http.delete(
         Uri.parse(url),
         headers: {
           'Content-Type': 'application/json',
           'Authorization': 'Bearer $token',
         },
       );

       if (response.statusCode == 200) {
          print('usuario deletado');
       } else {
         print('Erro ao deletar a conta');
       }
     } catch (e) {
        print(e);
     }
}

 void _showDialog(BuildContext context) async {
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar exclusão',textAlign: TextAlign.center,),
      content: const Text('Tem certeza de que deseja excluir sua conta?', textAlign: TextAlign.center,),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o alerta
              },
            ),
            TextButton(
              child: const Text(
                'Deletar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (Route<dynamic> route) => false,
                );
                deleteUser();
              },
            ),
          ],
        ),
      ],
    );
  },
);
}

@override
Widget build(BuildContext context) {
  return TextButton(
                onPressed: () {
                  _showDialog(context);
                },
                child: const Text('Excluir sua conta',
                  style: TextStyle(fontSize: 17, color: Colors.red),
                ),
              );
}
}
