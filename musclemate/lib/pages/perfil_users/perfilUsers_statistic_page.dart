

import 'package:flutter/material.dart';

import '../../widgets/perfilUsers/perfilUsers_statistic.dart';




class PerfilUsersStatisticPage extends StatefulWidget {
  const PerfilUsersStatisticPage({Key? key}) : super(key: key);

  @override
  _PerfilUsersStatisticPageState createState()=> _PerfilUsersStatisticPageState();
}
class _PerfilUsersStatisticPageState extends State<PerfilUsersStatisticPage>{

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
      title: const Text('Estatísticas'),

    ),
    body: const PerfilUsersStatistic(),
  );
}
}