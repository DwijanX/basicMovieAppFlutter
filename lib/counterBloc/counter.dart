import 'package:flutter/material.dart';
import 'package:test_app/counterBloc/string_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/counterBloc/string_state.dart';

class CounterBloc extends StatefulWidget {
  const CounterBloc({super.key});

  @override
  State<CounterBloc> createState() => _CounterBlocState();
}

class _CounterBlocState extends State<CounterBloc> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => StringCubit(), child: FormView());
  }
}

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StringCubit, StringState>(builder: (context, state) {
        if (state is StringLoading) {
          return Text("Loading.......");
        } else if (state is StringNew) {
          return Text(state.data);
        } else {
          return Text("");
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<StringCubit>().addData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
