

import 'package:flutter/material.dart';

import 'package:musclemate/components/record/record.dart';



class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Gravar'),
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


    );
  }
}