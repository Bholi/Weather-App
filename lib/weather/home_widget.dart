// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_for_you/common/common_state.dart';
import 'package:weather_for_you/cubit/weather_cubit.dart';
import 'package:weather_for_you/spalsh/help_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  double temperature = 0;
  String weatherCondition = "";
  String weatherIcon = "";
  String? _currentAddress;
  Position? _currentPosition;
  bool isLoading = false;
  String _savedText = "";

  // Future<void> fetchData() async {
  //   final url =
  //       'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=${_textEditingController.text}';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     setState(() {
  //       temperature = data['current']['temp_c'];
  //       weatherCondition = data['current']['condition']['text'];
  //       weatherIcon = 'http:${data['current']['condition']['icon']}';
  //     });
  //   } else {
  //     setState(() {
  //       temperature = 0;
  //       weatherCondition = 'Failed to fetch weather data';
  //       weatherIcon = '';
  //     });
  //   }
  // }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> loadText() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _savedText = preferences.getString("saveKey") ?? "";
      _textEditingController.text = _savedText;
    });
  }

  Future<void> saveText(String text) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("saveKey", text);
  }

  @override
  void initState() {
    loadText();
    _handleLocationPermission();
    _getCurrentPosition();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Weather For You",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(isFromDashboard: true),
                ),
              );
            },
            icon: const Icon(
              Icons.help,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Please enter the location Ex:London",
                  labelText: "Enter the location"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              saveText(_textEditingController.text);

              if (_textEditingController.text.isEmpty) {
                _currentAddress =
                    "${_currentPosition?.latitude},${_currentPosition?.longitude}";
                _textEditingController.text = _currentAddress as String;
                context
                    .read<WeatherCubit>()
                    .fetchData(placeName: _textEditingController.text);
              } else {
                // fetchData();
                context
                    .read<WeatherCubit>()
                    .fetchData(placeName: _textEditingController.text);
                    setState(() {
                      
                    });
              }

            },
            child: Text(
              _textEditingController.text.isEmpty ? "Save" : "Update",
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          BlocBuilder<WeatherCubit, CommonState>(
            builder: (context, state) {
              if (state is CommonSuccessState) {
                weatherIcon = state.items.condition.icon;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Temperature : ${state.items.tempC}"),
                    Text("Weather Condition : ${state.items.condition.text}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Weather Icon :"),
                        weatherIcon.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: "http:$weatherIcon",
                                width: 64,
                                height: 64,
                              )
                            : Container(),
                      ],
                    ),
                  ],
                );
              } else if (state is CommonErrorState) {
                return Text(state.errorMessage);
              } else {
                return const Column();
              }
            },
          ),
        ],
      ),
    );
  }
}
