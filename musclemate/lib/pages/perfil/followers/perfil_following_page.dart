

import 'package:flutter/material.dart';
import 'package:musclemate/widgets/perfil/followers/perfil_following.dart';
import 'package:musclemate/widgets/perfil/followers/perfil_follows.dart';


import '../../home_config/configuration_page.dart';



class PerfilFollowingPage extends StatefulWidget {
  const PerfilFollowingPage({Key? key}) : super(key: key);

  @override
  _PerfilFollowingPageState createState()=> _PerfilFollowingPageState();
}
class _PerfilFollowingPageState extends State<PerfilFollowingPage>{


 void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
          title: const Text('Perfil'),
          actions: [
            IconButton(
              onPressed: _navigateToConfigurations,
              icon: const Icon(Icons.settings),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Seguindo'),
              Tab(text: 'Seguidores'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PerfilAFollowing(),
            PerfilAFollows(),
          ],
        ),
      ),
    );
  }
}
