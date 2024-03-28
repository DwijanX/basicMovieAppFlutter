import 'package:test_app/Types/movies.dart';

class HomeState {
  HomeState();

  get data => null;
}

class HomeLoading extends HomeState {
  HomeLoading();
}

class HomeNew extends HomeState {
  Welcome data;
  HomeNew({required this.data});
  @override
  List<Object> get props => [data];
}
