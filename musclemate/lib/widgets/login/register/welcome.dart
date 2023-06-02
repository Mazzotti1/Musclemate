
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musclemate/widgets/google/google_button.dart';
import 'package:musclemate/pages/Login&Register/login_page.dart';
import 'package:musclemate/pages/Login&Register/register_page.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState()=> _WelcomeState();
}
class _WelcomeState extends State<Welcome>{

   void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage ()),
    );
  }
     void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage ()),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login.png'),
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top:70.0),
          child: Column(
            children: [
              Text(
              'MUSCLEMATE',
              style: TextStyle(
                fontFamily: 'BourbonGrotesque',
                fontSize: 35,
                color: Colors.white,
              ),
            ),
            ],
          ),
        ),
  Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  top: MediaQuery.of(context).size.height / 2,
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(70.0),
      topRight: Radius.circular(70.0),
    ),
    child: Container(
      color: const Color.fromRGBO(227, 227, 227, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
       children: [
  const Padding(
    padding: EdgeInsets.only(top: 30.0),
    child: Text(
      'SEU MELHOR AMIGO NO\n MOMENTO DE FOCO',
      style: TextStyle(
        fontFamily: 'BourbonGrotesque',
        fontSize: 24,
        color: Color.fromRGBO(30, 30, 30, 1),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  ),
  const SizedBox(height: 20,),
  const GoogleButton(),
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: TextButton.icon(
      onPressed: _navigateToRegister,
      icon: const FaIcon(
        FontAwesomeIcons.envelope,
        color: Colors.black,
      ),
      label: const Text(
        'Cadastrar-se com email',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        fixedSize: const Size(270, 50),
      ),
    ),
  ),
    const SizedBox(height: 20,),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 50,
        height: 1,
        color: Colors.black,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10),
        child: Text('JÁ SOU MEMBRO',
        style: TextStyle(color: Color.fromRGBO(0, 51, 102, 1)),
        ),

      ),
      Container(
        width: 50,
        height: 1,
        color: Colors.black,
      ),
    ],
  ),
  const SizedBox(height: 15,),
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: TextButton.icon(
      onPressed: _navigateToLogin,
      icon: const FaIcon(
        FontAwesomeIcons.user,
        color: Colors.black,
      ),
      label: const Text(
        'Fazer login',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromRGBO(194, 255, 26, 1),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        fixedSize: const Size(270, 50),
      ),
    ),
  ),
],
      ),
    ),
  ),
)

      ],
    ),
  );
}
}