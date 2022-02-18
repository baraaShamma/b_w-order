
import 'package:b_w/view/my_balanc.dart';
import 'package:b_w/view/order/view_myorder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var id;
  var usernamee;
  var phon_user;
  var balance;
  var ty;


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id");
    usernamee = preferences.getString("username");
    phon_user = preferences.getString("phon_user");
    ty = preferences.getString("ty");
    balance = preferences.getString("balance");


    setState(() {});
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 250,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                image: const DecorationImage(
                    image: AssetImage("assets/b_w.png"), fit: BoxFit.fill)),
          ),
          ListTile(
            title: const Text(" المطاعم",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            leading: const Icon(Icons.restaurant,
                color: Colors.deepPurpleAccent, size: 25),
            onTap: () {

              Navigator.of(context).pushNamed('Restaurants');
            },
          ),
          ListTile(
                  title: const Text(" طلباتي",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  leading: const Icon(Icons.reorder_sharp,
                      color: Colors.deepPurpleAccent, size: 25),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MyOrders(
                        id_user: id,
                      );
                    }));
                  },
                ),

               ListTile(
                  title: const Text(" رصيدي",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  leading: const Icon(Icons.reorder_sharp,
                      color: Colors.deepPurpleAccent, size: 25),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MyBalance(
                        id_user: id,

                      );
                    }));
                  },
                ),
        ],
      ),
    );
  }
}
