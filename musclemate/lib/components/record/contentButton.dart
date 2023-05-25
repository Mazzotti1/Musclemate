import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentButton extends StatefulWidget {
  const ContentButton({Key? key}) : super(key: key);

  @override
  _ContentButtonState createState() => _ContentButtonState();
}

class _ContentButtonState extends State<ContentButton> {
  List<SeriesData> seriesList = [];
  int numberOfLines = 0;
  List<String> textValues = [];

  @override
  void initState() {
    super.initState();
    // Carrega os dados salvos no local storage ao inicializar o widget
    loadData();
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

void openModal(BuildContext context, ValueChanged<String> onChanged) async {
  // Fechar o teclado
  FocusScope.of(context).requestFocus(FocusNode());

  String? inputText = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      String? inputValue;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: const Text('Digite o valor'),
        content: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            inputValue = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // Fechar o modal sem retornar nenhum valor
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Salvar', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // Retornar o valor digitado
              Navigator.of(context).pop(inputValue);
            },
          ),
        ],
      );
    },
  );

  if (inputText != null) {
    onChanged(inputText);
  }
}


  TextFormField buildNumericTextField({
    required String hintText,
    required ValueChanged<String> onChanged
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: hintText,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      onTap: () {
        openModal(context, onChanged);
      },
    );
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? seriesDataString = prefs.getString('seriesData');

    if (seriesDataString != null) {
      List<dynamic> decodedList = jsonDecode(seriesDataString);
      List<SeriesData> savedSeriesList = decodedList.map((item) => SeriesData.fromJson(item)).toList();

     setState(() {
      seriesList = savedSeriesList;
      numberOfLines = seriesList.length;
      textValues = savedSeriesList.map((item) => item.reps).toList();
    });

    }
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String seriesDataString = jsonEncode(seriesList);
    await prefs.setString('seriesData', seriesDataString);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
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
                        child: buildNumericTextField(
                          hintText: 'Reps',
                          onChanged: (value) {
                            setState(() {
                              seriesList[i].reps = value;
                              saveData();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildNumericTextField(
                          hintText: 'Kg',
                          onChanged: (value) {
                            setState(() {
                              seriesList[i].kg = value;
                              saveData();
                            });
                          }
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
                        seriesList.add(SeriesData('', ''));
                        textValues.add(''); // Adiciona uma entrada vazia em textValues
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
      ),
    );
  }
}

class SeriesData {
  String reps;
  String kg;

  SeriesData(this.reps, this.kg);

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'kg': kg,
    };
  }

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      json['reps'] as String,
      json['kg'] as String,
    );
  }
}
