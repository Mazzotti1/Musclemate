import 'package:flutter/material.dart';
import 'package:musclemate/components/forget_password/code.dart';


class CodePage extends StatefulWidget {
  const CodePage({Key? key}) : super(key: key);

  @override
  _CodePageState createState()=> _CodePageState();
}
class _CodePageState extends State<CodePage>{


  @override
  Widget build(BuildContext context) {
   return const Scaffold(
  body: Code(),
  );
  }
}