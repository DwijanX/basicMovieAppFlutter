import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:test_app/HomeBloc/home_state.dart';
import 'package:test_app/Types/movies.dart';
import 'package:test_app/counterBloc/string_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Welcome data = Welcome(page: 0, results: [], totalPages: 0, totalResults: 0);
  HomeCubit() : super(HomeLoading());

  void addData(String welcomeJson) {
    print("emited");
    print("setting data");
    data = welcomeFromJson(welcomeJson);
    print("emited");

    emit(HomeNew(data: data));
    print("emited");
  }
}
