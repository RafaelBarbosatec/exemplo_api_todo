import 'package:flutter/material.dart';
import 'package:todo_lovepeople/core/functions.dart';
import 'package:todo_lovepeople/model/repository/user_repository.dart';

class RegisterController extends ChangeNotifier {
  final UserRepository _repository;

  bool loading = false;
  RegisterController(this._repository);

  void register(String name, String email, String password,
      {VoidCallback? onSuccess, VoidCallback? onFailure}) {
    _showProgress(true);
    _repository.register(name, email, password).then((value) {
      if (value != null) {
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    }).catchError((e) {
      onFailure?.call();
    }).whenComplete(() {
      _showProgress(false);
    });
  }

  void _showProgress(bool show) {
    postFrame(() {
      loading = true;
      notifyListeners();
    });
  }
}
