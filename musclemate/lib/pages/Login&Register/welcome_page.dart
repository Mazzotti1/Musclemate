import 'package:flutter/material.dart';

import '../../widgets/login/register/welcome.dart';




class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState()=> _WelcomePageState();
}
class _WelcomePageState extends State<WelcomePage>{


  @override
  Widget build(BuildContext context) {
   return const Scaffold(
  body: Welcome(),
  );
  }
}