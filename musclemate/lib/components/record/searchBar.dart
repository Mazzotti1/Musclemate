import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode.addListener(() {
  if (!_searchFocusNode.hasFocus) {
    _clearSearch();
  }
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 300,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 217, 217, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black45),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (searchText) {
                          _performSearch(searchText);
                          getExercises(); // Chamar a função getExercises() aqui
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
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchResults[index]),
                    );
                  },
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
