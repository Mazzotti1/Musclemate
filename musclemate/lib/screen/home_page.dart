import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musclemate/components/home/posts.dart';

import '../components/navbar/NavBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Defina a cor da StatusBar como transparente
      statusBarIconBrightness: Brightness.dark, // Defina a cor do ícone da StatusBar como escuro
    ));

 return Scaffold(
  appBar: AppBar(
    backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
    title: const Text('Início'),
    automaticallyImplyLeading: false, // Remove o botão de voltar
    leading: null, // Remove o ícone de voltar
    actions: [
      IconButton(
        onPressed: () {
          //função botão
        },
        icon: const Icon(Icons.settings),
      ),
    ],
  ),
  body: const Posts(),
  bottomNavigationBar: const NavBar(),
);

  }
}