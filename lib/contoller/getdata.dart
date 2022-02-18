import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class GetData {
  TextEditingController send_balance = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  getdata(String name) async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/$name.php");
    var response = await http.get(url);
    var responsebody = jsonDecode(response.body);
    return responsebody;
  }

  Future post_get_data(id, name) async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/$name.php");
    var data = {"id": id};
    var response = await http.post(url, body: data);
    var responsbody =  jsonDecode(response.body);
    return responsbody;
  }

  Future post_data(
      id_user, id_restaurant, id_section, id_food_dishe, prices, name) async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/$name.php");
    var data = {
      "id_user": id_user,
      "id_restaurant": id_restaurant,
      "id_section": id_section,
      "id_food_dishe": id_food_dishe,
      "prices": prices,

    };
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);
    return responsbody;
  }
  Future delet_data(id, name) async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/$name.php");
    var data = {"id": id};
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);

    return responsbody;
  }


}
