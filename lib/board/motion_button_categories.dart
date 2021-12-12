import 'package:curve/board/buttons.dart';
import 'package:curve/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MotionButtonCategories extends HookWidget{
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: kDefaultPadding),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: motionButtonCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  this.selectedIndex = index;
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.8),
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
                            color: kGreyColor,
                            fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.w300
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );

  }

}