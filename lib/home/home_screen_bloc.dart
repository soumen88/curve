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
  Directions? currentDirection;
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
    int newRowId = playerCurrentCoordinates.xPosition;
    int columnId = playerCurrentCoordinates.yPosition;
    int newColumnId = playerCurrentCoordinates.yPosition;
    bool isRowChange = false;
    bool isColumnChange = false;
    List<List<BoardState>> boardGridState = boardStatusState.currentBoardState;
    if(currentAngle == 0){
      currentDirection = Directions.NORTH;
      newRowId = rowId - 1;
    }
    else if(currentAngle == -90 || currentAngle == 270){
      currentDirection = Directions.WEST;
      newColumnId = columnId - 1;
    }
    else if(currentAngle == 90 || currentAngle == -270){
      currentDirection = Directions.EAST;
      newColumnId = columnId + 1;
    }
    else if(currentAngle == 180 || currentAngle == -180){
      currentDirection = Directions.SOUTH;
      newRowId = rowId + 1;
    }

    if(currentDirection == Directions.SOUTH || currentDirection == Directions.NORTH){
      isColumnChange = true;
    }
    else{
      isRowChange = true;
    }



    //Keep the column data same
    if(isRowChange){
      //create temp variables which preserve old and new states of rows
      List<BoardState> currentBoardColumn = boardGridState[rowId];

      //find the index of pawn location in current row
      int index = currentBoardColumn.indexOf(BoardState.PAWN_LOCATION);
      //check if the pawn is on the edge of the board
      if((columnId == 0 && currentDirection == Directions.WEST) || (columnId == 7 && currentDirection == Directions.EAST)){
        developer.log(TAG, name: "Returning because pawn is at the edge of the board");
        playerCurrentCoordinates.isOnEdge = true;
        notifyListeners();
        return;
      }

      //Saving current board state
      BoardState newboardState = currentBoardColumn[newColumnId];
      BoardState updated = BoardState.BLACK;

      //Since in chess board black and white are placed alternatively if the current board state is
      // white then below that on the same index it would be white
      if(newboardState == BoardState.WHITE){
        updated = BoardState.BLACK;
      }
      else if(newboardState == BoardState.BLACK){
        updated = BoardState.WHITE;
      }

      //replace the index with updated one
      currentBoardColumn.removeAt(index);
      currentBoardColumn.insert(index, updated);

      currentBoardColumn.removeAt(newColumnId);
      currentBoardColumn.insert(newColumnId, BoardState.PAWN_LOCATION);
      developer.log(TAG, name: "Index of $index");


      boardGridState.removeAt(rowId);
      boardGridState.insert(rowId, currentBoardColumn);

      playerCurrentCoordinates = new Coordinate(rowId, newColumnId);
      playerCurrentCoordinates.isOnEdge = false;
    }
    //Keep the row data same
    else if(isColumnChange){
      List<BoardState> currentBoardRow = boardGridState[rowId];
      //find the index of pawn location in current row
      int index = currentBoardRow.indexOf(BoardState.PAWN_LOCATION);

      //check if the pawn is on the edge of the board
      if((rowId == 0 && currentDirection == Directions.NORTH) || (rowId == 7 && currentDirection == Directions.SOUTH)){
        developer.log(TAG, name: "Returning because pawn is at the edge of the board");
        playerCurrentCoordinates.isOnEdge = true;
        notifyListeners();
        return;
      }
      //create temp variables which preserve old and new states of rows
      List<BoardState> newBoardRow = boardGridState[newRowId];

      //Saving current board state
      BoardState currentboardState = newBoardRow[columnId];
      BoardState updated = BoardState.BLACK;
      //Since in chess board black and white are placed alternatively if the current board state is
      // white then below that on the same index it would be white
      if(currentboardState == BoardState.WHITE){
        updated = BoardState.BLACK;
      }
      else if(currentboardState == BoardState.BLACK){
        updated = BoardState.WHITE;
      }


      //replace the index with updated one
      currentBoardRow.removeAt(index);
      currentBoardRow.insert(index, updated);
      developer.log(TAG, name: "Index of $index");

      newBoardRow.removeAt(columnId);
      newBoardRow.insert(columnId, BoardState.PAWN_LOCATION);
      boardGridState.removeAt(newRowId);
      boardGridState.insert(newRowId, newBoardRow);

      boardGridState.removeAt(rowId);
      boardGridState.insert(rowId, currentBoardRow);

      developer.log(TAG, name: "Picked board state as $rowId and $columnId");
      playerCurrentCoordinates = new Coordinate(newRowId, columnId);
      playerCurrentCoordinates.isOnEdge = false;

    }
    boardStatusState = new BoardStatus(boardGridState);
    notifyListeners();

  }

  void updateDirection(int currentAngle){
    developer.log(TAG, name: "Passed current angle as $currentAngle");
    if(currentAngle == 0 || currentAngle == 360){
      currentDirection = Directions.NORTH;

    }
    else if(currentAngle == -90 || currentAngle == 270){
      currentDirection = Directions.EAST;

    }
    else if(currentAngle == 90 || currentAngle == -270){
      currentDirection = Directions.WEST;

    }
    else if(currentAngle == 180 || currentAngle == -180){
      currentDirection = Directions.SOUTH;
    }

    notifyListeners();
  }

}