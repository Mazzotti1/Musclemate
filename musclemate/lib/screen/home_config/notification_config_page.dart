

import 'package:flutter/material.dart';

import '../../components/config/notification_config.dart';





class NotificationConfigPage extends StatelessWidget {
  const NotificationConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: const Text('Configuração de notificações'),

      ),
      body: const notificationConfig(),
    );
  }
}
