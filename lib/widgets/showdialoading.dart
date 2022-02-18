import 'package:flutter/material.dart';
showdialogall(context, String mytitle, String mycontent) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(mytitle),
          content: Text(mycontent),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("تم"))
          ],
        );
      });
}
