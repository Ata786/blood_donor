import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioState{
  int value;
  RadioState({required this.value});

  RadioState copyWith(int newValue){
    return RadioState(value: newValue);
  }

}

class RadioProvider extends StateNotifier<RadioState>{
  RadioProvider({required int value}) : super(RadioState(value: value));

  void setValue(int value) => state = state.copyWith(value);

}