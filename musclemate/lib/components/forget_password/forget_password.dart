
import 'package:flutter/material.dart';






class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();



  String capitalize(String value) {
  if (value.isEmpty) {
    return value;
  }
  return value[0].toUpperCase() + value.substring(1);
}

String _errorMessage = '';

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  title: const Row(
    children: [
      Text(
        'Voltar',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    ],
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    color: Colors.black,
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  elevation: 1,
),


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recuperação de senha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left:16.0, right: 16),
            child: Text(
                'Digite o seu email para receber o código de recuperação no seu email!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ),
          Center(
            child: Text(
            _errorMessage,
            style: const TextStyle(

              color: Colors.red,
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email', labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),

                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: (){

                    },
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(230, 230, 230, 1))),
                    child: const Text('Enviar código de recuperação', style: TextStyle(color: Colors.black)),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}