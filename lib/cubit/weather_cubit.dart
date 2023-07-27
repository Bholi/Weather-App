
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_for_you/common/common_state.dart';
import 'package:weather_for_you/resources/weather_repository.dart';

class WeatherCubit extends Cubit<CommonState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository}) : super(CommonInitialState());

  fetchData({required String placeName}) async {
    emit(CommonLoadingState());
    final res = await weatherRepository.fetchData(placeName: placeName);
    res.fold((err) => emit(CommonErrorState(errorMessage: err)),
        (data) => emit(CommonSuccessState(items: data)));
  }
}
