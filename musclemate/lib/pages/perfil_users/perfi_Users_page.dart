

import 'package:flutter/material.dart';
import 'package:musclemate/widgets/perfilUsers/perfilUsers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_config/configuration_page.dart';



class PerfilPageUsers extends StatefulWidget {
  const PerfilPageUsers({Key? key}) : super(key: key);

  @override
  _PerfilPageUsersState createState()=> _PerfilPageUsersState();
}
class _PerfilPageUsersState extends State<PerfilPageUsers>{


 void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }

Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove('choosedPerfil');
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: IconButton(
          onPressed: () {
             clearData();
            Navigator.pop(context);

          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _navigateToConfigurations,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body:   const Stack(
        children: [
          PerfilUsers()

        ],
      ),
    );
  }
}


