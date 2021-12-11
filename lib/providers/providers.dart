import 'package:curve/grid/pawn_movements_bloc.dart';
import 'package:curve/home/home_screen_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeScreenProvider = ChangeNotifierProvider<HomeScreenBloc>((ref){

  return HomeScreenBloc();
});

final pawnAngleProvider = StateNotifierProvider.autoDispose<PawnMovementsBloc, AsyncValue<int?>>((ref) {
  return PawnMovementsBloc();
});

