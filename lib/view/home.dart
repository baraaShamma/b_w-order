import 'package:b_w/component/mydrawer.dart';
import 'package:b_w/contoller/auth.dart';
import 'package:b_w/contoller/getdata.dart';
import 'package:b_w/view/restaurant/restaurant_sections.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Auth getPref = new Auth();
  GetData getData = new GetData();


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("B_W Order"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.remove("id");
                  preferences.remove("username");
                  preferences.remove("email");
                  preferences.remove("phon_user");
                  preferences.remove("latitude");
                  preferences.remove("longitude");
                  preferences.remove("ty");
                  preferences.remove("balance");
                  Navigator.pushNamedAndRemoveUntil(
                      context, "SignInScreen", (_) => false);
                },
              )
            ],
          ),
          drawer: MyDrawer(),
          body: ListView(
            children:[
              Container(

                constraints: BoxConstraints.expand(height: 225),
                child: FutureBuilder(
                    future: getData.getdata("admin/advertisements"),
                    builder:(context,AsyncSnapshot snapshot)
                    {
                      if(snapshot.hasError)print(snapshot.error);
                      return snapshot.hasData?
                      Swiper(
                          autoplay: true,
                          itemCount: snapshot.data.length,
                          itemBuilder:(context,index){
                            List list=snapshot.data;
                            return Image.network(
                              "http://192.168.15.40:8080/B_W/upload/advertisements/${list[index]['image_adv']}",
                              fit: BoxFit.fitWidth,);
                          }
                      )
                          :
                      Center(child: CircularProgressIndicator(),);
                    }
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: Text("Restaurants VIP",style: TextStyle(fontSize: 20),),
              ),
              Container(
                //color: Colors.red.shade100,

                height: 500,
                // margin: EdgeInsets.all( 10),
                child:  FutureBuilder(

                    future: getData.getdata("restaurants/restaurants"),
                    builder:(context,AsyncSnapshot snapshot)
                    {
                      if(snapshot.hasError)print(snapshot.error);
                      return snapshot.hasData? GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,mainAxisExtent: 200),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index)
                          {
                            List list=snapshot.data;
                            return list[index]['vip']=="1"?
                              Container(
                                //height: 200,
                                child:  InkWell(
                                    child: Card(
                                      margin: EdgeInsets.all(5),
                                      color: Colors.blueGrey.shade100,
                                      shadowColor: Colors.pink,
                                      borderOnForeground: true,
                                      semanticContainer: false,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 3,
                                              child: Image.network(
                                                "http://192.168.15.40:8080/B_W/upload/qrestaurants/${list[index]['image_restaurant']}",
                                                fit: BoxFit.cover,)),
                                         Expanded(
                                           flex: 1,
                                           child:  Container(
                                             child: Text( list[index]['username'],
                                               style: TextStyle(fontSize: 17, color: Colors.black87,),textAlign:TextAlign.center,
                                             )),)
                                          //end categories1
                                          //start categories2
                                        ],
                                      ),
                                    ),
                                    onTap: () {  Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) {
                                      return RestaurantSections(
                                        id: list[index]['id_restaurant'],
                                        image: list[index]['image'],
                                        beginning_work: list[index]['beginning_work'],
                                        finished_work: list[index]['finished_work'],
                                        image_restaurant: list[index]['image_restaurant'],
                                        username: list[index]['username'],
                                      );
                                    }));}
                                ),
                              ):SizedBox(height: 0,);
                          }

                      ):
                      Center(child: CircularProgressIndicator(),);
                    }

                ),

              )
           ]
          )
        ));
  }
}
