

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil_edit.dart';




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
        TextButton(
          onPressed: () {},
          child: const Text(
            'Concluído',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    ),
    body: const PerfilEdit(),
  );
}
}