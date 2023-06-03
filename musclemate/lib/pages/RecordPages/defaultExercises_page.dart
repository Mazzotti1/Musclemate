

import 'package:flutter/material.dart';

import 'package:musclemate/pages/home_config/configuration_page.dart';

import 'package:musclemate/widgets/record/defaultExercise.dart';
import 'package:shared_preferences/shared_preferences.dart';





class DefaultExercisePage extends StatefulWidget {
  const DefaultExercisePage({Key? key, required String buttonName}) : super(key: key);

 @override
  _DefaultExercisePageState createState()=> _DefaultExercisePageState();
}
class _DefaultExercisePageState extends State<DefaultExercisePage>{

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
  await prefs.remove('buttonNames');
}

    void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),

        title: Row(
          children: [
            IconButton(
              onPressed: () {
                 clearData();
                Navigator.pop(context);

              },
              icon: const Icon(Icons.arrow_back),
            ),
            const Text('Treinos salvos')
          ],
        ),

         actions: [
             IconButton(
     onPressed: _navigateToConfigurations,
      icon: const Icon(Icons.settings),
    ),
        ],

      ),
  body: const DefaultExercises(),


    );
  }
}