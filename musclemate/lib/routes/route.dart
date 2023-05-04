import 'package:flutter/material.dart';
import 'package:musclemate/screen/home_page.dart';
import 'package:musclemate/screen/perfil_page.dart';
import 'package:musclemate/screen/record_page.dart';


class Routes {
  static const String home = '/';
  static const String record = '/record';
  static const String perfil = '/perfil';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case record:
        return MaterialPageRoute(builder: (_) => const RecordPage());
      case perfil:
        return MaterialPageRoute(builder: (_) => const PerfilPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
