import 'package:flutter/material.dart';

class TodoDialog extends StatelessWidget {
  final controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Color.fromRGBO(58, 66, 86, 1.0)),
      child: AlertDialog(
        title: Text(
          'Nova Tarefa',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          cursorColor: Colors.white,
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan),
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar', style: TextStyle(color: Colors.cyanAccent)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Add', style: TextStyle(color: Colors.cyanAccent)),
            onPressed: () {
              final todo = controller.value.text;
              controller.clear();
              Navigator.of(context).pop(todo);
            },
          ),
        ],
      ),
    );
  }
}
