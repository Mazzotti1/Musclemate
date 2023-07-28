import 'package:flutter/material.dart';


class RecordingTutorial extends StatefulWidget {
  @override
  _RecordingTutorialState createState() => _RecordingTutorialState();
}

class _RecordingTutorialState extends State<RecordingTutorial> {
  int currentPage = 0;

  void nextPage() {
    setState(() {
      currentPage++;
    });
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Você iniciou seu primeiro treino!', textAlign: TextAlign.center,),
      content: _getDialogContent(currentPage),
      actions: <Widget>[
        if (currentPage > 0)
          TextButton(
            onPressed: previousPage,
            child: Text('Anterior', style: TextStyle(color: Colors.black)),
          ),
        if (currentPage < _getTotalPages() - 1)
          TextButton(
            onPressed: nextPage,
            child: Text('Próximo',style: TextStyle(color: Colors.black)),
          ),
        if (currentPage == _getTotalPages() - 1)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Entendi',style: TextStyle(color: Colors.black)),
          ),
      ],
    );
  }

  Widget _getDialogContent(int currentPage) {
    switch (currentPage) {
      case 0:
        return SingleChildScrollView(
          child: Column(
                children: [
                  Text('Você só precisa escolher qual o grupo muscular e então basta pessquisar qual é o exercício', textAlign: TextAlign.center,),
                  SizedBox(height:20),
                  Row(
                  children: [
                    SizedBox(width: 60,),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                                return const Color.fromRGBO(255, 204, 0, 1);
                            },
                          ),
                        ),
                        child: Text(
                           'Peito',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 30,),
                       ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                            return const Color.fromRGBO(217, 217, 217, 1);
                        },
                      ),
                    ),
                    child: Text(
                       'Biceps',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  ],
                ),
                ],
              ),
        );
      case 1:
        return SingleChildScrollView(
                  child: Column(
                    children: [
                     Text('Use a barra de pesquisa para achar o seu exercício!', textAlign: TextAlign.center,),
                      SizedBox(height: 20),
                      Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, color: Colors.black45),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 180, // Definir a largura desejada para o TextField
                        child: TextField(
                          onChanged: (searchText) {
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
                   ],
                  ),
                );
      case 2:
        return SingleChildScrollView(
          child:Column(
  children: [
    Text(
      'Você pode pausar o treino, finalizar ele ou retomar depois da pausa',
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centraliza os botões horizontalmente
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(184, 0, 0, 1),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.square,
              color: Colors.white,
              size: 28,
            ),
            iconSize: 60,
          ),
        ),
      ],
    ),
    Padding(
      padding: const EdgeInsets.only(top:10.0, bottom: 10),
      child: Container(
      width: double.infinity,
      height: 1,
      color: Colors.black,
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(215, 242, 132, 1),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            ),
            iconSize: 60,
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.black,
              size: 30,
            ),
            iconSize: 60,
          ),
        ),
      ],
    ),
  ],
),
        );

      default:
        return Text('Bem vindo(a) a Musclemate');
    }
  }

  int _getTotalPages() {
    return 3;
  }
}