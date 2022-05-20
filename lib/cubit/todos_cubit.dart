import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_todo/data/repository.dart';
import 'package:meta/meta.dart';

import '../data/models/todo.dart';

part 'todos_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final Repository repository;

  TodosCubit({required this.repository}) : super(TodosInitial());

  void fetchTodos() {
    Timer(const Duration(seconds: 3), () {
      repository.fetchTodos().then((todos) => emit(TodosLoaded(todos: todos!)));
    });
  }

  void changeCompletion(Todo todo) {
    repository.changeCompletion(todo.isCompleted, todo.id).then((isChanged) {
      if (isChanged) {
        todo.isCompleted = !todo.isCompleted;
        updateTodoList();
      }
    });
  }

  void updateTodoList() {
    final currentState = state;
    if (currentState is TodosLoaded) {
      emit(TodosLoaded(todos: currentState.todos));
    }
  }

  void addTodo(Todo todo) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final todosList = currentState.todos;
      todosList.add(todo);
      emit(TodosLoaded(todos: currentState.todos));
    }
  }
}
