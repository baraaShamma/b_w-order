import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
showdialogall(context) {
  return   AwesomeDialog(
      context: context,
      title: "services",
      body: Text("Services not enabled"))
      .show();
}

Future getPirmission(context) async {
  bool services;
  LocationPermission per;

  //رح ترجع ازا خدمة الموقع بالموبايل اذا كانت شغالة او لا
  services = await Geolocator.isLocationServiceEnabled();
  if (services == false) {
    showdialogall(context);
  }
  per = await Geolocator.checkPermission();
  if (per == LocationPermission.denied) {
    per == await Geolocator.requestPermission();
  }
  return per;
}
