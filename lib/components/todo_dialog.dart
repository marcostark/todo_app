import 'package:flutter/material.dart';

class TodoDialog extends StatelessWidget {

  final controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Tarefa'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            final todo = controller.value.text;
            controller.clear();
            Navigator.of(context).pop(todo);
          },
        ),
      ],
    );
  }
}

