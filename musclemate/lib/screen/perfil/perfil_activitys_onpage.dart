

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil_activitys.dart';





class PerfilActivitysOnPage extends StatefulWidget {
  const PerfilActivitysOnPage({Key? key}) : super(key: key);

  @override
  _PerfilActivitysOnPageState createState()=> _PerfilActivitysOnPageState();
}
class _PerfilActivitysOnPageState extends State<PerfilActivitysOnPage>{

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
      title: const Text('Atividades'),

    ),
    body: const PerfilActivitys(),
  );
}
}