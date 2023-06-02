

import 'package:flutter/material.dart';
import 'package:musclemate/widgets/perfil/perfil_progress.dart';
import 'package:musclemate/pages/home_config/configuration_page.dart';




class PerfilProgressPage extends StatefulWidget {
  const PerfilProgressPage({Key? key}) : super(key: key);

@override
  _PerfilProgressPageState createState()=> _PerfilProgressPageState();
}
class _PerfilProgressPageState extends State<PerfilProgressPage>{

 void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }

 @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PerfilProgress(),
    );
  }

}