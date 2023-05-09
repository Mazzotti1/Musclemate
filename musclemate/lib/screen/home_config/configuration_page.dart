

import 'package:flutter/material.dart';
import 'package:musclemate/components/config/configuration.dart';




class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Configurações'),

      ),
      body: const configuration(),
    );
  }
}
