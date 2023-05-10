

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil_activitys.dart';





class PerfilActivitysPage extends StatefulWidget {
  const PerfilActivitysPage({Key? key}) : super(key: key);

@override
  _PerfilActivitysPageState createState()=> _PerfilActivitysPageState();
}
class _PerfilActivitysPageState extends State<PerfilActivitysPage>{



 @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PerfilActivitys(),
    );
  }

}