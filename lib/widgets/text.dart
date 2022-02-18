import 'package:flutter/material.dart';
class Teext extends StatelessWidget {
  final text;
  final color;
  final size;

  const Teext({Key? key, this.text, this.color, this.size}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(color: color,fontSize: size),);
  }
}
