import 'dart:convert';
import 'package:b_w/view/order/view_location_delivery.dart';
import 'package:b_w/view/send_balance.dart';
import 'package:b_w/widgets/showdialoading.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:b_w/contoller/getdata.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  String id_user;

  MyOrders({required this.id_user});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  GetData getData = new GetData();
  var sum_prices = "0";
  var sum_prices_confirm = "0";
  List id_order = [];
  bool confirm = false;
  late String order_state;
  late String delvery_state = "0";

  Future post_get_data() async {
    var url =
        Uri.parse("http://192.168.15.40:8080/B_W/orders/sum_price_order.php");
    var data = {"id": widget.id_user};
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);
    if (responsbody[0]["sum"] != null) {
      sum_prices = responsbody[0]["sum"];
      if (responsbody[0]["order_status"] == "0") {
        confirm = true;
      } else {
        confirm = false;
      }
    }


    return responsbody;
  }

  Future getdata() async {
    var url =
        Uri.parse("http://192.168.15.40:8080/B_W/orders/view_myorders.php");
    var data = {"id": widget.id_user};
    var response = await http.post(url, body: data);
    var responsbody = jsonDecode(response.body);
    delvery_state = responsbody[0]['delivery_status'];
    for(int i=0;i<responsbody.length;i++)
      {
        id_order.add(responsbody[i]['id_order']);
      }
    setState(() {

    });
    return responsbody;
  }

  Future update_late_log_data() async {
    try {
      cl = await getLatAndLong();

      var url =
          Uri.parse("http://192.168.15.40:8080/B_W/users/update_lat_long.php");
      var data = {
        "id": widget.id_user,
        "latitude": cl.latitude.toString(),
        "longitude": cl.longitude.toString()
      };
      var response = await http.post(url, body: data);
      var responsbody = jsonDecode(response.body);
      showdialogall(context, "تم", "تم تحديث موقعك");

      return responsbody;
    } catch (e) {}
  }

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
    x = double.parse(sum_prices);
    y = double.parse(balance_user);
    setState(() {});
    return responsbody;
  }

  Future update_balance() async {
    if (x < y) {
      var result = await BarcodeScanner.scan();
      setState(() {
        res = result.rawContent;
      });
      var data = {"id_b_w": res, "id": widget.id_user, "balance": sum_prices};
      var url =
          Uri.parse("http://192.168.15.40:8080/B_W/users/update_balance.php");
      var response = await http.post(url, body: data);
      var respnsebody = jsonDecode(response.body);
      if (respnsebody['status'] == 'success') {
        showdialogall(context, "تمت العملية", "  تمت التعبئة بنجاح ");

      }
    } else {
      showdialogall(context, "خطأ", "رصيدك غير كافي لدفع الفاتورة");
    }
  }

  @override
  void initState() {
    post_get_data();
    getdata();
    get_my_balance();
    super.initState();
  }

  Future<Position> getLatAndLong() async {
    return await Geolocator.getCurrentPosition().then((value) => value);
  }

  @override
  void dispose() {
    id_order.clear();
    super.dispose();
  }

  late Position cl;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("طلباتي"),
            centerTitle: true,
          ),
          body: sum_prices=="0"?SizedBox(height: 0,):Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: FutureBuilder(
                  future: getdata(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          List list = snapshot.data;
                          order_state = list[index]['order_status'];

                          return Container(
                            height: 200,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: Card(
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 190,
                                    padding: const EdgeInsets.only(top: 15),
                                    // alignment: Alignment.center,
                                    color: Colors.black26,
                                    //alignment: Alignment.topRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "الطلب : " +
                                              list[index]['name_food_dishes'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          " من مطعم :" +
                                              list[index]['username'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          " السعر : " + list[index]['price'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        order_state == "0"
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    getData.delet_data(
                                                        list[index]['id_order'],
                                                        "orders/delete_order");
                                                    post_get_data();
                                                  });
                                                },
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red,
                                                    size: 25),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child:SizedBox(height: 0,));
                  },
                ),
              ),
               Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text("السعر الاجمالي للطلب  :   ${sum_prices}   ل س"),
              ),
              confirm
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            update_late_log_data();
                          },
                          child: const Text("ارسال الطلب الى موقعي الحالي"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shadowColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              textStyle: const TextStyle(fontSize: 20)),
                        ),
                        ElevatedButton(
                          onPressed: () async{

                            setState(() {
                              for (int i = 0; i < id_order.length; i++) {

                                getData.post_get_data(id_order[i], "orders/confirm_order");

                              }
                              id_order.clear();
                              confirm = false;
                            });
                          },
                          child: const Text("تأكيد الطلب"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shadowColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              textStyle: const TextStyle(fontSize: 20)),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "تم تأكيد الطلب سيتم تفعيل خدمة تتبع الطلب لحظة استلام الديلفري الطلب",
                            textAlign: TextAlign.center,
                          ),
                          delvery_state == "1"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ViewLocationdelivery();
                                        }));
                                      },
                                      child: const Text("تتبع الديلفري"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.cyan,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          shadowColor: Colors.blue,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          textStyle:
                                              const TextStyle(fontSize: 20)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        update_balance();
                                      },
                                      child: const Text("الدفع عبر  QR"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.orangeAccent,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          shadowColor: Colors.orange,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          textStyle:
                                              const TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: Text(
                                    "لم يتم استلام الطلب من قبل الموظف ",
                                    style: TextStyle(color: Colors.cyan),
                                  ),
                                )
                        ],
                      ),
                    ),
            ],
          )),
    );
  }
}
