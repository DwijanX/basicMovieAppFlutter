import 'package:flutter/material.dart';
import 'package:test_app/HomeBloc/home_cubit.dart';
import 'package:test_app/HomeBloc/home_state.dart';
import 'package:test_app/Types/movies.dart';
import 'package:test_app/counterBloc/string_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/counterBloc/string_state.dart';
import 'package:dio/dio.dart';
import 'package:test_app/preferences.dart';

class HomeBloc extends StatefulWidget {
  const HomeBloc({super.key});

  @override
  State<HomeBloc> createState() => _HomeBlocState();
}

class _HomeBlocState extends State<HomeBloc> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeCubit(), child: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  final dio = Dio();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    fetchMovies() async {
      final response = await dio.get(
          'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3');
      context.read<HomeCubit>().addData(response.toString());
    }

    fetchMovies();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Page Two'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  // Navigate to home screen
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Preferences'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PreferencesPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 50),
            alignment: Alignment.center,
            child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              if (state is HomeLoading) {
                return Text("Loading.......");
              } else if (state is HomeNew) {
                return MyListWidget(items: state.data.results);
              } else {
                return SizedBox();
              }
            })));
  }
}

class MyListWidget extends StatelessWidget {
  final List<Result> items;

  MyListWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    print(items[0].posterPath);
    return ListView(
      children: items
          .map((item) => ListTile(
                leading: Image.network(
                  'https://image.tmdb.org/t/p/original/${item.posterPath}',
                  width: 40, // Adjust the width as needed
                  height: 40, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
                title: Text(item.title),
                onTap: () {
                  // Handle item tap here
                  print('Tapped on ${item.title}');
                },
              ))
          .toList(),
    );
  }
}
