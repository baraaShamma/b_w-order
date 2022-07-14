import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:b_w/contoller/update_location_del.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ViewLocationdelivery extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return  ChangeNotifierProvider(
     create: (context) {
       return UpdateLocationDel();
     },
     child: Scaffold(body: Consumer<UpdateLocationDel>(
       builder: (context, provone, child) {
         return Container(
           height: MediaQuery.of(context).size.height-50,
           width: 400,
           child: GoogleMap(
             markers: provone.mymarker,
             mapType: MapType.hybrid,
             initialCameraPosition: provone.kGooglePlex,
             onMapCreated: (GoogleMapController controller) {
               provone.gmc = controller;
             },
           ),
         );
       },
     )),
   );
  }

}