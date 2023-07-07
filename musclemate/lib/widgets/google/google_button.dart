import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:musclemate/pages/Feed_page.dart';
import 'package:shared_preferences/shared_preferences.dart';



class GoogleButton extends StatefulWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {

  void _navigateToFeed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedPage ()),
    );
  }

String _errorMessage = '';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  try {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
     String? name = googleUser.displayName;
     String? email = googleUser.email;


     await loginUserWithGoogle(name, email);
    } else {
    }
  } catch (error) {
  }
}


//registro

Future<void> registerUserWithGoogle(String? name, String email) async {
    await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];

     String url = '$apiUrl/users/register';

  Map<String, dynamic> userData = {
    'nome': name,
    'email': email,
    'password': name,
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
  _navigateToFeed();
  print('Usuário registrado com sucesso');
} else {
     setState(() {
      _errorMessage = 'Erro: ${response.statusCode}';
    });
}
} catch (e) {
  print('Erro: $e');
}
  }

//LOGIN

   Future<void> loginUserWithGoogle(String? name, String email) async {
    await dotenv.load(fileName: ".env");

     String? apiUrl = dotenv.env['API_URL'];

     String url = '$apiUrl/users/login';

  Map<String, dynamic> userData = {
    'email': email,
    'password': name,
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
   _navigateToFeed();
  print(response.body);
} else {
    registerUserWithGoogle(name, email);
  }
}catch (e) {
  print('Erro: $e');
}
  }

 @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: TextButton.icon(
          onPressed: signInWithGoogle,
          icon: const FaIcon(
            FontAwesomeIcons.google,
            color: Colors.black,
          ),
          label: const Text(
            'Continuar com Google',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            fixedSize: const Size(270, 50),
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
     ],
   );

  }
}