

import 'package:flutter/material.dart';

import 'package:musclemate/widgets/config/faq.dart';




class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('FAQ'),

      ),
      body: const faq(),
    );
  }
}
