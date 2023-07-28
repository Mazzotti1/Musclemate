import 'package:flutter/material.dart';


class WelcomeDialog extends StatefulWidget {
  @override
  _WelcomeDialogState createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
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
                  Text('Aqui é onde você pode procurar novos usuários, ver suas notificações e acessar suas configurações!', textAlign: TextAlign.center,),
                  SizedBox(height:20),
                  Container(
                    color: const Color.fromRGBO(32, 48, 105, 1),
                    height: 50,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: Text('Início', style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(width: 90,),
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.person_add,color: Colors.white,),
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.notifications,color: Colors.white,),
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.settings,color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        );

      case 1:
        return SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Este espaço é o feed onde os seus treinos e os treinos de seus amigos que você segue irão aparecer', textAlign: TextAlign.center,),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: Text(
                                  'Bom treino!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              Icon(
                                Icons.warning,
                                size: 48,
                                color: Colors.yellow,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Ops...',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
                                child: Text(
                                  'Ainda não há nada no feed. Conecte-se com outros usuários para começar a ver os treinos de seus amigos!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),

                                ),
                              ),
                            ],
                          ),
                        ),

                      ),

                    ],
                  ),
                );
      case 2:
        return SingleChildScrollView(
          child: Column(
                children: [
                  Text('Essa é a barra de navegação para ir gravar um treino ou visualizar o seu perfil', textAlign: TextAlign.center,),
                  SizedBox(height:20),
                  Container(
                    color: const Color.fromRGBO(240, 240, 240, 1),
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 35,),
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.home,color: Colors.black,),
                        ),
                        SizedBox(width: 35,),
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.timer,color: Colors.black54,),
                        ),
                        SizedBox(width: 35,),
                        IconButton(
                          onPressed: (){},
                          icon: const Icon(Icons.person,color: Colors.black54,),
                        ),
                      ],
                    ),
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