import 'package:curve/board/buttons.dart';
import 'package:flutter/cupertino.dart';

mixin MotionButtonBloc on ChangeNotifier{

  late List<MotionButton> motionButtonCategories;

  void addAllButtons(){
    motionButtonCategories = [
      MotionButton(
          id: 1,
          name: 'Left',
          icon: 'assets/left_arrow.svg',
          isVisible : true
      ),
      MotionButton(
          id: 2,
          name: 'Right',
          icon: 'assets/right_arrow.svg',
          isVisible : true
      ),
      MotionButton(
          id: 3,
          name: 'Move',
          icon: 'assets/move.svg',
          isVisible : true
      ),
      MotionButton(
          id: 4,
          name: 'Move 2 Steps',
          icon: 'assets/chat.svg',
          isVisible : true
      )
    ];
    notifyListeners();
  }

  void addOrRemoveMoveTwoStep(bool isRemove){
    if(isRemove){
      motionButtonCategories.removeAt(3);
      notifyListeners();
    }
    else{
      var motionButton = MotionButton(
          id: 4,
          name: 'Move 2 Steps',
          icon: 'assets/chat.svg',
          isVisible : true
      );
      motionButtonCategories.insert(3, motionButton);
    }
  }
}