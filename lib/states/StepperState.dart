
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepperState{
  int value;
  StepperState({required this.value});

  StepperState copyWith(int newValue){
    return StepperState(value: newValue);
  }

}

class StepperProvider extends StateNotifier<StepperState>{
  StepperProvider({required int stepValue}) : super(StepperState(value: stepValue));

  void setStepValue(int stepValue) => state = state.copyWith(stepValue);

}