import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userName;
  const HomePage({super.key , required this.userName});

  @override
  Widget build(BuildContext context) {

    return  Center(
    child: Text(
    "welcome , $userName"),
    
   
    );
  }
}