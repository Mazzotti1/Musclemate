

import 'package:flutter/material.dart';
import 'package:musclemate/components/perfil/followers/perfil_following.dart';
import 'package:musclemate/components/perfil/followers/perfil_follows.dart';
import 'package:musclemate/components/perfil/perfil.dart';

import 'package:musclemate/screen/perfil/perfil_activitys_page.dart';
import 'package:musclemate/screen/perfil/perfil_progress_page.dart';

import '../../home_config/configuration_page.dart';



class PerfilFollowersPage extends StatefulWidget {
  const PerfilFollowersPage({Key? key}) : super(key: key);

  @override
  _PerfilFollowersPageState createState()=> _PerfilFollowersPageState();
}
class _PerfilFollowersPageState extends State<PerfilFollowersPage>{


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
              Tab(text: 'Seguidores'),
              Tab(text: 'Seguindo'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PerfilAFollows(),
            PerfilAFollowing(),
          ],
        ),
      ),
    );
  }
}
