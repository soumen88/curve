import 'dart:async';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:curve/routes/AppRouter.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:developer' as developer;

class SplashScreenPage extends HookWidget {

  String TAG = "SplashScreen";

  @override
  Widget build(BuildContext context) {
    //Start home screen whenever timer is over
    useEffect((){
      Timer(Duration(seconds: 1), () {
        context.router.replace(HomeScreenRoute());
      });
    });

    // Display Splash screen logo
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
  }

}
