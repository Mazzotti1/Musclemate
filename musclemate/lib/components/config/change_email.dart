
import 'package:flutter/material.dart';


class changeEmail extends StatefulWidget {
  const changeEmail({Key? key}) : super(key: key);

  @override
  _changeEmailState createState()=> _changeEmailState();
}
class _changeEmailState extends State<changeEmail>{

    final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 50),
      const Text(
        'Passe sua senha correta e seu novo email',
        style: TextStyle(fontSize: 17, color: Colors.black45),
      ),
      const SizedBox(height: 40),
       Row(
         children: const [
           SizedBox(width: 20),
           Text(
            'Email',
            style: TextStyle(fontSize: 17, color: Colors.black),
      ),
         ],
       ),
      TextField(
        controller: emailController,
        decoration: const InputDecoration(
          hintText: 'joão@gmail.com',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 126, 9, 9), // cor da borda
              width: 200, // largura da borda
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10, // adicione padding vertical
            horizontal: 20, // adicione padding horizontal
          ),
        ),
      ),
      const SizedBox(height: 20),
      Row(
         children: const [
           SizedBox(width: 20),
           Text(
            'Senha',
            style: TextStyle(fontSize: 17, color: Colors.black),
      ),
         ],
       ),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: '********',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black, // cor da borda
              width: 200, // largura da borda
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10, // adicione padding vertical
            horizontal: 20, // adicione padding horizontal
          ),
        ),
      ),
    ],
  );
}
}