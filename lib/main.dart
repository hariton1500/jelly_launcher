import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:geolocator/geolocator.dart';

import 'analogclock.dart';
//import 'package:analog_clock/analog_clock.dart';
//import 'package:flutter_analog_clock/flutter_analog_clock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Application>? apps;

  @override
  void initState() {
    super.initState();
    runFutures();
  }

  void runFutures() async {
    DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeSystemApps: true,
            includeAppIcons: true)
        .then((value) => setState(() {
              apps = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/gc1.png'), fit: BoxFit.cover)),
          child: Row(
            children: [left(), center(), right()],
          ),
        ),
      ),
    );
  }

  Widget left() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 3,
      //color: Colors.blue,
      child: Center(
        child: FlutterAnalogClock(
          dialPlateColor: Colors.transparent,
          dateTime: DateTime.now(),
          borderWidth: 1,
          child: Container(),
        ),
      ),
    );
  }

  Widget center() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 3,
      //color: Colors.white,
    );
  }

  Widget right() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 3,
      //color: Colors.black,
      child: const Text('sdf'),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
