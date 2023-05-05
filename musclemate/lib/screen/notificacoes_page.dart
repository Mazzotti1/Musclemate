

import 'package:flutter/material.dart';
import 'package:musclemate/components/home/notificacoes.dart';




class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Notificações'),

      ),
      body: const notificacoes(),
    );
  }
}
