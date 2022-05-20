import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/constants/strings.dart';
import 'package:flutter_todo/cubit/add_todo_cubit.dart';
import 'package:flutter_todo/cubit/todos_cubit.dart';
import 'package:flutter_todo/data/network.dart';
import '../data/repository.dart';
import 'screens/add_todo_screen.dart';
import 'screens/edit_todo_screen.dart';
import 'screens/todos_screen.dart';

class AppRouter {
  late Repository repository;
  late TodosCubit todosCubit;

  AppRouter() {
    repository = Repository(networkService: NetworkService());
    todosCubit = TodosCubit(repository: repository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: todosCubit, child: const TodosScreen()));
      case EDIT_TODO_ROUTE:
        return MaterialPageRoute(builder: (_) => const EditTodoScreen());
      case ADD_TODO_ROUTE:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) =>
                AddTodoCubit(repository: repository, todosCubit: todosCubit),
            child: AddTodoScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
