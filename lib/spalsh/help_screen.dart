import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_for_you/weather/home_screen.dart';

class HelpScreen extends StatefulWidget {
  final bool isFromDashboard;
  const HelpScreen({super.key, this.isFromDashboard = false});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Timer? _timer;

  @override
  void initState() {
    if (widget.isFromDashboard == false) {
      _timer = Timer(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      });
    }
    initHive();
    super.initState();
  }

  initHive() async {
    final _box = await Hive.openBox("weather");
    _box.put("isOpened", true);
  }

  // Future<void> _checkFirstLaunch() async {
  //   final SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final bool isFirstLaunch = preferences.getBool('isFirstLaunch') ?? true;

  //   if (!isFirstLaunch) {
  //     _timer?.cancel();
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const HomeScreen(),
  //       ),
  //     );
  //   } else {
  //     await preferences.setBool('isFirstLaunch', false);
  //   }
  // }

  // @override
  // void didChangeDependencies() {
  //   _checkFirstLaunch();
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'images/bgImg.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.30,
                left: MediaQuery.of(context).size.width * 0.25,
                child: const Text(
                  "We show weather for you",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.30,
                  left: MediaQuery.of(context).size.width * 0.40,
                  child: ElevatedButton(
                    onPressed: () {
                      _timer?.cancel();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    },
                    child: const Text("Skip"),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
