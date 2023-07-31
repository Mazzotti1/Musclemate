

import 'package:flutter/material.dart';
import 'package:musclemate/widgets/perfil/perfil_edit.dart';




class PerfilEditPage extends StatefulWidget {
  const PerfilEditPage({Key? key}) : super(key: key);

  @override
  _PerfilEditPageState createState()=> _PerfilEditPageState();
}
class _PerfilEditPageState extends State<PerfilEditPage>{



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
      title: const Text('Editar perfil'),
      actions: [
      ],
    ),
    body: const PerfilEdit(),
  );
}
}