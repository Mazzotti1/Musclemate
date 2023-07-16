

import 'package:flutter/material.dart';

import '../../widgets/perfilUsers/postsUsers.dart';





class PerfilUsersActivitysPage extends StatefulWidget {
  const PerfilUsersActivitysPage({Key? key}) : super(key: key);

@override
  _PerfilUsersActivitysPageState createState()=> _PerfilUsersActivitysPageState();
}
class _PerfilUsersActivitysPageState extends State<PerfilUsersActivitysPage>{



@override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(32, 48, 105, 1),
        title: IconButton(
          onPressed: () {

            Navigator.pop(context);

          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body:   const Stack(
        children: [
          PostsUsers()

        ],
      ),
    );
  }
}