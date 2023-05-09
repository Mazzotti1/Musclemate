

import 'package:flutter/material.dart';
import 'package:musclemate/components/config/change_email.dart';






class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Alterar Email'),

      ),
      body: const changeEmail(),
    );
  }
}
