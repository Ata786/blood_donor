import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState{

  String? notFound,incorrect;

  LoginState({this.notFound,this.incorrect});

  LoginState userNotFound(String newValue){
    return LoginState(notFound: newValue);
  }

  LoginState incorrectPassword(String newValue){
    return LoginState(incorrect: newValue);
  }

}

class LoginProvider extends StateNotifier<LoginState>{
  LoginProvider({required String found}) : super(LoginState(notFound: found));

  void notFound(String value) => state = state.userNotFound(value);

}

class PasswordProvider extends StateNotifier<LoginState>{
  PasswordProvider({required String passIncorrect}): super(LoginState(incorrect: passIncorrect));

  void notPassword(String value) => state = state.incorrectPassword(value);

}