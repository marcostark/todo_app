import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/components/todo_dialog.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.cyan,
        primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _todoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;


  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });

  }

  void _addToDo() async {
    final todo = await showDialog(
        context: context,
      builder:(BuildContext context) {
        return TodoDialog();
      }
    );

    if(todo != null) {
      setState(() {
        Map<String, dynamic> newTask = Map();
        newTask["title"] = todo;
        _toDoController.text = "";
        newTask["concluida"] = false;
        _todoList.add(newTask);
        _saveData();
    });
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b){
        if(a["concluida"] && !b["concluida"]) return 1;
        else if(!a["concluida"] && b["concluida"]) return -1;
        else return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("TODO List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _todoList.length,
                    itemBuilder: _getBuildItem),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton (
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add),
        onPressed: _addToDo,
      ),
    );
  }

  Widget _getBuildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"], style: TextStyle(color: Colors.black54),),
        value: _todoList[index]["concluida"],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]["concluida"] ?
          Icons.check : Icons.timer, color: Colors.white,),
          backgroundColor: Colors.cyan,
        ),
        onChanged: (check){
          setState(() {
            _todoList[index]["concluida"] = check;
            _saveData();
          });
        },
        activeColor: Colors.cyan,
      ),
      onDismissed: (direction){
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPos = index;
          _todoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _todoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
            duration: Duration(seconds: 3),
          );

          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Pegando o diretorio onde sera armazenado o arquivo
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
