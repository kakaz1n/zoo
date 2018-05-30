import 'package:flutter/material.dart';
//importando paginas
import 'Leitor.dart' as Leitor;
import 'Home.dart' as Home;
import 'Lista.dart' as Lista;
import 'Eventos.dart' as Eventos;
import 'Ajustes.dart' as Ajustes;

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyTabs()
  ));
}

class MyTabs extends StatefulWidget{
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin{
//single.... permite animação
  TabController _controle; //controlador da tab
  String _titulo;
  final List<String> _titulos =[
    "Lista de animais",    
    "Eventos",
    "Home",
    "Leitor",
    "Ajustes"
  ];

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _controle = new TabController(vsync: this, length: 5); //tamanho de tavs q tem
      _titulo = _titulos[2];
      _controle.index=2; // começando na home
      _controle.addListener(_atualizatitulo);//adicionando listener ao controle
    }
    void _atualizatitulo(){
      setState(() {
              _titulo = _titulos[_controle.index]; //atualizando titulo
            });
    }
 @override
    void dispose() {
      // TODO: implement dispose
      _controle.dispose();
      super.dispose();
    }   
  @override
  Widget build(BuildContext context){
    //_controle.index = 2; //começando na home
    return new Scaffold(
      
      appBar: new AppBar(
        //titulo n ta trocando
      title: new Text(_titulo) ,// fazer switch pra titulos OK
      backgroundColor: Colors.green,
     /* bottom: new TabBar( //tabs no bottom do appBar
        controller: controle,
        tabs : <Tab>[
          new Tab(icon: new Icon(Icons.local_pizza)),
          new Tab(icon: new Icon(Icons.book)),
          new Tab(icon: new Icon(Icons.home))

        ]
      )*/),
      body: new TabBarView(
        controller: _controle,       
        children: <Widget>[ //representam as paginas pra cada tab
          new Lista.Lista(),
          new Eventos.Eventos(),
          new Home.Home(),
          new Leitor.Leitor(),
          new Ajustes.Ajustes()
        ],
      ),
      bottomNavigationBar: new Material(
        color: Colors.green,
        child: new TabBar(
          controller: _controle,
          tabs : <Tab>[ //iniciando as tabs
          //mudar os icones
          new Tab(icon: new Icon(Icons.list)),
          new Tab(icon: new Icon(Icons.notifications)),          
          new Tab(icon: new Icon(Icons.home),),          
          new Tab(icon: new Icon(Icons.search)),
          new Tab(icon: new Icon(Icons.settings)),       
        ]
        )
      )
    );
  }
}
