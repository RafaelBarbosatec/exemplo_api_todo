import 'package:flutter/material.dart';
import 'package:todo_lovepeople/core/functions.dart';
import 'package:todo_lovepeople/model/repository/user_repository.dart';

class LoginController extends ChangeNotifier {
  final UserRepository _repository;

  bool loading = false;
  LoginController(this._repository);

  void login(
    String email,
    String senha, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) {
    _showLoading(true);
    _repository.login(email, senha).then((value) {
      if (value != null) {
        onSuccess?.call();
      } else {
        onFailure?.call();
      }
    }).catchError((error) {
      onFailure?.call();
    }).whenComplete(() {
      _showLoading(false);
    });
  }

  void verifyLogin(VoidCallback authenticated){
    _showLoading(true);
    _repository.getLogin().then((value){
      if(value != null){
        authenticated();
      }
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
