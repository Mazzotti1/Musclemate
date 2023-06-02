
import 'package:flutter/material.dart';
import 'package:musclemate/widgets/config/deleteAccount.dart';

import 'package:musclemate/pages/home_config/about_page.dart';
import 'package:musclemate/pages/home_config/change_email_page.dart';
import 'package:musclemate/pages/home_config/faq_page.dart';
import 'package:musclemate/pages/home_config/notification_config_page.dart';


import 'logout.dart';


class configuration extends StatefulWidget {
  const configuration({Key? key}) : super(key: key);

 @override
  _configurationState createState()=> _configurationState();
}
class _configurationState extends State<configuration>{

  void _navigateToNotificationsConfig() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationConfigPage()),
    );
  }
   void _navigateToChangeEmail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangeEmailPage()),
    );
  }
     void _navigateToFaq() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FaqPage ()),
    );
  }

    void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage ()),
    );
  }



  @override
Widget build(BuildContext context) {
  return Column(
  children: [
    Padding(
      padding: const EdgeInsets.only(top:40.0, left: 35),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: _navigateToNotificationsConfig,
                child: const Text('Configuração de notificações',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              const SizedBox(height: 35),
              TextButton(
                onPressed: _navigateToChangeEmail,
                child: const Text('Alterar e-mail',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              const SizedBox(height: 35),
              TextButton(
                 onPressed: _navigateToFaq,
                child: const Text('Perguntas frequentes',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              const SizedBox(height: 35),
              TextButton(
                onPressed: _navigateToAbout,
                child: const Text('Sobre',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              const SizedBox(height: 35),
              const deleteAccount(),
              const SizedBox(height: 35),
             const logout()

            ],
          ),
        ],
      ),
    ),
  ],
);
}
}