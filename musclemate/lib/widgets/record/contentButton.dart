import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ContentButton extends StatefulWidget {
  final String buttonName;


  const ContentButton({Key? key, required this.buttonName,}) : super(key: key);

  @override
  _ContentButtonState createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  int numberOfLines = 0;

  List<String> repsList = [];
  List<String> kgsList = [];
  List<TextEditingController> repsControllers = [];
  List<TextEditingController> kgsControllers = [];

  int seriesTotais=0;
  int repsTotais = 0;
  double kgsTotais = 0;



@override
void initState() {
  super.initState();
  loadData();

  repsControllers = List.generate(numberOfLines, (index) => TextEditingController());
  kgsControllers = List.generate(numberOfLines, (index) => TextEditingController());
}


  String getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' 'ª';
    }
    switch (number % 10) {
      case 1:
        return '$number' 'ª';
      case 2:
        return '$number' 'ª';
      case 3:
        return '$number' 'ª';
      default:
        return '$number' 'ª';
    }
  }


Future<void> saveTotal() async {
  final prefs = await SharedPreferences.getInstance();

  int savedRepsTotais = prefs.getInt('repsTotais') ?? 0;
  double savedKgsTotais = prefs.getDouble('kgsTotais') ?? 0.0;

  int updatedRepsTotais = savedRepsTotais + repsTotais;
  double updatedKgsTotais = savedKgsTotais + kgsTotais;

  await prefs.setInt('repsTotais', updatedRepsTotais);
  await prefs.setDouble('kgsTotais', updatedKgsTotais);

  print(updatedRepsTotais);
  print(updatedKgsTotais);
}





Future<void> saveData() async {
  final prefs = await SharedPreferences.getInstance();
  final buttonKey = widget.buttonName;

  await prefs.setInt('series_$buttonKey', numberOfLines);
  await prefs.setStringList('reps_$buttonKey', repsList);
  await prefs.setStringList('kgs_$buttonKey', kgsList);
  await prefs.setInt('seriesTotais', seriesTotais);

}


Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();
  final buttonKey = widget.buttonName; // Obtém o nome do botão selecionado

  setState(() {
    numberOfLines = prefs.getInt('series_$buttonKey') ?? 0;
    seriesTotais = prefs.getInt('seriesTotais') ?? 0;
    repsList = prefs.getStringList('reps_$buttonKey') ?? [];
    kgsList = prefs.getStringList('kgs_$buttonKey') ?? [];


    repsControllers.clear();
    kgsControllers.clear();

    print(numberOfLines);
     print(seriesTotais);
      print(repsList);
       print(kgsList);

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



 Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();
  final buttonKey = widget.buttonName;

  await prefs.remove('series_$buttonKey');
  await prefs.remove('reps_$buttonKey');
  await prefs.remove('kgs_$buttonKey');
  await prefs.remove('seriesTotais');
  await prefs.remove('repsTotais');
  await prefs.remove('kgsTotais');
print('limpou tudo');
  setState(() {
    numberOfLines = 0;
    repsList.clear();
    kgsList.clear();
    repsControllers.clear();
    kgsControllers.clear();
  });
}



Future<void> showModal(BuildContext context, int index) async {
  final TextEditingController repsController =
      TextEditingController(text: repsList[index]);
  final TextEditingController kgsController =
      TextEditingController(text: kgsList[index]);


  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${getOrdinal(index + 1)} Série'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Repetições',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: kgsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Kg',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              setState(() {
                repsList[index] = repsController.text;
                kgsList[index] = kgsController.text;
                repsTotais = int.tryParse(repsController.text) ?? 0;
                kgsTotais = double.tryParse(kgsController.text) ?? 0.0;
              });

              await saveTotal();
              await saveData();
              await loadData();

            Navigator.of(context).pop();
          },
            child: const Text('Salvar',),
          ),
        ],
      );
    },
  );
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
                child: Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                        onTap: () => showModal(context, i),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${getOrdinal(i + 1)} Série'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      enabled: false,
                                      controller: (repsControllers.isNotEmpty && i < repsControllers.length)
                                          ? repsControllers[i]
                                          : TextEditingController(),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'nº',
                                      ),
                                    ),
                                  ),
                                   const Expanded(
                                    child: Text('Reps', style: TextStyle(fontSize: 12),),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  controller: (kgsControllers.isNotEmpty && i < kgsControllers.length)
                                      ? kgsControllers[i]
                                      : TextEditingController(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'nº',
                                  ),
                                ),
                              ),
                              const Expanded(
                                  child: Text('Kg',style: TextStyle(fontSize: 12),),
                              ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  numberOfLines--;
                                  repsControllers.removeAt(i);
                                  kgsControllers.removeAt(i);
                                });

                                final prefs = await SharedPreferences.getInstance();


                                final savedSeriesTotais = prefs.getInt('seriesTotais') ?? 0;
                                final updatedSeriesTotais = savedSeriesTotais - 1;
                                await prefs.setInt('seriesTotais', updatedSeriesTotais);

                                final savedRepsTotais = prefs.getInt('repsTotais') ?? 0;
                                final savedKgsTotais = prefs.getDouble('kgsTotais') ?? 0.0;

                                final removedReps = repsList[i] != '' ? int.parse(repsList[i]) : 0;
                                final removedKgs = kgsList[i] != '' ? double.parse(kgsList[i]) : 0.0;

                                final updatedRepsTotais = savedRepsTotais - removedReps;
                                final updatedKgsTotais = savedKgsTotais - removedKgs;

                                await prefs.setInt('repsTotais', updatedRepsTotais);
                                await prefs.setDouble('kgsTotais', updatedKgsTotais);

                                setState(() {
                                  repsList.removeAt(i);
                                  kgsList.removeAt(i);
                                });
                              },
                              child: const Icon(
                                Icons.minimize_outlined,
                                color: Colors.black,
                              ),
                            ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),


                      ),
                    ],
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      seriesTotais++;
                      numberOfLines++;
                      repsList.add('');
                      kgsList.add('');
                      saveData();
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
