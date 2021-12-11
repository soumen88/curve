import 'package:curve/board/boardstate.dart';
import 'package:curve/components/custom_button.dart';
import 'package:curve/components/navbar.dart';
import 'package:curve/constants.dart';
import 'package:curve/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'dart:developer' as developer;

class HomeScreenPage extends HookWidget{
  List<List<BoardState>> gridState = [];
  String TAG = "HomeScreenPage";
  bool _isPawnDropped = false;
  String _pawn = 'pawn';
  bool _isDragInProgress = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (builder, watch, child){
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
                      Consumer(
                          builder : (builder, watch, child){
                            final currentState = watch(homeScreenProvider).boardStatusState;
                            if(currentState != null){
                              gridState.clear();
                              gridState = List.from(currentState.currentBoardState);
                              developer.log(TAG , name: "Grid size "+ gridState.length.toString());
                            }
                            if(gridState.isNotEmpty){
                              return _buildGameBody(gridState);
                            }
                            else{
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(child: CircularProgressIndicator())
                              );
                            }
                          }
                      ),
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
                          );
                        }
                      ),
                      //Drag target container
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

  Widget _buildGameBody(List<List<BoardState>> gridState) {
    int gridStateLength = gridState.length;
    return Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0)
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridStateLength,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                ),
                itemBuilder: (context, index) => _buildGridItems(context, index, gridStateLength),
                itemCount: gridStateLength * gridStateLength,
              ),
            ),
          ),
        ]);
  }

  Widget _buildGridItems(BuildContext context, int index, int gridStateLength) {
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () {

        BoardState bookingState = getCurrentBoardState(x,y);
        switch(bookingState){
          case BoardState.WHITE:{

          }
          break;
          case BoardState.BLACK:{

          }
          break;

        }
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)
          ),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    switch (gridState[x][y]) {
      case BoardState.BLACK:
        return Container(
          color: Colors.black45,
        );
        break;
      case BoardState.WHITE:
        return Container(
          color: Colors.white60,
          //child: Text(gridState[x][y].toString()),
        );
        break;
      default:
        return Text(gridState[x][y].toString());
    }
  }


  BoardState getCurrentBoardState(int x, int y){
    return gridState[x][y];
  }
}