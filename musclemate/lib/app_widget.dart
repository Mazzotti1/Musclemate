

import 'package:flutter/material.dart';

import 'package:musclemate/screen/Login&Register/welcome_page.dart';


class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

      ),
      home: const WelcomePage(),
    );
  }
}
