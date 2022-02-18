import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Baraa extends ChangeNotifier {
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(1, 1),
    zoom: 17.4746,
  );
  late Position cl;
  GoogleMapController? gmc;
  Set<Marker> mymarker = {};

  Future<void> getLatAndLong(lat, long) async {
    kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 17.4746,
    );
    mymarker.clear();
    mymarker.add(
      Marker(markerId: MarkerId("1"), position: LatLng(lat, long)),
    );
    gmc!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    notifyListeners();
  }

  var latb;
  var longb;
  late double latitude;

  late double longitude;

  late bool ff;
  var id_user;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id_user = preferences.getString("id");
    print(id_user);
    fetch_lat_long();
    starttimer();
    // notifyListeners();
  }

  Future fetch_lat_long() async {
    try {
      print("bartaaaaaaa" + id_user);
      var url = Uri.parse(
          "http://192.168.15.40:8080/B_W/delivery/fetch_lat_long.php");
      var data = {"id": id_user};
      var response = await http.post(url, body: data);
      var responsebody = jsonDecode(response.body);
      print(responsebody[0]["latitude"]);
      latb = responsebody[0]["latitude"];
      print(responsebody[0]["longitude"]);
      longb = responsebody[0]["longitude"];
      latitude = double.parse(latb);
      longitude = double.parse(longb);
      kGooglePlex = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17.4746,
      );
      notifyListeners();

      return responsebody;
    } catch (e) {}
  }

  baraa() async {
    try {
      mymarker.clear();
      mymarker.add(
        Marker(markerId: MarkerId("1"), position: LatLng(latitude, longitude)),
      );
      await gmc!
          .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    } catch (e) {}
  }

  late Timer timer1;
  late Timer timer2;

  bool startenable = true;
  bool stopenable = false;

  void starttimer() {
    startenable = false;
    stopenable = true;

    timer1 = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => fetch_lat_long());
    timer2 = Timer.periodic(Duration(seconds: 5), (Timer t) => baraa());

    notifyListeners();
  }

  void stoptimer() {
    if (startenable == false) {
      startenable = true;
      stopenable = false;
      timer1.cancel();
      timer2.cancel();
    }
    notifyListeners();
  }

  Baraa() {
    getPref();
  }

  WillPopScope() {}

  @override
  void dispose() {
    print("wwwwqqqqqqqqqqqqq");
    stoptimer();
    timer1.cancel();
    timer2.cancel();

    super.dispose();
  }
}
