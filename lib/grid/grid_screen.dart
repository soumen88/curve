import 'package:curve/board/boardstate.dart';
import 'package:curve/constants.dart';
import 'package:curve/home/coordinate.dart';
import 'package:curve/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

//Creating and maintaining state of grid
class GridScreen extends HookWidget{
  List<List<BoardState>> gridState = [];
  int gridStateLength = 0;
  String TAG = "GridScreen";
  late String _pawn;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (builder, watch, child){
        final currentState = watch(homeScreenProvider).boardStatusState;
        _pawn = watch(homeScreenProvider).getPawnName;

        if(currentState != null){
          gridState.clear();
          gridState = List.from(currentState.currentBoardState);
          developer.log(TAG , name: "Grid size "+ gridState.length.toString());
          gridStateLength = gridState.length;
        }

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
                      crossAxisCount: gridState.length,
                      mainAxisSpacing: kDefaultPadding,
                      crossAxisSpacing: kDefaultPadding,
                    ),
                    itemBuilder: (context, index) => _buildGridItems(context, index, gridStateLength),
                    itemCount: gridStateLength * gridStateLength,
                  ),
                ),
              ),
            ]
        );
      },
    );
  }

  Widget _buildGridItems(BuildContext context, int index, int gridStateLength) {
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () {
        //Tap detection on the grid item
        BoardState boardState = getCurrentBoardState(x,y);
        switch(boardState){
          case BoardState.WHITE:{

          }
          break;
          case BoardState.BLACK:{

          }
          break;
          case BoardState.PAWN_LOCATION:{

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
            child: _buildGridItem(x, y, context),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y, BuildContext context) {
    switch (gridState[x][y]) {
      case BoardState.BLACK:
        return DragTarget<String>(
            builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
              return Container(
                color: kCurveBoardBlack,
              );
            },
            onWillAccept: (data) {
              return data == _pawn;
            },
            onAccept: (data) {
              developer.log(TAG , name: "Data $data with $x and $y");
              context.read(homeScreenProvider).updateGrid(x, y);
            },
            hitTestBehavior: HitTestBehavior.deferToChild
        );
        break;
      case BoardState.WHITE:
        return DragTarget<String>(
            builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
              return Container(
                color: kCurveBoardWhite,
              );
            },
            onWillAccept: (data) {
              return data == _pawn;
            },
            onAccept: (data) {
              developer.log(TAG , name: "Data $data with $x and $y");
              context.read(homeScreenProvider).updateGrid(x, y);
            },
            hitTestBehavior: HitTestBehavior.deferToChild
        );
        break;
      case BoardState.PAWN_LOCATION:{
        return Consumer(
          builder: (builder, watch, child){
            final pawnAngle = watch(pawnAngleProvider);
            return pawnAngle.when(
                data: (data) {
                  return Container(
                    height: 155.0,
                    width: 155.0,
                    decoration: BoxDecoration(
                      color: Colors.white60 ,
                    ),
                    child: RotationTransition(
                      turns: new AlwaysStoppedAnimation( data! / 360),
                      child: Image.asset(unSelectedPawnPath),
                    ),
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
          },
        );
      }
      break;
      default:
        return Text(gridState[x][y].toString());
    }
  }

  BoardState getCurrentBoardState(int x, int y){
    return gridState[x][y];
  }
}