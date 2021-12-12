import 'package:curve/board/boardstate.dart';
import 'package:curve/board/motion_button_categories.dart';
import 'package:curve/components/custom_button.dart';
import 'package:curve/components/navbar.dart';
import 'package:curve/constants.dart';
import 'package:curve/grid/grid_screen.dart';
import 'package:curve/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'dart:developer' as developer;

class HomeScreenPage extends HookWidget{

  String TAG = "HomeScreenPage";
  //Identify if pawn was dropped on chess board
  bool _isPawnDropped = false;
  late String _pawn;
  int currentAngle = 0;
  bool _isTwoMoveStepsComplete = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (builder, watch, child){
        _pawn = watch(homeScreenProvider).getPawnName;
        final pawnAngle = watch(pawnAngleProvider);
        final streamValue = watch(homeScreenProvider).willAcceptStream;
        final currentDirection = watch(homeScreenProvider).currentDirection;
        _isTwoMoveStepsComplete = watch(homeScreenProvider).isTwoMovesComplete;

        streamValue.listen((value) {
          developer.log(TAG, name:" Stream value has changed "+ value.toString());
          _isPawnDropped = value;
        });

        if(streamValue.hasListener && streamValue.hasValue){
          developer.log(TAG, name:" Stream value has changed "+ streamValue.value.toString());
        }

        return Scaffold(
          appBar: NavBar(
            isIconVisible: false,
            screenName: "Pawn Simulator",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Center(
              child: SafeArea(
                child: Column(
                    children: [
                      StreamBuilder(
                          stream: context.read(homeScreenProvider).willAcceptStream,
                          builder:  (context, snapshot){
                            if(snapshot.data != null && snapshot.hasData && snapshot.data! == true && currentDirection != null){

                              return pawnAngle.when(
                                  data: (data) {
                                    final currentCoordinates = watch(homeScreenProvider).playerCurrentCoordinates;
                                    currentAngle = data!;
                                    return Column(
                                      children: [
                                        if(data != null)
                                        Container(
                                          height: 155.0,
                                          width: 155.0,
                                          child:
                                          RotationTransition(
                                            turns: new AlwaysStoppedAnimation( data / 360),
                                            child: Image.asset(unSelectedPawnPath),
                                          ),
                                        ),
                                        if(currentDirection != null)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("$currentDirection,"),
                                            Text("x = ${currentCoordinates.xPosition},"),
                                            Text("y = ${currentCoordinates.yPosition}, "),
                                            Visibility(
                                                visible: currentCoordinates.isOnEdge,
                                                child: Text("Pawn is at edge of board"),
                                            )
                                          ],
                                        )

                                      ],
                                    );
                                  },
                                  loading: (){
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                        child: Center(child: CircularProgressIndicator())
                                    );
                                  },
                                  error:(e, st) => Text("Something went wrong")
                              );
                            }
                            else{
                              return Text("Game Moves will be displayed here");
                            }

                          }
                      ),
                      //Prepare chess Grid in UI
                      GridScreen(),

                      StreamBuilder(
                        initialData: false,
                        stream: context.read(homeScreenProvider).willAcceptStream,
                        builder: (context, snapshot) {
                          return Visibility(
                            key: Key("1"),
                            visible: !_isPawnDropped,
                            child: Draggable<String>(
                              // Data is the value this Draggable stores.
                              data: _pawn,
                              //This will be the original image of the pawn
                              child: Container(
                                height: 55.0,
                                width: 55.0,
                                child: Center(
                                  child: Image.asset(unSelectedPawnPath),
                                ),
                              ),
                              //This will be the image that would be getting displayed when the pawn is dragged
                              feedback: Container(
                                height: 55.0,
                                width: 55.0,
                                child: Center(
                                  child: Image.asset(selectedPawnPath),
                                ),
                              ),
                              //
                              childWhenDragging: Container(),
                              onDragCompleted: (){
                                developer.log(TAG , name: "On drag completed");
                                context.read(homeScreenProvider).willAcceptStream.add(true);
                              },
                              onDraggableCanceled: (velocity, offset){
                                developer.log(TAG , name: "On drag cancelled");
                                context.read(homeScreenProvider).willAcceptStream.add(false);
                              },

                            ),
                          );
                        }
                      ),

                      StreamBuilder(
                          stream: context.read(homeScreenProvider).willAcceptStream,
                          builder:  (context, snapshot) {
                            if(snapshot.data != null && snapshot.hasData && snapshot.data! == true){
                              return  Column(
                                children: [
                                  MotionButtonCategories(
                                    onmotionSelected: (data){
                                      developer.log(TAG, name: "Selection motion id $data");
                                      // 0 for left, 1 for right, 2 for move and 3 for move 2 places
                                      switch(data){
                                        case 0:{

                                          context.read(pawnAngleProvider.notifier).rotateLeft();
                                          int tempAngle = currentAngle - 90;
                                          developer.log(TAG, name:"Left button was tapped with temp angle $tempAngle");
                                          context.read(homeScreenProvider).updateDirection(tempAngle);
                                        }
                                        break;
                                        case 1:{
                                          developer.log(TAG, name:"Right button was tapped");
                                          context.read(pawnAngleProvider.notifier).rotateRight();
                                          int tempAngle = currentAngle + 90;
                                          context.read(homeScreenProvider).updateDirection(tempAngle);
                                        }
                                        break;
                                        case 2:{
                                          developer.log(TAG, name:"Move button was tapped");
                                          context.read(homeScreenProvider).traverseGrid(currentAngle);
                                        }
                                        break;
                                        case 3:{
                                          developer.log(TAG, name:"move 2 steps button was tapped");
                                          context.read(homeScreenProvider).traverseGridWithTwoMoves(currentAngle);
                                        }
                                        break;
                                        default:
                                          break;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: kDefaultPadding,
                                  ),
                                  CustomButton(
                                      tap: (){
                                        developer.log(TAG, name:"Restart button was tapped");
                                        context.read(homeScreenProvider).init();
                                        context.read(homeScreenProvider).willAcceptStream.add(false);
                                        context.read(homeScreenProvider).createGrid(gridRows, gridColumns);
                                        context.read(pawnAngleProvider.notifier).startingAngle();
                                      },
                                      buttonText: "Restart"
                                  ),
                                ],
                              );
                            }
                            else{
                              return Text("Move the Pawn To the grid");
                            }
                          }
                      )
                    ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}