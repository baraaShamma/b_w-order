import 'dart:convert';
import 'package:b_w/component/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  Auth() {}
  GlobalKey<FormState> formstate_singin = GlobalKey<FormState>();
  GlobalKey<FormState> formstate_singup = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController emailController_singup = TextEditingController();
  TextEditingController passwordController_singup = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phon = TextEditingController();
  bool email = false;
  bool password = false;
  bool emailVerified = false;

  showdialoading(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Row(
                children: const [
                  Text("Loading.."),
                  CircularProgressIndicator(),
                ],
              ));
        });
  }

  savePref(String id, String username, String email, String phon_user,
      String latitude, String longitude, String ty) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("id", id);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("phon_user", phon_user);
    preferences.setString("latitude", latitude);
    preferences.setString("longitude", longitude);
    preferences.setString("ty", ty);
  }

  var id;
  var usernamee;
  var address_user;
  var phon_user;
  var ty;
  bool admin = false;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id");
    usernamee = preferences.getString("username");
    address_user = preferences.getString("address_user");
    phon_user = preferences.getString("phon_user");
    ty = preferences.getString("ty");
    if (ty == "user") {
      admin = false;
    } else if (ty == "admin") {
      admin = true;
    }
  }

  showdialogall(context, String mytitle, String mycontent) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(mytitle),
            content: Text(mycontent),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("تم"))
            ],
          );
        });
  }

  Future signInWithEmailAndPassword(context) async {
    var formdata = formstate_singin.currentState!;
    if (formdata.validate()) {
      formdata.save();
      showdialoading(context);
      var data = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var url = Uri.parse("http://192.168.15.40:8080/B_W/login.php");
      var response = await http.post(url, body: data);
      var respnsebody = jsonDecode(response.body);
      if (respnsebody['status'] == 'success') {
        if (respnsebody['ty'] == "admin" || respnsebody['ty'] == "user") {
          savePref(
              respnsebody['id'],
              respnsebody['username'],
              respnsebody['email'],
              respnsebody['phon_user'],
              respnsebody['latitude'],
              respnsebody['longitude'],
              respnsebody['ty'],
              );
          print(respnsebody['id']);
          await getPref();
          Navigator.pushNamedAndRemoveUntil(context, "Home", (_) => false);
        }
      } else {
        print("login falid");
        Navigator.of(context).pop();
        showdialogall(context, "خطأ", "البريد الالكتروني او كلمة المرور خاطئة");
      }
    }
  }

  bool first_emailVerified = false;
  bool email_available = false;
  bool weak_password = false;
  late Position cl;

  Future<Position> getLatAndLong() async {
    return await Geolocator.getCurrentPosition().then((value) => value);
  }

  Future signUpWithEmailAndPassword(context) async {
    var formdata = formstate_singup.currentState!;
    cl = await getLatAndLong();

    if (formdata.validate()) {
      formdata.save();
      showdialoading(context);
      var data = {
        'username': username.text,
        "email": emailController_singup.text,
        "password": passwordController_singup.text,
        "phon_user": phon.text,
        "latitude": cl.latitude.toString(),
        "longitude": cl.longitude.toString()
      };

      var url = Uri.parse("http://192.168.15.40:8080/B_W/signup.php");
      var response = await http.post(url, body: data);
      var respnsebody = jsonDecode(response.body);
      if (respnsebody['status'] == 'success') {
        Navigator.pushNamedAndRemoveUntil(
            context, "SignInScreen", (_) => false);
        print("yess");
      } else {
        Navigator.of(context).pop();
        showdialogall(context, "خطأ", "البريد الالكتروني موجود سابقا");
      }
    } else {
      print("no");
    }
  }
/*
  Future  signUpWithEmailAndPassword(context) async {
    var formdata = formstate_singup.currentState!;
    showdialoading(context);
    cl = await getLatAndLong();
    if (formdata.validate()) {
      formdata.save();

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController_singup.text,
            password: passwordController_singup.text);
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          print("*******");
          await user.sendEmailVerification();
          print("-----------");
          var data = {
            'username': username.text,
            "email": emailController_singup.text,
            "password": passwordController_singup.text,
            "phon_user": phon.text,
            "latitude": cl.latitude.toString(),
            "longitude": cl.longitude.toString()
          };
          print("0000000000000000000");

          var url = Uri.parse("http://192.168.15.40:8080/B_W/signup.php");
          print("444444444444444444");

          var response = await http.post(url, body: data);
          print("*******");

          var respnsebody = jsonDecode(response.body);
          print("/////////////////////");

          if (respnsebody['status'] == 'success') {
            Navigator.pushNamedAndRemoveUntil(
                context, "SignInScreen", (_) => false);
            print("yess");
          } else {
            Navigator.of(context).pop();
            showdialogall(context, "خطأ", "البريد الالكتروني موجود سابقا");
          }
          first_emailVerified = true;
          email_available = false;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          email_available = false;
          weak_password = true;
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          weak_password = false;
          email_available = true;
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }*/
}
