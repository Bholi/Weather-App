import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_for_you/cubit/weather_cubit.dart';
import 'package:weather_for_you/resources/weather_repository.dart';
import 'package:weather_for_you/spalsh/help_screen.dart';
import 'package:weather_for_you/weather/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox("weather");
  final bool isAlreadyOpened = box.get("isOpened") ?? false;
  runApp(MyApp(
    isAlreadyOpened: isAlreadyOpened,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAlreadyOpened;
  const MyApp({super.key, required this.isAlreadyOpened});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(),
      child: BlocProvider(
        create: (context) => WeatherCubit(
          weatherRepository: RepositoryProvider.of<WeatherRepository>(context),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isAlreadyOpened ? const HomeScreen() : const HelpScreen(),
          // home: const HomeScreen(),
        ),
      ),
    );
  }
}
