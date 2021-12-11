import 'package:curve/board/boardstate.dart';
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

  bool _isDragInProgress = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (builder, watch, child){
        _pawn = watch(homeScreenProvider).getPawnName;

        final streamValue = watch(homeScreenProvider).willAcceptStream;
        streamValue.listen((value) {
          developer.log(TAG, name:" Stream value has changed "+ value.toString());
          _isDragInProgress = value;
        });

        if(streamValue.hasListener && streamValue.hasValue){
          developer.log(TAG, name:" Stream value has changed "+ streamValue.value.toString());
        }
        return Scaffold(
          appBar: NavBar(
            isIconVisible: false,
            screenName: "Home Screen",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Center(
              child: SafeArea(
                child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                              tap: (){
                                developer.log(TAG, name:"Left button was tapped");
                              },
                              buttonText: "Left"
                          ),
                          CustomButton(
                              tap: (){
                                developer.log(TAG, name:"Right button was tapped");
                              },
                              buttonText: "Right"
                          ),
                        ],
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

                      /*Visibility(
                        key: Key("1"),
                        visible: !_isPawnDropped,
                        child: Draggable<String>(
                          // Data is the value this Draggable stores.
                          //data: _pawn,
                          //This will be the original image of the pawn
                          child: Container(
                              height: 165.0,
                              width: 165.0,
                              child: Center(
                                child: Image.asset(unSelectedPawnPath),
                              ),
                          ),
                          //This will be the image that would be getting displayed when the pawn is dragged
                          feedback: Container(
                              height: 165.0,
                              width: 165.0,
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
                      ),*/

                      //Drag target container
                      StreamBuilder(
                          initialData: false,
                          stream: context.read(homeScreenProvider).willAcceptStream,
                          builder: (context, snapshot) {
                            return Container(
                              key: Key("2"),
                              height: 314,
                              width: 315,
                              color: (snapshot.data != null && snapshot.hasData && snapshot.data! == true)   ? Colors.green : Colors.blue,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: DragTarget<String>(
                                        builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
                                          return Container(
                                            height: 160,
                                            width: 200,
                                            child: Image.asset(_isPawnDropped
                                                ? unSelectedPawnPath
                                                : 'assets/bo.png'),
                                          );
                                        },
                                        onWillAccept: (data) {
                                          return data == _pawn;
                                        },
                                        onAccept: (data) {
                                          developer.log(TAG , name: "Data $data");
                                          _isPawnDropped = true;
                                        },
                                        hitTestBehavior: HitTestBehavior.deferToChild
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                      ),
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