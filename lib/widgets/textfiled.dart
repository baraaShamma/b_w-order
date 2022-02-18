import 'package:flutter/material.dart';
class TextFiled extends StatelessWidget {
    final max_value;
    final min_value;
    final message_max_value;
    final message_min_value;
    final hintText;
    final control;

   TextFiled({Key? key, this.max_value, this.min_value, this.message_max_value, this.message_min_value, this.hintText,this.control}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: control,
      onSaved: (val) {
        var emaill = val;
      },
      validator: (val) {
        if (val!.length > max_value) {
          return message_max_value;
        }
        if (val.length < min_value) {
          return message_min_value;
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1),gapPadding:10 ),fillColor: Colors.tealAccent,focusColor: Colors.white,hoverColor: Colors.yellow),
    );
  }
}
