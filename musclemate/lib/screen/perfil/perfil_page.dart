

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil.dart';
import 'package:musclemate/components/perfil/perfil_progress.dart';

import 'package:musclemate/screen/notificacoes_page.dart';
import 'package:musclemate/screen/perfil/perfil_activitys_page.dart';
import 'package:musclemate/screen/perfil/perfil_progress_page.dart';



class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
          title: const Text('Perfil'),
          actions: [
            IconButton(
              onPressed: () {
                // Função do botão de configurações
              },
              icon: const Icon(Icons.settings),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Progresso'),
              Tab(text: 'Atividades'),
              Tab(text: 'Perfil'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PerfilProgressPage(),
            PerfilActivitysPage(),
            Perfil(),
          ],
        ),
      ),
    );
  }
}
