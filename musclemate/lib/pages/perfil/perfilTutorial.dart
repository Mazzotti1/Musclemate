import 'package:flutter/material.dart';


class PerfilTutorial extends StatefulWidget {
  @override
  _PerfilTutorialState createState() => _PerfilTutorialState();
}

class _PerfilTutorialState extends State<PerfilTutorial> {
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
      title: Text('Este é o seu perfil!', textAlign: TextAlign.center,),
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
                  Text('Aqui são as 3 abas do seu perfil, Progresso, Atividades e Perfil. ', textAlign: TextAlign.center,),
                  SizedBox(height:20),
                  Container(
                    color: const Color.fromRGBO(32, 48, 105, 1),
                    height: 50,
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left:20.0),
                          child: Text('Progresso', style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(width: 20,),
                        Text('Atividades', style: TextStyle(color: Colors.white),),
                        SizedBox(width: 20,),
                        Text('Perfil', style: TextStyle(color: Colors.white),),
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
                     Text('Primeira é a aba de progresso, onde mostra os gráficos de sua evolução onde cada um tem sua explicação!', textAlign: TextAlign.center,),
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
                      child: const Icon(Icons.add_chart, color: Colors.black87),
                    ),
                   ],
                  ),
                );
      case 2:
        return SingleChildScrollView(
          child: Column(
                children: [
                  Text('Segunda é a aba de Atividades, onde mostra todos teus registros de treinos', textAlign: TextAlign.center,),
                  SizedBox(height:20),
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
                      child: const Icon(Icons.notifications_active, color: Colors.black87),
                    ),
                ],
              ),
        );
        case 3:
        return SingleChildScrollView(
          child: Column(
                children: [
                  Text('E por último é a aba de Perfil, onde você pode ver suas estátisticas gerais, quem você esta seguindo e seus seguidores e atualizar as informações de seu perfil ', textAlign: TextAlign.center,),
                  SizedBox(height:20),
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
                      child: const Icon(Icons.person, color: Colors.black87),
                    ),
                ],
              ),
        );


      default:
        return Text('Bem vindo(a) a Musclemate');
    }
  }

  int _getTotalPages() {
    return 4;
  }
}