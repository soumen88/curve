import 'package:flutter_riverpod/flutter_riverpod.dart';

//State notifier for pawn rotate movements
class PawnMovementsBloc extends StateNotifier<AsyncValue<int?>>{
  int currentAngle = 0;

  PawnMovementsBloc() : super(AsyncData(null)){
    startingAngle();
  }


  void startingAngle(){
    currentAngle = 0;
    state = AsyncData(currentAngle);
  }

  void rotateLeft(){
    currentAngle = currentAngle - 90;
    if(currentAngle == 360 || currentAngle == -360){
      currentAngle = 0;
    }
    state = AsyncData(currentAngle);
  }

  void rotateRight(){
    currentAngle = currentAngle + 90;
    if(currentAngle == 360 || currentAngle == -360){
      currentAngle = 0;
    }
    state = AsyncData(currentAngle);
  }

}