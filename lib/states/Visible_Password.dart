import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisibleState{

  String value;

  VisibleState({required this.value});

  VisibleState copyWith(String newValue){
    return VisibleState(value: newValue);
  }

}

class VisibleProvider extends StateNotifier<VisibleState>{
  VisibleProvider({required String value}) : super(VisibleState(value: value));

  void setVisibility(String v) => state = state.copyWith(v);


}