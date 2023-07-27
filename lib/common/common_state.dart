import 'package:weather_for_you/model/weather_model.dart';

sealed class CommonState {}

class CommonInitialState extends CommonState {}

class CommonLoadingState extends CommonState {}

class CommonErrorState extends CommonState {
  final String errorMessage;

  CommonErrorState({required this.errorMessage});
}

class CommonSuccessState extends CommonState {
  final Current items;

  CommonSuccessState({required this.items});
}
