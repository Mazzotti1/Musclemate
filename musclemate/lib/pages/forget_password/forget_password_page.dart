import 'package:flutter/material.dart';
import 'package:musclemate/widgets/forget_password/forget_password.dart';






class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState()=> _ForgetPasswordPageState();
}
class _ForgetPasswordPageState extends State<ForgetPasswordPage>{


  @override
  Widget build(BuildContext context) {
   return const Scaffold(
  body: ForgetPassword(),
  );
  }
}