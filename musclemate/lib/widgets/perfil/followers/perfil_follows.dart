
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musclemate/widgets/perfil/perfil.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


class PerfilAFollows extends StatefulWidget {
  const PerfilAFollows({Key? key}) : super(key: key);

@override
  _PerfilAFollowsState createState()=> _PerfilAFollowsState();
}
class _PerfilAFollowsState extends State<PerfilAFollows>{
TextEditingController searchController = TextEditingController();
List<Map<String, dynamic>> filteredData = [];

     @override
  void initState() {
    super.initState();
    findFollows();
  }

 void _navigateToChoosedPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Perfil()),
    );
  }


List<Map<String, dynamic>> globalData = [];


 Future<void> findFollows() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    await dotenv.load(fileName: ".env");

    String? apiUrl = dotenv.env['API_URL'];

    final userData = JwtDecoder.decode(token);
    String userId = (userData['sub']);
    String url = '$apiUrl/users/followers/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      List<Map<String, dynamic>> extractNamesAndImageUrls(List<dynamic> data) {
          List<Map<String, dynamic>> result = [];

          for (var item in data) {
            String nomeController = item['nome'];
            String? imageUrlController = item['imageUrl'];

            Map<String, dynamic> extractedData = {
              'nome': nomeController,
              'imageUrl': imageUrlController,
            };

            result.add(extractedData);
          }

          return result;
      }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, dynamic>> extractedData = extractNamesAndImageUrls(data);
      globalData = extractedData;
        setState(() {
    globalData = extractedData;
    filteredData = extractedData;
  });
      print(extractedData);
    } else {
      print('${response.statusCode}');
    }
    } catch (e) {
      print('$e');
    }
  }

   void filterData(String query) {
    setState(() {
      filteredData = globalData.where((item) {
        String nome = item['nome'];
        return nome.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10),
      child: Column(
        children: [
          Container(
            width: 350,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(242, 242, 242, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.black45),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        filterData(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            height: 15,
            color: Color.fromRGBO(240, 240, 240, 1),
          ),
       Expanded(
          child: ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              late final nome = filteredData[index]['nome'];
              late final imageUrl = filteredData[index]['imageUrl'];

              return Padding(
                padding: const EdgeInsets.only(top:8.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToChoosedPerfil();
                      },
                      child: imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                            )
                          : Icon(Icons.person_outline_rounded, size: 50),
                    ),
                    SizedBox(width: 10),
                    Text(
                      nome != null ? nome : '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
    );
  }
}