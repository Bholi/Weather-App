import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_for_you/cubit/weather_cubit.dart';
import 'package:weather_for_you/resources/weather_repository.dart';
import 'package:weather_for_you/weather/home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => WeatherCubit(
        weatherRepository: RepositoryProvider.of<WeatherRepository>(context)
      ),
      child: const HomeWidget(),
    );
  }
}
