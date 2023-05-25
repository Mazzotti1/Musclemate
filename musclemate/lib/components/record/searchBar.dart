import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musclemate/components/record/contentButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class barraPesquisa extends StatefulWidget {
  @override
  _barraPesquisaState createState() => _barraPesquisaState();
}

class _barraPesquisaState extends State<barraPesquisa> {
  late TextEditingController _searchController;
  List<String> contents = [];
  List<String> searchResults = [];
  FocusNode _searchFocusNode = FocusNode();

  List<String> selectedButtons = [];
  String? selectedButtonName;
  Map<String, bool> buttonVisibility = {};



  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode.addListener(() {
  if (!_searchFocusNode.hasFocus) {
    _clearSearch();
  }
});
selectedButtons.forEach((buttonName) {
  buttonVisibility[buttonName] = false;
});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String searchText) {
    setState(() {
      // Filtrar os conteúdos com base no texto de pesquisa
      searchResults = contents
          .where((content) =>
              content.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      searchResults.clear();
    });
  }

  Future<void> getExercises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String? savedExercise = prefs.getString('Exercise');
    String exercicios = savedExercise
        ?.replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '') ?? '';

    await dotenv.load(fileName: ".env");

    String? apiUrl = dotenv.env['API_URL'];

    String url = '$apiUrl/exercicios/$exercicios';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parseie a resposta JSON e atualize a lista de conteúdos
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          contents = data.cast<String>().toList();
        });
      } else {
        if (response.statusCode == 400) {
          print('$Error');
        } else {
          setState(() {
            print('Erro: ${response.statusCode}');
          });
        }
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void _closeOtherButtons(String buttonName) {
  for (var name in selectedButtons) {
    if (name != buttonName) {
      buttonVisibility[name] = false;
    }
  }
}

 @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 217, 217, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, color: Colors.black45),
                      const SizedBox(width: 5),
                      Container(
                        width: 180, // Definir a largura desejada para o TextField
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (searchText) {
                            _performSearch(searchText);
                            getExercises();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Encontre um exercício',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black45),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...searchResults.map((selectedButtonName) {
                      return TextButton(
                        onPressed: () {
                          if (!selectedButtons.contains(selectedButtonName)) {
                            setState(() {
                              selectedButtons.add(selectedButtonName);
                              _closeOtherButtons(selectedButtonName);
                            });
                          }
                          _searchFocusNode.unfocus();
                        },
                        child: Text(
                          selectedButtonName,
                          style: const TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(
                height: 270,
                child: Visibility(
                  visible: selectedButtons.isNotEmpty,
                  child: Expanded(
                    child: ListView(
                      children: [
                        ...selectedButtons.map((buttonName) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      buttonVisibility[buttonName] =
                                          buttonVisibility[buttonName] != null
                                              ? !buttonVisibility[buttonName]!
                                              : true;
                                      _closeOtherButtons(buttonName);
                                    });
                                    _searchFocusNode.unfocus();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(228, 232, 248, 1),
                                    minimumSize: const Size(300, 40),
                                  ),
                                  child: Text(
                                    buttonName,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              if (buttonVisibility[buttonName] == true)
                                const ContentButton(),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class Content {
  final String title;

  Content(this.title);
}

