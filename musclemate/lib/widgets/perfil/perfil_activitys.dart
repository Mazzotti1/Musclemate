
import 'package:flutter/material.dart';
import 'package:musclemate/widgets/home/posts.dart';


class PerfilActivitys extends StatelessWidget {
  const PerfilActivitys({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10.0, left: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 350,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.search, color: Colors.black45),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Pesquisar por atividade',
                                          hintStyle: TextStyle(color: Colors.black45),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                        ),

                      ),
                      //Aqui vou ter que chamar todos os posts do ID que está salvo no token
                      const SizedBox(height: 10,),
                       Container(
                              width: double.infinity,
                              height: 15,
                              color: const Color.fromRGBO(242, 242, 242, 1),
                            ),
                            Column(
                              children: const [
                                Posts()
                              ],
                            )
                    ],
                  ),
                );
  }
}