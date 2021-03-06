import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'dart:async';
/*
final FirebaseApp app = await FirebaseApp.configure(
 options: new FirebaseOptions(
   googleAppID: '1:498368104232:android:c6e99602c9e4abb1',
   apiKey: 'AIzaSyBSTNoUH_BM9x3R14SqQiTYVNLazxcaEGU',
   databaseURL: 'https://zoologico-d116b.firebaseio.com',
  )
);
*/
//precisa colocar ios
class Lista extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "Lista",
      theme: ThemeData.light(),
      home: Home(),      
      debugShowCheckedModeBanner: false,
    );
  }
}

 Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'zoologico',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:498368104232:ios:c6e99602c9e4abb1',
            gcmSenderID: '498368104232',
            databaseURL: 'https://zoologico-d116b.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:297855924061:android:669871c998cc21bd',
            apiKey: 'AIzaSyBSTNoUH_BM9x3R14SqQiTYVNLazxcaEGU',
            databaseURL: 'https://zoologico-d116b.firebaseio.com',
          ),
  );
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new Home(app: app),
  ));
}


class Home extends StatefulWidget{
  Home({this.app});
  final FirebaseApp app;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState()
  {
    super.initState();
    item = Item("",""); //colocando valores nulos primeoro
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    itemRef = database.reference().child("Animais"); // nome da tabela
    itemRef.onChildAdded.listen(_onEntryAdded); // quando entrar algum item
    itemRef.onChildChanged.listen(_onEntryChanged);  //mudar algo
  }

  _onEntryAdded(Event event){
    setState(() {
          items.add(Item.fromSnapshot(event.snapshot));
        });
  }

  _onEntryChanged(Event event){
    var old = items.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });
    setState(() {
          items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
        });
  }

  void handleSubmit(){
    final FormState form = formKey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(      
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
        /*Flexible(
          flex: 0,
          child: Center(
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.info),
                    title: TextFormField(
                      initialValue: "",
                      onSaved: (val) => item.nome_popular = val,                      
                      validator: (val) => val == ""? val: null,
                    ),
                  ),                  
                  ListTile(
                    leading: Icon(Icons.info),
                    title: TextFormField(
                      initialValue: '',
                      onSaved: (val) => item.desc = val,
                      validator: (val) => val == ""? val: null,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      handleSubmit();
                    },
                  ),
                ],
              ),
            ),
          )
        ),*/ // para inserir elementos
        Flexible( // transformar em funcao
          child: FirebaseAnimatedList(
            query: itemRef,
            //sort: item.sort(),//(a,b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()),
            sort: item.Sort(items),
            itemBuilder:(BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index){
              return new ListTile(
                leading: Icon(Icons.donut_large),
                title: Text(items[index].nome_popular),
                subtitle: Text(items[index].desc),
              );
            },
          )
        ),
        ],
      ),
    );
  }
}

class Item implements Icons{
  String key;
  String nome_popular;
  String desc;
  //colocar o outros valores
  Item(this.nome_popular, this.desc);

  Item.fromSnapshot(DataSnapshot snapshot)
    :key = snapshot.key,
    nome_popular = snapshot.value["nome_popular"],
    desc = snapshot.value["desc"];
  Sort(List<Item> items) => items.sort((a,b) {
return a.nome_popular.toLowerCase().compareTo(b.nome_popular.toLowerCase());
  });
  toJson(){
    return{
      "nome_popular": nome_popular,
      "desc": desc,
    };
  }
}