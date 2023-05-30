import 'package:flutter/material.dart';
import 'package:musclemate/components/record/recording.dart';
import 'package:musclemate/screen/home_config/configuration_page.dart';



class RecordingPage extends StatefulWidget {
  final String buttonName;
  const RecordingPage({Key? key, required this.buttonName}) : super(key: key);

  @override
  _RecordingPageState createState() => _RecordingPageState();
}


class _RecordingPageState extends State<RecordingPage> {



  void _navigateToConfigurations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigurationPage()),
    );
  }

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
        actions: [
          IconButton(
            onPressed: _navigateToConfigurations,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body:  Stack(
        children: [
          const recording(),

        ],
      ),
    );
  }
}

