import 'package:curve/constants.dart';
import 'package:curve/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as developer;

class MotionButtonCategories extends HookWidget{
  int selectedIndex = 0;
  String TAG = "MotionButtonCategories";
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (builder, watch, child){
        final isTwoMoveStepsComplete = watch(homeScreenProvider).isTwoMovesComplete;
        final motionButtonCategories = watch(homeScreenProvider).motionButtonCategories;
        if(isTwoMoveStepsComplete){
          developer.log(TAG, name: "Now remove");

        }
        return Padding(
          padding: EdgeInsets.only(top: kDefaultPadding),
          child: SizedBox(
            height: 35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: motionButtonCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Visibility(
                      visible: motionButtonCategories[index].isVisible!,
                      child: GestureDetector(
                        onTap: () {
                          this.selectedIndex = index;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kOrangeColor,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2.8),
                          margin: EdgeInsets.only(right: kDefaultPadding * 0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(motionButtonCategories[index].icon!),

                              SizedBox(width: 5),

                              Text(
                                motionButtonCategories[index].name!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.w300
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  );
                }
            ),
          ),
        );
      }
    );
  }

}