

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil_activitys.dart';
import 'package:musclemate/components/perfil/perfil_progress.dart';
import 'package:musclemate/screen/home_config/configuration_page.dart';




class PerfilActivitysPage extends StatefulWidget {
  const PerfilActivitysPage({Key? key}) : super(key: key);

@override
  _PerfilActivitysPageState createState()=> _PerfilActivitysPageState();
}
class _PerfilActivitysPageState extends State<PerfilActivitysPage>{

 void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }

 @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PerfilActivitys(),
    );
  }

}