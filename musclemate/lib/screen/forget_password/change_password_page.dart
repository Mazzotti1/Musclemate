import 'package:flutter/material.dart';
import 'package:musclemate/components/forget_password/change_password.dart';



class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPagetate createState()=> _ChangePasswordPagetate();
}
class _ChangePasswordPagetate extends State<ChangePasswordPage>{


  @override
  Widget build(BuildContext context) {
   return const Scaffold(
  body: ChangePassword(),
  );
  }
}