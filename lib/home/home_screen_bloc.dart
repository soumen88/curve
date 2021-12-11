import 'package:curve/board/board_status.dart';
import 'package:curve/board/boardstate.dart';
import 'package:curve/board/directions.dart';
import 'package:curve/constants.dart';
import 'package:curve/home/coordinate.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends ChangeNotifier{
  String TAG = "HomeScreenBloc";
  int rows = 0;
  int columns = 0;
  bool isGridCreated = false;
  String _pawn = "pawn";
  String get getPawnName => _pawn;
  late BoardStatus boardStatusState;
  late Coordinate playerCurrentCoordinates;
  late Directions currentDirection;
  BehaviorSubject<bool> willAcceptStream = new BehaviorSubject<bool>();

  HomeScreenBloc(){
    createGrid(gridRows, gridColumns);
  }

  //Draw the chess board on screen
  void createGrid(int x, int y){
    try {
      List<List<BoardState>> prepareGameGridState = [];
      rows = x;
      columns = y;
      for(int i = 0 ; i < x; i++){
        List<BoardState> inner = [];
        if(i % 2 == 0){
          for(int j = 0 ; j < x; j++){
            if(j % 2 == 0){
              inner.insert(j,BoardState.WHITE);
              //inner.insert(j,BoardState.PAWN_LOCATION);
            }
            else{
              inner.insert(j,BoardState.BLACK);
            }

          }
        }
        else{
          for(int j = 0 ; j < x; j++){
            if(j % 2 == 0){
              inner.insert(j,BoardState.BLACK);
            }
            else{
              inner.insert(j,BoardState.WHITE);
            }

          }
        }

        prepareGameGridState.insert(i, inner);
      }
      boardStatusState = new BoardStatus(prepareGameGridState);
      isGridCreated = true;
      notifyListeners();
    } catch (e) {
      developer.log(TAG , name :'Printing out the message: $e');
    }
  }

  //record position for pawn
  void updateGrid(int rowId, int columnId){
    List<List<BoardState>> boardGridState = boardStatusState.currentBoardState;
    List<BoardState> columnBoardState = boardGridState[rowId];
    columnBoardState.removeAt(columnId);
    columnBoardState.insert(columnId, BoardState.PAWN_LOCATION);
    boardGridState.removeAt(rowId);
    boardGridState.insert(rowId, columnBoardState);
    developer.log(TAG, name: "Picked board state as $rowId and $columnId");
    boardStatusState = new BoardStatus(boardGridState);
    playerCurrentCoordinates = new Coordinate(rowId, columnId);
    currentDirection = Directions.NORTH;
    notifyListeners();
  }

  void traverseGrid(int currentAngle ){
    int rowId = playerCurrentCoordinates.xPosition;
    int columnId = playerCurrentCoordinates.yPosition;
    bool isRowChange = false;
    bool isColumnChange = false;

    if(currentAngle == 0){
      currentDirection = Directions.NORTH;
      columnId++;
    }
    else if(currentAngle == -90 || currentAngle == 270){
      currentDirection = Directions.EAST;
      rowId--;
    }
    else if(currentAngle == 90 || currentAngle == -270){
      currentDirection = Directions.WEST;
      rowId++;
    }
    else if(currentAngle == 180 || currentAngle == -180){
      currentDirection = Directions.SOUTH;
      columnId--;
    }

    if(currentDirection == Directions.SOUTH || currentDirection == Directions.NORTH){
      isColumnChange = true;
    }
    else{
      isRowChange = true;
    }

    List<List<BoardState>> boardGridState = boardStatusState.currentBoardState;
    List<BoardState> columnBoardState = boardGridState[rowId];
    columnBoardState.removeAt(columnId);
    columnBoardState.insert(columnId, BoardState.PAWN_LOCATION);
    boardGridState.removeAt(rowId);
    boardGridState.insert(rowId, columnBoardState);
    developer.log(TAG, name: "Picked board state as $rowId and $columnId");
    boardStatusState = new BoardStatus(boardGridState);
    playerCurrentCoordinates = new Coordinate(rowId, columnId);
    notifyListeners();

  }

}