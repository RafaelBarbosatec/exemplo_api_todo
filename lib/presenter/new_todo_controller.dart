import 'package:flutter/material.dart';
import 'package:todo_lovepeople/core/functions.dart';
import 'package:todo_lovepeople/model/repository/todo_repository.dart';
import 'package:todo_lovepeople/model/todo.dart';

class NewTodoController extends ChangeNotifier {
  final TodoRepository _repository;

  bool loading = false;
  NewTodoController(this._repository);

  void registerTodo(
    Todo todo, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) {
    _showLoading(true);
    _repository.register(todo).then((value) {
      if(value != null){
        onSuccess?.call();
      }else{
        onFailure?.call();
      }
    }).catchError((e){
       onFailure?.call();
    }).whenComplete((){
      _showLoading(false);
    });
  }


  void _showLoading(bool show) {
    postFrame(() {
      loading = show;
      notifyListeners();
    });
  }
}
