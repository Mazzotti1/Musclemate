

import 'package:flutter/material.dart';

import 'package:musclemate/pages/home_config/configuration_page.dart';

import 'package:musclemate/widgets/record/defaultExercise.dart';





class DefaultExercisePage extends StatefulWidget {
  const DefaultExercisePage({Key? key, required String buttonName}) : super(key: key);

 @override
  _DefaultExercisePageState createState()=> _DefaultExercisePageState();
}
class _DefaultExercisePageState extends State<DefaultExercisePage>{
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

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Treinos salvos'),
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