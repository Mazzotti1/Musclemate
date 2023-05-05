

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil.dart';



class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () {
              //função botão
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Perfil(),
    );
  }
}
