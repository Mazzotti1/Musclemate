

import 'package:flutter/material.dart';
import 'package:musclemate/components/config/about.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Sobre'),

      ),
      body: const about(),
    );
  }
}
