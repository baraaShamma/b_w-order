import 'package:b_w/widgets/text.dart';
import 'package:flutter/material.dart';

import 'singup.dart';
import '../../utils/constants.dart';
import 'singin.dart';
class SignInScreen extends StatelessWidget {


  PageController pageController = PageController();

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/perosn.jpeg"),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 80.0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        width: 100,
                        height: 60,
                        child: InkWell(
                          onTap: () {
                            pageController.animateToPage(0,
                                duration:
                                const Duration(milliseconds: 500),
                                curve: Curves.decelerate);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kPrimaryColor,
                              ),
                              child: const Teext(
                                text: "تسجيل الدخول",
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      width: 100,
                      height: 60,
                      child: InkWell(
                        child: Container(
                            alignment: Alignment.center,
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kPrimaryColor,
                            ),
                            child: const Teext(
                              text: "حساب جديد ",
                              color: Colors.black,
                            )),
                        onTap: () {
                          pageController.animateToPage(1,
                              duration:
                              const Duration(milliseconds: 500),
                              curve: Curves.decelerate);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 450,
                child: PageView(
                  controller: pageController,
                  physics: const ClampingScrollPhysics(),
                  children: <Widget>[
                    ConstrainedBox(
                        constraints:const BoxConstraints.expand(),
                        child: Singin()),
                    ConstrainedBox(
                        constraints:const BoxConstraints.expand(),
                        child: Singup()),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
