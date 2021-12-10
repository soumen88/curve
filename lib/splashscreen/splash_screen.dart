import 'dart:async';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'dart:developer' as developer;

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}
class SplashScreenState extends State<SplashScreenPage>{

  String currentScreen = "SplashScreenState";
  bool isTimerExpired = false;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (builder, watch, child){
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        width: 300.0,
                        height: 500.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/curve_logo.png",
                                )
                            )
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }



  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //context.read(durationProvider.notifier).startTimer();
      Timer(Duration(seconds: 1), () {
        //developer.log(currentScreen, name : "Timer expired");
        startLoginScreen();
      });
    });

  }

  void startLoginScreen(){
    //context.router.replace(LoginScreenRoute());
    //context.router.replace(FamilyDetailsScreenRoute());
  }
}
