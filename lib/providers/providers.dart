import 'package:curve/home/home_screen_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeScreenProvider = ChangeNotifierProvider<HomeScreenBloc>((ref){

  return HomeScreenBloc();
});
