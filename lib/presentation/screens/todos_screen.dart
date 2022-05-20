import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/constants/strings.dart';
import 'package:flutter_todo/cubit/todos_cubit.dart';

import '../../data/models/todo.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodosCubit>(context).fetchTodos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, ADD_TODO_ROUTE),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          if (state is! TodosLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = (state).todos;

          return SingleChildScrollView(
            child: Column(
              children: todos.map((e) => _todo(e, context)).toList(),
            ),
          );
        },
      ),
    );
  }
}

Widget _todo(Todo todo, context) {
  return InkWell(
    onTap: (() => Navigator.pushNamed(context, EDIT_TODO_ROUTE)),
    child: Dismissible(
      key: Key("${todo.id}"),
      child: _todoTile(todo, context),
      background: Container(color: Colors.indigo),
      confirmDismiss: (_) async {
        BlocProvider.of<TodosCubit>(context).changeCompletion(todo);
        return false;
      },
    ),
  );
}

Widget _todoTile(Todo todo, context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
    decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(todo.todoMessage), _completionIndicator(todo)],
    ),
  );
}

Widget _completionIndicator(Todo todo) {
  return Container(
    width: 20.0,
    height: 20.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
            width: 4.0, color: todo.isCompleted ? Colors.green : Colors.red)),
  );
}
