import 'package:curve/board/boardstate.dart';
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer(
      builder: (builder, watch, child){
        return Scaffold(
          appBar: NavBar(
            isIconVisible: false,
            screenName: "Home Screen",
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Center(
              child: SafeArea(
                child: Consumer(
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