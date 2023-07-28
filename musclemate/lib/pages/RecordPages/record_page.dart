

import 'package:flutter/material.dart';
import 'package:musclemate/pages/Feed_page.dart';
import 'package:musclemate/pages/RecordPages/recordTutorial.dart';
import 'package:musclemate/pages/home_config/configuration_page.dart';
import 'package:musclemate/widgets/record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

 @override
  _RecordPageState createState()=> _RecordPageState();
}
class _RecordPageState extends State<RecordPage>{
    void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }
      void _navigateToFeedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedPage()),
    );
  }

void _showWelcomeDialog() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool alreadyShown = prefs.getBool('record_dialog_shown') ?? false;

  if (!alreadyShown) {
   showDialog(
    context: context,
    builder: (context) => RecordTutorial(),
  );

    prefs.setBool('record_dialog_shown', true);
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
         automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Gravar'),
         actions: [

             IconButton(
     onPressed: _navigateToConfigurations,
      icon: const Icon(Icons.settings),
    ),
        ],

      ),
  body: const record(),


    );
  }
}