
import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.all(0.0),
  child: Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top:20.0, left: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Icon(Icons.person_outline_rounded, size: 50),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Marcos da Silva',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:2.5),
                    child: Row(
                      children: const [
                        Text(
                          '18 de abril de 2023 ás 10:38',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10,),
      Padding(
        padding: const EdgeInsets.only(left:9),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: const [
              Text('Hoje eu treinei peito!',
              style: TextStyle(fontSize: 16)
              ),
            ],
          ),
        ),
      ),
         const SizedBox(height: 15,),
      Padding(
        padding: const EdgeInsets.only(left:20),
        child: Padding(
          padding: const EdgeInsets.only( left: 20),
          child: Row(
            children: [
               Column(
              children: const [
                Text('Duração',
                style: TextStyle(fontSize: 13)
                ),
                 Text('1h25',
                style: TextStyle(fontSize: 13)
                ),
              ],
            ),
                Padding(
                  padding: const EdgeInsets.only(right:10.0, left: 10.0),
                  child: Container(
          height: 35,
          width: 1,
          color: Colors.black,
      ),
                ),
               Column(
              children: const [
                Text('Média p/ exercício',
                style: TextStyle(fontSize: 13)
                ),
                 Text('12 minutos',
                style: TextStyle(fontSize: 13)
                ),

              ],
            ),
                Padding(
                  padding: const EdgeInsets.only(right:10.0, left: 10.0),
                  child: Container(
          height: 35,
          width: 1,
          color: Colors.black,
      ),
                ),
               Column(
              children: const [
                Text('Treino',
                style: TextStyle(fontSize: 13)
                ),
                 Text('Peito',
                style: TextStyle(fontSize: 13)
                ),
              ],
            ),
          ],
          ),
        ),
      ),
     const SizedBox(height: 15,),
      Padding(
        padding: const EdgeInsets.only(left:9),
        child: Row(
         children: [
          Padding(
           padding: const EdgeInsets.only( left: 20),
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left:6.0),
                    child: Align(
                    alignment: Alignment.centerLeft,
                      child:
                     Text('Supino inclinado com halter',
                     style: TextStyle(fontSize: 11),
                    ),

                    ),
                  ),
                ),

              ],
         ),
          ),
            Column(
  children: [
          const Padding(
            padding: EdgeInsets.only(left:0.0),
            child: Text('Qntd. séries', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(left:0.0),
            child: Text('4', style: TextStyle(fontSize: 11)),
          ),
          const SizedBox(height: 2),
         // ignore: avoid_unnecessary_containers
    Padding(
      padding: const EdgeInsets.only(left:20.0,),
      child: Table(
  border: TableBorder.all(
    color: Colors.black,
    width: 1,
    style: BorderStyle.solid,
  ),
  defaultColumnWidth: const FixedColumnWidth(65),
  children: const [
      TableRow(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text('2º Série', style: TextStyle(fontSize: 12)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text('36kg', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      TableRow(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text('1º Série', style: TextStyle(fontSize: 12)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text('32kg', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
  ],
),
    ),

],
)
         ],
        ),
      ),
    const SizedBox(height: 15,),
Padding(
  padding: const EdgeInsets.all(0.0),
  child: Column(
    children: [
      Container(
        width: double.infinity,
        height: 60,
        color: const Color.fromRGBO(240, 240, 240, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.favorite),
             VerticalDivider(
              color: Colors.grey,
              thickness: 1,
              width: 20,
              indent: 15,
              endIndent: 10,
            ),
            Icon(Icons.mode_comment),
          ],
        ),
      ),
    ],
  ),
),
    ],
  ),
);

  }
}