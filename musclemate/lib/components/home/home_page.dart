import 'package:flutter/material.dart';
import 'package:musclemate/screen/Feed_page.dart';
import 'package:musclemate/screen/perfil_page.dart';
import 'package:musclemate/screen/record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int paginaAtual;
  late List<Widget> pages;
  late GlobalKey<NavigatorState> navigatorKey;

  @override
  void initState() {
    super.initState();
    paginaAtual = 0;
    pages = [const FeedPage(), const RecordPage(), const PerfilPage()];
    navigatorKey = GlobalKey<NavigatorState>();
  }

  void setPaginaAtual(int pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Navigator(
            key: navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder;
              switch (settings.name) {
                case '/':
                  builder = (_) => pages[paginaAtual];
                  break;
                case '/feed':
                  builder = (_) => const FeedPage();
                  break;
                case '/record':
                  builder = (_) => const RecordPage();
                  break;
                case '/perfil':
                  builder = (_) => const PerfilPage();
                  break;
                default:
                  throw Exception('Invalid route: ${settings.name}');
              }
              return MaterialPageRoute(builder: builder, settings: settings);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              currentIndex: paginaAtual,
              backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
              selectedItemColor: Colors.black,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer),
                  label: 'Gravar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
              onTap: (pagina) {
          if (pagina != paginaAtual) {
            setPaginaAtual(pagina);
            navigatorKey.currentState?.push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (_, __, ___) => pages[pagina],
                transitionsBuilder: (_, animation, __, child) => ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
},

            ),
          ),
        ],
      ),
    );
  }
}
