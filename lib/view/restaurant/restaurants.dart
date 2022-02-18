import 'package:b_w/contoller/getdata.dart';
import 'package:b_w/view/restaurant/restaurant_sections.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'food_dishes.dart';

class Restaurants extends StatefulWidget {
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  GetData getData = new GetData();
  late List list_name = [];

  Future getdata2(String name) async {
    var url = Uri.parse("http://192.168.15.40:8080/B_W/$name.php");
    var response = await http.get(url);
    var responsebody = jsonDecode(response.body);
    for (int i = 0; i < responsebody.length; i++) {
      //   print(responsebody[i]["id_res_section"]);
      list_name.add(responsebody[i]["name"]);
    }

    // print (list_name);
    return list_name;
  }

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المطاعم "),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // height: 150,
        child: FutureBuilder(
            future: getData.getdata("restaurants/restaurants"),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,

                      // scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;

                        return
                            //start catgory
                            InkWell(
                          child: Container(
                            color: Colors.red.shade100,
                            height: 350,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Card(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.yellowAccent.shade100,
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                            offset: const Offset(1, 1))
                                      ],
                                      //      border: Border.all(width: 100, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                            "http://192.168.15.40:8080/B_W/upload/qrestaurants/${list[index]['image']}",
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      // alignment: Alignment.center,
                                      color: Colors.black26,
                                      //alignment: Alignment.topRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      "http://192.168.15.40:8080/B_W/upload/qrestaurants/${list[index]['image_restaurant']}",
                                                    ))),
                                          ),
                                          Text(
                                            list[index]['username'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "العنوان:  " +
                                                list[index]['address'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors
                                                    .yellowAccent.shade200),
                                            textAlign: TextAlign.center,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  list[index]
                                                          ['beginning_work'] +
                                                      " am",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.pink.shade100,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const Text(
                                                  " -->",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  list[index]['finished_work'] +
                                                      " pm",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.pink.shade100,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            print(ModalRoute.of(context)!.settings.name);

                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return RestaurantSections(
                                id: list[index]['id_restaurant'],
                                image: list[index]['image'],
                                beginning_work: list[index]['beginning_work'],
                                finished_work: list[index]['finished_work'],
                                image_restaurant: list[index]['image_restaurant'],
                                username: list[index]['username'],
                              );
                            }));
                          },
                        );
                      })
                  :  Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}
