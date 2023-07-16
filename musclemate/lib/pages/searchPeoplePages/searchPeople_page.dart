import 'package:flutter/material.dart';
import 'package:musclemate/pages/home_config/configuration_page.dart';
import 'package:musclemate/pages/notificacoes_page.dart';

import 'package:musclemate/widgets/searchPeople/searchPeople.dart';


class SearchPeoplePage extends StatefulWidget {
  const SearchPeoplePage({Key? key}) : super(key: key);

  @override
  _SearchPeoplePageState createState()=> _SearchPeoplePageState();
}
class _SearchPeoplePageState extends State<SearchPeoplePage>{
  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificacoesPage()),
    );
  }
    void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }
    void _navigateToSearchPeople() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPeoplePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(  appBar: AppBar(
  backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
  title: const Text('Pesquisar'),
  automaticallyImplyLeading: true,
  leading: null,
  actions: [
    IconButton(
     onPressed: _navigateToSearchPeople,
      icon: const Icon(Icons.person_add),
    ),
     IconButton(
     onPressed: _navigateToNotifications,
      icon: const Icon(Icons.notifications),
    ),
    IconButton(
     onPressed: _navigateToConfigurations,
      icon: const Icon(Icons.settings),
    ),

  ],
),
   body: const SearchPeople(),
  );

  }
}