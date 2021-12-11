import 'package:curve/board/boardstate.dart';

//This class shall preserve the current game state
class BoardStatus{
  List<List<BoardState>> currentBoardStateList = [];
  List<List<BoardState>> get currentBoardState => currentBoardStateList;
  BoardStatus(this.currentBoardStateList);
}