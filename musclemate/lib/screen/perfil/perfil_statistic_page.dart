

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/perfil_statistic.dart';




class PerfilStatisticPage extends StatefulWidget {
  const PerfilStatisticPage({Key? key}) : super(key: key);

  @override
  _PerfilStatisticPageState createState()=> _PerfilStatisticPageState();
}
class _PerfilStatisticPageState extends State<PerfilStatisticPage>{

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
      title: const Text('Estatísticas'),

    ),
    body: const PerfilStatistic(),
  );
}
}