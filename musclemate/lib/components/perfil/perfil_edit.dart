
import 'package:flutter/material.dart';




class PerfilEdit extends StatefulWidget {
  const PerfilEdit({Key? key}) : super(key: key);

@override
  _PerfilEditState createState()=> _PerfilEditState();
}
class _PerfilEditState extends State<PerfilEdit>{

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top:40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_outline_rounded, size: 90),
            SizedBox(width: 20),
          ],
        ),
      ),
      const SizedBox(height: 20), // Espaço entre o ícone e a nova linha
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
               const Padding(
                 padding: EdgeInsets.only(right:130.0),
                 child: Text(
                      'Nome',
                      style: TextStyle(color: Colors.black54),
                    ),
               ),
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Digite seu nome',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           const SizedBox(width: 20),
          Column(
            children: [
               const Padding(
                 padding: EdgeInsets.only(right:90.0),
                 child: Text(
                      'Sobrenome',
                      style: TextStyle(color: Colors.black54),
                    ),
               ),
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Digite seu sobrenome',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

      ),
       const SizedBox(height: 40),
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Cidade',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           const SizedBox(width: 20),
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Estado',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],

      ),
    const SizedBox(height: 40),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Column(
      children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black45),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Biografia',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),

    const  SizedBox(height: 60),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Column(
      children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black45),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Data de nascimento',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),
 const SizedBox(height: 40),
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Gênero',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           const SizedBox(width: 20),
          Column(
            children: [
              Container(
                width: 170,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black45),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Peso',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],

      ),

    ]
  );
}
}