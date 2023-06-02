
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/Login&Register/welcome_page.dart';


class logout extends StatefulWidget {
  const logout({Key? key}) : super(key: key);

@override
  _logoutState createState()=> _logoutState();
}
class _logoutState extends State<logout>{

void _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');

showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Confirmar logout',textAlign: TextAlign.center,),
      content: Text('Tem certeza de que deseja sair?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o alerta
              },
            ),
            TextButton(
              child: Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                  (Route<dynamic> route) => false,
                );
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
                  _logout(context);
                },
                child: const Text('Sair',
                  style: TextStyle(fontSize: 17, color: Colors.red),

        )
     );
}
}