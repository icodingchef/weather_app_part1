import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double? myLongitude;
  double? myLatitude;

  @override
  void initState() {
    super.initState();
    getLocation();
    fetchData();
  }

  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high); // 복사해서 붙여넣기 한 코드
      myLongitude = position.longitude;
      myLatitude = position.latitude;
      print(position);
      print('Longitude: $myLongitude');
      print('Latitude: $myLatitude');
    } catch (e) {
      print("위치 정보수신에 문제가 생겼습니다");
    }
  }

  void fetchData() async {
    http.Response response = await http
        .get(Uri.parse('https://samples.openweathermap.org/data/2.5/weather?'
            'q=London&appid=b1b15e88fa797225412429c1c50c122a1'));
    if (response.statusCode == 200) {
      String jsonData = response.body;
      var myJson = jsonDecode(jsonData)["weather"][0]["id"];
      //var myJson = jsonDecode(jsonData)["wind"]["speed"];
      print(myJson);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
        child: FilledButton(
          onPressed: () {
            getLocation();
          },
          child: const Text('Get location'),
        ),
      ),
    );
  }
}
