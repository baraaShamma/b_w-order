import 'package:b_w/component/location.dart';
import 'package:b_w/contoller/auth.dart';
import 'package:b_w/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


import '../../utils/constants.dart';


class Singup extends StatefulWidget {
  @override
  _SingupState createState() => _SingupState();
}

class _SingupState extends State<Singup> {
  Auth auth=new Auth();
  late Position cl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: auth.formstate_singup,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.supervisor_account,
                            color: kPrimaryColor,
                          ),
                        ),
                        Expanded(
                            child: TextFiled(
                              control: auth.username,
                              hintText: "user name",
                              max_value: 20,
                              min_value: 3,
                              message_max_value:
                              "اسم المستخدم لا يمكن ان يكون اكثر من 20 حرف",
                              message_min_value: " اسم المستخدم المدخل اقل من 3 حرف",
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.alternate_email,
                            color: kPrimaryColor,
                          ),
                        ),
                        Expanded(
                            child: TextFiled(
                              hintText: "Email",
                              max_value: 40,
                              min_value: 10,
                              message_max_value: "الايميل المدخل اكبر من 40 حرف",
                              message_min_value: "الايميل المدخل اقل من 10 حرف",
                              control: auth.emailController_singup,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                        ),
                        Expanded(
                            child: TextFiled(
                              control: auth.passwordController_singup,
                              hintText: "Password",
                              max_value: 20,
                              min_value: 6,
                              message_max_value: "كلمة المرور المدخل اكبر من 20 حرف",
                              message_min_value: "كلمة المرور المدخل اقل من 6 حرف",
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                        ),
                        Expanded(
                            child: TextFiled(
                              control: auth.phon,
                              hintText: "phon",
                              max_value: 20,
                              min_value: 10,
                              message_max_value: "رقم الهاتف المدخل اكبر من 20 حرف",
                              message_min_value: "رقم الهاتف  المدخل اقل من 10 حرف",
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                            onTap: () async {
                              //  var user = await controller.signup();
                              auth.signUpWithEmailAndPassword(context);

                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor,
                              ),
                              child: const Icon(
                                Icons.create,
                                color: Colors.black,
                              ),
                            ),
                          ))
                    ],
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: auth.first_emailVerified
                          ? const Text("تم ارسال رابط التفعيل يرجى التأكيد")
                          :
                      //هون رح يكون الذهاب الى الصفحة الرئيسية
                      const SizedBox(
                        height: 0,
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: auth.weak_password
                          ? const Text("كلمة المرور ضعيفة")
                          :
                      //هون رح يكون الذهاب الى الصفحة الرئيسية
                      const SizedBox(
                        height: 0,
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: auth.email_available
                          ? const Text("البريد الالكتروني موجود سابقا")
                          :
                      //هون رح يكون الذهاب الى الصفحة الرئيسية
                      const SizedBox(
                        height: 0,
                      )),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
