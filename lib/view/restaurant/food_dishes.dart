import 'package:b_w/contoller/auth.dart';
import 'package:b_w/contoller/getdata.dart';
import 'package:flutter/material.dart';

class FoodDishes extends StatefulWidget {
  final id_res_section;
  final id_res;

  FoodDishes({required this.id_res_section, required this.id_res});

  @override
  _FoodDishesState createState() => _FoodDishesState();
}

class _FoodDishesState extends State<FoodDishes> {
  GetData getData = new GetData();
  Auth getPref = new Auth();

  @override
  void initState() {
    getPref.getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
          future: getData.post_get_data(
              widget.id_res_section, "restaurants/food_dishes"),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Container(
                        color: Colors.blue.shade100,
                        height: 230,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 110,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.yellowAccent.shade100,
                                        blurRadius: 1,
                                        spreadRadius: 3,
                                        offset: const Offset(1, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        "http://192.168.15.40:8080/B_W/upload/qfood_dishes/${list[index]['image_food']}",
                                      )),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          "${list[index]['name_food_dishes']}"),
                                      Text("${list[index]['price']}" + " ل س")
                                    ],
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "إضافة الى طلبي",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    splashColor: Colors.blue,
                                    highlightColor: Colors.white,
                                    onTap: () {
                                      getData.post_data(
                                          getPref.id,
                                          widget.id_res,
                                          widget.id_res_section,
                                          list[index]['id_food'],
                                          list[index]['price'],
                                          "orders/insert_order");
                                    },
                                  )
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 2, right: 8),
                                  child: Text("${list[index]['describe']}"))
                            ],
                          ),
                        ),
                      );
                    })
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
