import 'package:curve/board/board_status.dart';
import 'package:curve/board/boardstate.dart';
import 'package:curve/board/directions.dart';
import 'package:curve/board/motion_button_bloc.dart';
import 'package:curve/constants.dart';
import 'package:curve/home/coordinate.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends ChangeNotifier with MotionButtonBloc{
  String TAG = "HomeScreenBloc";
  //Notifies home screen page when grid matrix is complete
  bool isGridCreated = false;
  String _pawn = "pawn";
  String get getPawnName => _pawn;
  //Track grid and pawn location
  late BoardStatus boardStatusState;
  late Coordinate playerCurrentCoordinates;
  Directions? currentDirection;
  //Notifies home screen page when pawn has been placed on the grid
  BehaviorSubject<bool> willAcceptStream = new BehaviorSubject<bool>();

  //This flag becomes true whenever first time moves are complete
  bool isTwoMovesComplete = false;
  bool isFirstMoveComplete = false;

  HomeScreenBloc(){
    createGrid(gridRows, gridColumns);
  }

  //When restart button is pressed re-intialize these variables
  void init(){
    isGridCreated = false;
    isTwoMovesComplete = false;
    willAcceptStream = new BehaviorSubject<bool>();
    currentDirection = null;
    isFirstMoveComplete = false;
  }

  //Draw chess board on screen
  void createGrid(int x, int y){
    try {
      List<List<BoardState>> prepareGameGridState = [];
      for(int i = 0 ; i < x; i++){
        List<BoardState> inner = [];
        if(i % 2 == 0){
          for(int j = 0 ; j < x; j++){
            if(j % 2 == 0){
              inner.insert(j,BoardState.WHITE);
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
    addAllButtons();
    notifyListeners();
  }

  //Move position of spawn in grid
  void traverseGrid(int currentAngle){
    //Initialising current and new row variables
    int rowId = playerCurrentCoordinates.xPosition;
    int newRowId = playerCurrentCoordinates.xPosition;
    //Initialising current and new column variables
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

    //According to the direction identify if the movement is along row or is it along column
    if(currentDirection == Directions.SOUTH || currentDirection == Directions.NORTH){
      isColumnChange = true;
    }
    else{
      isRowChange = true;
    }

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
      // white then adjacent to current index it would be black
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

      //Update the grid state and set to global variable
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
      // white then below that on the same index it would be black
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

      //Update the grid state and set to global variable
      boardGridState.removeAt(rowId);
      boardGridState.insert(rowId, currentBoardRow);

      developer.log(TAG, name: "Picked board state as $rowId and $columnId");
      playerCurrentCoordinates = new Coordinate(newRowId, columnId);
      playerCurrentCoordinates.isOnEdge = false;

    }
    if(!isFirstMoveComplete){
      isFirstMoveComplete = true;
      addOrRemoveMoveTwoStep(true);
    }
    boardStatusState = new BoardStatus(boardGridState);
    notifyListeners();

  }

  //Move position of spawn by two spaces
  void traverseGridWithTwoMoves(int currentAngle){
    int rowId = playerCurrentCoordinates.xPosition;
    int newRowId = playerCurrentCoordinates.xPosition;
    int columnId = playerCurrentCoordinates.yPosition;
    int newColumnId = playerCurrentCoordinates.yPosition;
    bool isRowChange = false;
    bool isColumnChange = false;
    List<List<BoardState>> boardGridState = boardStatusState.currentBoardState;
    if(currentAngle == 0){
      currentDirection = Directions.NORTH;
      newRowId = rowId - 2;
    }
    else if(currentAngle == -90 || currentAngle == 270){
      currentDirection = Directions.WEST;
      newColumnId = columnId - 2;
    }
    else if(currentAngle == 90 || currentAngle == -270){
      currentDirection = Directions.EAST;
      newColumnId = columnId + 2;
    }
    else if(currentAngle == 180 || currentAngle == -180){
      currentDirection = Directions.SOUTH;
      newRowId = rowId + 2;
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

      //check if there are two positions available for the pawn to move
      bool isAvailable =  (newColumnId >= 0) && (newColumnId <= 7);
      if(!isAvailable){
        //Since two positions are not available then increment by one position
        if(currentDirection == Directions.WEST){
          newColumnId++;
        }
        else{
          newColumnId--;
        }
      }

      //Saving current board state
      BoardState newboardState = currentBoardColumn[newColumnId];
      BoardState updated = BoardState.BLACK;
      if(isAvailable){
        updated = newboardState;
      }
      else{
        //Since in chess board black and white are placed alternatively if the current board state is
        // white then below that on the same index it would be white
        if(newboardState == BoardState.WHITE){
          updated = BoardState.BLACK;
        }
        else if(newboardState == BoardState.BLACK){
          updated = BoardState.WHITE;
        }

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
      isTwoMovesComplete = true;
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

      //check if there are two positions available for the pawn to move
      bool isAvailable = (newRowId >= 0) && (newRowId <= 7) ;
      if(!isAvailable){
        //Since two positions are not available then increment by one position
        if(currentDirection == Directions.NORTH){
          newRowId++;
        }
        else{
          newRowId--;
        }
      }

      //#region Move Pawn By two places
      //create temp variables which preserve old and new states of rows
      List<BoardState> newBoardRow = boardGridState[newRowId];

      //Saving current board state
      BoardState currentboardState = newBoardRow[columnId];
      BoardState updated = BoardState.BLACK;
      //if position is available then mark the updated state to be same colour as that of new row
      if(isAvailable){
        updated = currentboardState;
      }
      else{
        //Since in chess board black and white are placed alternatively if the current board state is
        // white then below that on the same index it would be white
        if(currentboardState == BoardState.WHITE){
          updated = BoardState.BLACK;
        }
        else if(currentboardState == BoardState.BLACK){
          updated = BoardState.WHITE;
        }
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
      isTwoMovesComplete = true;
      //#endregion
    }
    if(!isFirstMoveComplete){
      isFirstMoveComplete = true;
      addOrRemoveMoveTwoStep(true);
    }
    boardStatusState = new BoardStatus(boardGridState);
    notifyListeners();

  }

  //Notifies direction of motion of pawn
  void updateDirection(int currentAngle){
    if(currentAngle == 0 || currentAngle == 360 || currentAngle == -360){
      currentDirection = Directions.NORTH;

    }
    else if(currentAngle == -90 || currentAngle == 270){
      currentDirection = Directions.WEST;

    }
    else if(currentAngle == 90 || currentAngle == -270){
      currentDirection = Directions.EAST;

    }
    else if(currentAngle == 180 || currentAngle == -180){
      currentDirection = Directions.SOUTH;
    }

    notifyListeners();
  }

}