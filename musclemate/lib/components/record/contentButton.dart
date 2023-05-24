import 'package:flutter/material.dart';

class contentButton extends StatefulWidget {
  const contentButton ({Key? key}) : super(key: key);

  @override
  _contentButtonState createState()=> _contentButtonState();
}
class _contentButtonState extends State<contentButton>{

  int numberOfLines = 0;
  List<String> ordinals = [];
  List<SeriesData> seriesList = [];


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
                      decoration: InputDecoration(
                        hintText: 'Reps',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onChanged: (value) {
                        seriesList[i].reps = value; // Atualiza o valor de "Reps" na lista
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Kg',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onChanged: (value) {
                        seriesList[i].kg = value; // Atualiza o valor de "Kg" na lista
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
                    numberOfLines++; // incrementa o número de linhas
                    seriesList.add(SeriesData('', '')); // Adiciona uma nova série vazia à lista
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
}

class SeriesData {
  String reps;
  String kg;

  SeriesData(this.reps, this.kg);
}
