import 'package:flutter/material.dart';
import 'package:movie_app/homepage.dart';

void main(){
  runApp(
    Myapp(),
  );
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          
        )
      ),
      home: Home(),
    );
  }
}




