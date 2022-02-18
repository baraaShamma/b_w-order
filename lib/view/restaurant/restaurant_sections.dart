import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:b_w/contoller/getdata.dart';
import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

import 'food_dishes.dart';

class RestaurantSections extends StatefulWidget {
  final id;
  final String image;
  final String image_restaurant;
  final String username;
  final String beginning_work;
  final String finished_work;

  RestaurantSections(
      {required this.image,
      required this.image_restaurant,
      required this.username,
      required this.beginning_work,
      required this.finished_work,
      this.id});

  @override
  _RestaurantSectionsState createState() => _RestaurantSectionsState();
}

class _RestaurantSectionsState extends State<RestaurantSections>
    with SingleTickerProviderStateMixin {
  GetData getData = new GetData();

  SwiperController _scrollController = new SwiperController();

  late TabController tabController;

  int currentindex2 = 0; // for swiper index initial

  int selectedIndex = 0; // for tab
  List baraa = [];
  late int i;
  List id_res_section = [];

  Future getdata() async {
    var url = Uri.parse(
        "http://192.168.15.40:8080/B_W/restaurants/restaurant_sections.php");
    var urll = Uri.parse(
        "http://192.168.15.40:8080/B_W/restaurants/count_restaurant_sections.php");
    var data = {"id": widget.id};
    var dd = {"cat": widget.id};
    var response = await http.post(url, body: data);
    var response2 = await http.post(urll, body: dd);
    var responsbody = jsonDecode(response.body);
    var responsbody2 = jsonDecode(response2.body);
    int x = await responsbody2["status"];
    for (i = 0; i < x; i++) {
      baraa.add(responsbody[i]["name_sections"]);
      id_res_section.add(responsbody[i]["id_res_section"]);
    }
    setState(() {});
    return responsbody;
  }

  barraa() async {
    await getdata();
    tabController =
        TabController(length: baraa.length, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      setState(() {
        _scrollController.move(tabController.index);
      });
    });
  }

  @override
  void initState() {
    barraa();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: baraa.length,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Container(
            child:  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          //      border: Border.all(width: 100, color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                "http://192.168.15.40:8080/B_W/upload/qrestaurants/${widget.image}",
                              )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        color: Colors.white,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  width: 70,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                            offset: Offset(1, 1))
                                      ],
                                      //      border: Border.all(width: 100, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            "http://192.168.15.40:8080/B_W/upload/qrestaurants/${widget.image_restaurant}",
                                          ))),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    widget.username,
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    widget.beginning_work + " am",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    " <--",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    widget.finished_work + " pm",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      baraa.isEmpty
                          ? const Center(
                        child: SizedBox(height: 0,),
                      )
                          : Container(
                        height: MediaQuery.of(context).size.height-240,
                        child: Column(children: [
                          Container(
                            // padding: EdgeInsets.only(top: 5),
                              height: 50,
                              child: DefaultTabController(
                                length: baraa.length,
                                child: Container(
                                  constraints: BoxConstraints(maxHeight: 35.0),
                                  child: Material(
                                    child: TabBar(
                                      onTap: (index) =>
                                          _scrollController.move(index),
                                      controller: tabController,
                                      isScrollable: true,
                                      indicatorColor:
                                      Color.fromRGBO(0, 202, 157, 1),
                                      labelColor: Colors.white,
                                      labelStyle: TextStyle(fontSize: 12),
                                      unselectedLabelColor: Colors.white,
                                      tabs: List<Widget>.generate(baraa.length,
                                              (int index) {
                                            return Tab(text: baraa[index]);
                                          }),
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: List.generate(
                                baraa.length,
                                    (index) {
                                  return FoodDishes(
                                    id_res: widget.id,
                                    id_res_section: id_res_section[index],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
