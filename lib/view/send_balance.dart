import 'dart:convert';
import 'package:b_w/widgets/showdialoading.dart';
import 'package:http/http.dart' as http;

import 'package:b_w/contoller/getdata.dart';
import 'package:b_w/utils/constants.dart';
import 'package:b_w/widgets/textfiled.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';

class SendBalance extends StatefulWidget {
  final id_user;
  final price_order;

  SendBalance({required this.id_user, required this.price_order});

  @override
  _SendBalanceState createState() => _SendBalanceState();
}

class _SendBalanceState extends State<SendBalance> {
  var x;
  var y;

  String res = "";
  String qrResult = "0";
  String balance_user = "";
  Future get_my_balance() async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/users/user.php");
    var data = {"id": widget.id_user};
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);
    balance_user = responsbody[0]["balance"];
    x = double.parse(widget.price_order);
    y = double.parse(balance_user);
    if (x < y) {
      print("baraa");
    }

    setState(() {});
    return responsbody;
  }

  Future update_balance() async {
    if (x < y) {
      var result = await BarcodeScanner.scan();
      setState(() {
        res = result.rawContent;
      });
      var data = {"id_b_w": res, "id": widget.id_user, "balance": widget.price_order};
      var url = Uri.parse(
          "http://192.168.15.40:8080/B_W/users/update_balance.php");
      var response = await http.post(url, body: data);
      var respnsebody = jsonDecode(response.body);
      if (respnsebody['status'] == 'success') {
        showdialogall(context, "تمت العملية", "  تمت التعبئة بنجاح ");
        setState(() {});
      }
    }
    else {
      showdialogall(context, "خطأ", "رصيدك غير كافي لدفع الفاتورة");
    }
  }

  @override
  void initState() {
    get_my_balance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ارسال رصيد"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(

            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                        child: TextFiled(

                      hintText: "الرجاء ادخال قيمة الفاتورة",
                      max_value: 20,
                      min_value: 1,
                      message_max_value: " قيمة الفاتورة المدخل اكبر من 6 رقم",
                      message_min_value: "قيمة الفاتورة المدخل اقل من 1 رقم",
                    )),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                ElevatedButton(
                    onPressed: () async {
                      update_balance();
                    }, child: Text("قراءة البار كود"))
              ],
            ),
          ),
        ));
  }
}
