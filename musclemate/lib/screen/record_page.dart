

import 'package:flutter/material.dart';

import 'package:musclemate/components/record/record.dart';

import '../components/navbar/NavBar.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Sair'),
         actions: [
          IconButton(
            onPressed: () {
                //função botão
            },
            icon: const Icon(Icons.settings),
          ),
        ],

      ),
  body: const record(),

  bottomNavigationBar: const NavBar(),
    );
  }
}