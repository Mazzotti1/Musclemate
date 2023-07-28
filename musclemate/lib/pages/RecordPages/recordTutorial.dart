import 'package:flutter/material.dart';


class RecordTutorial extends StatefulWidget {
  @override
  _RecordTutorialState createState() => _RecordTutorialState();
}

class _RecordTutorialState extends State<RecordTutorial> {
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
      title: Text('Bem-vindo(a) a Musclemate!', textAlign: TextAlign.center,),
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
                  Text('Aqui são as opções de grupos musculares e também os seus treinos padrões, você pode selecionar eles para iniciar um treino ou criar um novo treino padrão', textAlign: TextAlign.center,),
                  SizedBox(height:20),
                Row(
                  children: [
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
                       'Triceps',
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
                      Text('Este é o botão de Treino padrão, nele você consegue criar o treino completo para poupar tempo! Você só precisa escolher os grupos musculares apertar esse ícone e escolher seus exercícios.', textAlign: TextAlign.center,),
                      SizedBox(height: 20),
                      TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(217, 217, 217, 1),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(50, 50),
                        ),
                      ),
                      child: const Icon(Icons.fitness_center_rounded, color: Colors.black87),
                    ),
                   ],
                  ),
                );
      case 2:
        return SingleChildScrollView(
          child: Column(
                children: [
                  Text('Esse é o botão de Iniciar, após você escolher os grupos musculares ou algum treino padrão você pode INICIAR o treino', textAlign: TextAlign.center,),
                  SizedBox(height:20),
                  TextButton(
                          onPressed: (){
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(194, 255, 26, 1),
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(80, 80),
                            ),
                          ),
                          child: const Text('Iniciar', style: TextStyle(color: Colors.black)),
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