import 'package:flutter/material.dart';
import 'package:musclemate/pages/home_config/welcomeDialog.dart';
import 'package:musclemate/pages/home_config/configuration_page.dart';
import 'package:musclemate/pages/notificacoes_page.dart';
import 'package:musclemate/pages/searchPeoplePages/searchPeople_page.dart';
import 'package:musclemate/widgets/home/feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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

void _showWelcomeDialog() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool alreadyShown = prefs.getBool('welcome_dialog_shown') ?? false;

  if (!alreadyShown) {
    showDialog(
      context: context,
      builder: (context) => WelcomeDialog(),
    );

    prefs.setBool('welcome_dialog_shown', true);
  }
}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Início'),
        automaticallyImplyLeading: false,
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
      body: const Feed(),
    );
  }
}
