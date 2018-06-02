import 'package:flutter/material.dart';

import 'Lista.dart';

class Animal extends StatelessWidget{
  final Item animal;
  Animal({Key key,this.animal}) : super(key:key);
  //n conseguir passar o item
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Title(child: new Text(animal.nome_popular,textScaleFactor: 3.0),color: Colors.black),
          new Image.network(animal.imagem), //mudar pra foto armazenada        
          new Text("${animal.desc}"),     
        ],
      )
    );
  }
}
