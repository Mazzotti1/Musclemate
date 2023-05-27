import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ContentButton extends StatefulWidget {
  final String buttonName;

  const ContentButton({Key? key, required this.buttonName}) : super(key: key);

  @override
  _ContentButtonState createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  int numberOfLines = 0;
  List<String> repsList = [];
  List<String> kgsList = [];
  List<TextEditingController> repsControllers = [];
  List<TextEditingController> kgsControllers = [];


@override
void initState() {
  super.initState();
  loadData();

  repsControllers = List.generate(numberOfLines, (index) => TextEditingController());
  kgsControllers = List.generate(numberOfLines, (index) => TextEditingController());
}


  String getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' + 'ª';
    }
    switch (number % 10) {
      case 1:
        return '$number' + 'ª';
      case 2:
        return '$number' + 'ª';
      case 3:
        return '$number' + 'ª';
      default:
        return '$number' + 'ª';
    }
  }

Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();
  final buttonKey = widget.buttonName; // Obtém o nome do botão selecionado

  await prefs.setInt('series_$buttonKey', numberOfLines);
  await prefs.setStringList('reps_$buttonKey', repsList);
  await prefs.setStringList('kgs_$buttonKey', kgsList);
}


Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();
  final buttonKey = widget.buttonName; // Obtém o nome do botão selecionado

  setState(() {
    numberOfLines = prefs.getInt('series_$buttonKey') ?? 0;
    repsList = prefs.getStringList('reps_$buttonKey') ?? [];
    kgsList = prefs.getStringList('kgs_$buttonKey') ?? [];

    repsControllers.clear();
    kgsControllers.clear();

    for (int i = 0; i < numberOfLines; i++) {
      if (i < repsList.length) {
        repsControllers.add(TextEditingController(text: repsList[i]));
      } else {
        repsControllers.add(TextEditingController());
      }

      if (i < kgsList.length) {
        kgsControllers.add(TextEditingController(text: kgsList[i]));
      } else {
        kgsControllers.add(TextEditingController());
      }
    }
  });
}





  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 100 + numberOfLines * 50,
        color: Colors.white,
        child: Column(
          children: [
            for (int i = 0; i < numberOfLines; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${getOrdinal(i + 1)} Série'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                       controller: (repsControllers.isNotEmpty && i < repsControllers.length) ? repsControllers[i] : TextEditingController(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Reps',
                        ),
                        onChanged: (value) {
                          repsList[i] = value;
                          saveData();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                       controller: (kgsControllers.isNotEmpty && i < kgsControllers.length) ? kgsControllers[i] : TextEditingController(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Kg',
                        ),
                        onChanged: (value) {
                          kgsList[i] = value;
                          saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      numberOfLines++;
                      repsList.add('');
                      kgsList.add('');
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text(
                    'Série',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
