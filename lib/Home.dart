import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Container(
      child : new Center(
        child: new Icon(Icons.home, size:150.0, color: Colors.cyan)
      )
    );
  }
}