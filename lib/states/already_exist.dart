import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExistState{

  String value;

  ExistState({required this.value});

  ExistState copyWith(String newValue){
    return ExistState(value: newValue);
  }

}

class ExistProvider extends StateNotifier<ExistState>{
  ExistProvider({required String value}) : super(ExistState(value: value));

  void setValue(String v) => state = state.copyWith(v);


}