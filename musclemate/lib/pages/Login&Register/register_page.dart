import 'package:flutter/material.dart';
import 'package:musclemate/widgets/login/register/register.dart';






class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState()=> _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{


  @override
  Widget build(BuildContext context) {
   return const Scaffold(
  body: Register(),
  );
  }
}