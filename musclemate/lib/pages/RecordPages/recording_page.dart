import 'package:flutter/material.dart';
import 'package:musclemate/pages/RecordPages/recordingTutorial.dart';

import 'package:musclemate/widgets/record/recording.dart';
import 'package:musclemate/pages/home_config/configuration_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../searchPeoplePages/searchPeople_page.dart';




class RecordingPage extends StatefulWidget {
  final String buttonName;
  const RecordingPage({Key? key, required this.buttonName}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}


class _RecordingPageState extends State<RecordingPage> {




Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();

  final keys = prefs.getKeys();

  final seriesKeys = keys.where((key) => key.startsWith("series_")).toList();
  final repsKeys = keys.where((key) => key.startsWith("reps_")).toList();
  final kgsKeys = keys.where((key) => key.startsWith("kgs_")).toList();

  for (final key in seriesKeys) {
    await prefs.remove(key);
  }
  for (final key in repsKeys) {
    await prefs.remove(key);
  }
  for (final key in kgsKeys) {
    await prefs.remove(key);
  }
  await prefs.remove('seriesTotais');
  await prefs.remove('repsTotais');
  await prefs.remove('kgsTotais');
  await prefs.remove('SelectedDefaultExercise');

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
  bool alreadyShown = prefs.getBool('recording_dialog_shown') ?? false;

  if (!alreadyShown) {
    showDialog(
        context: context,
        builder: (context) => RecordingTutorial(),
    );

    prefs.setBool('recording_dialog_shown', true);
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
        title: IconButton(
          onPressed: () {
             clearData();
            Navigator.pop(context);

          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
           IconButton(
     onPressed: _navigateToSearchPeople,
      icon: const Icon(Icons.person_add),
    ),
          IconButton(
            onPressed: _navigateToConfigurations,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body:   const Stack(
        children: [
          recording(buttonName: '' ),

        ],
      ),
    );
  }
}

