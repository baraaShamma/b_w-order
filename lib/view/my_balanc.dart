import 'dart:convert';

import 'package:b_w/contoller/getdata.dart';
import 'package:b_w/widgets/showdialoading.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyBalance extends StatefulWidget {
  final String id_user;

  MyBalance({required this.id_user});

  @override
  _MyBalanceState createState() => _MyBalanceState();
}

class _MyBalanceState extends State<MyBalance> {
  String balance_user="";
  Future post_get_data() async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/users/user.php");
    var data = {"id": widget.id_user};
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);
    balance_user=responsbody[0]["balance"];
    setState(() {

    });
    return responsbody;
  }
  String qrResult = "0";
  String name_card = " ";
  String balance = " ";
  String res = "";

  Future add_balance() async {
    if (qrResult == "0") {
      showdialogall(context, "خطأ", "يرجى مسح البطاقة اولا");
    } else {
      var data = {
        "name_card": name_card,
        "id": widget.id_user,
        "balance": balance
      };
      var url = Uri.parse(
          "http://192.168.15.40:8080/B_W/qr/confirm_up_to_balance.php");
      var response = await http.post(url, body: data);
      var respnsebody = jsonDecode(response.body);
      if (respnsebody['status'] == 'success') {
        showdialogall(context, "تمت العملية",
            "  تمت التعبئة بنجاح ");
        setState(() {

        });
      } else {
        showdialogall(
            context, "فشل العملية", "هذه البطاقة مستخدمة من قبل او غير مطابقة");
      }
    }
  }

  Future delet_card() async {

    var url = Uri.parse(
        "http://192.168.15.40:8080/B_W/qr/delete_top_up_card.php");
    var data = {"name_card": name_card};
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);
    return responsbody;
  }
  @override
  void initState() {
    post_get_data();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "رصيدك الحالي",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              balance_user,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(
              height: 20.0,
            ),

            Text(
              "رصيد البطاقة :" + qrResult,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text("ادخال البطاقة"),
              onPressed: () async {
                var result = await BarcodeScanner.scan();
                setState(() {
                  res = result.rawContent;
             //     print(name_card);
                  name_card = res.split("/").first;
                  qrResult = res.split("/").last;
                  var x = double.parse(qrResult);
                  var y = double.parse(balance_user);
                  var balnce_user = x + y;
                  balance = balnce_user.toString();
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.white, width: 3.0)),
            ),
            Padding(padding: EdgeInsets.all(5)),
            // ignore: deprecated_member_use
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text("تأكيد عملية التعبئة"),
              onPressed: () async {
                setState(() {

                     add_balance();
                    delet_card();
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.white, width: 3.0)),
            ),
          ],
        ),
      ),
    );
  }
}
