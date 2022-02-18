
import 'package:b_w/contoller/auth.dart';
import 'package:b_w/widgets/textfiled.dart';
import 'package:flutter/material.dart';



import '../../utils/constants.dart';


class Singin extends StatefulWidget {
  @override
  _SinginState createState() => _SinginState();
}

class _SinginState extends State<Singin> {
  Auth auth=new Auth();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: auth.formstate_singin,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
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
                          control: auth.emailController,
                          hintText: "Email",
                          max_value: 50,
                          min_value: 10,
                          message_max_value: "الايميل المدخل اكبر من 50 حرف",
                          message_min_value: "الايميل المدخل اقل من 10 حرف",
                        ))
                  ],
                ),
              ),
              Row(
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
                        control: auth.passwordController,
                        hintText: "Password",
                        max_value: 20,
                        min_value: 6,
                        message_max_value: "كلمة المرور المدخل اكبر من 20 حرف",
                        message_min_value: "كلمة المرور المدخل اقل من 6 حرف",
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () async {
                          //var user = await controller.signIn();
                          auth.signInWithEmailAndPassword(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                          ),
                          child: const Icon(
                            Icons.login,
                            color: Colors.black,
                          ),
                        ),
                      ))
                ],
              ),
              Container(
                  alignment: Alignment.center,
                  child: auth.emailVerified
                      ? const Text("يرجى تأكيد البريد الالكتروني اولا")
                      :
                  //هون رح يكون الذهاب الى الصفحة الرئيسية
                  const SizedBox(
                    height: 0,
                  )),
              Container(
                  alignment: Alignment.center,
                  child: auth.email
                      ? const Text("البريد الالكتروني غير موجود")
                      : const SizedBox(
                    height: 0,
                  )),
              Container(
                  alignment: Alignment.center,
                  child: auth.password
                      ? const Text("كلمة المرور غير صحيحة")
                      : const SizedBox(
                    height: 0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
