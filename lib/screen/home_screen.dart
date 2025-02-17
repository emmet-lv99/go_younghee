import 'dart:async'; // Timer를 사용하기 위해 추가

import 'package:flutter/material.dart';
import 'package:go_younghee/screen/comp/buttons.dart';
import 'package:go_younghee/screen/map_screen.dart';
import 'package:go_younghee/screen/younghee_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String isScreen = 'Younghee';
  late MapScreen mapScreen;
  double speed = 1; // 기본 속도 설정
  int currentNumber = 0; // 현재 숫자

  Timer? _timer; // Timer 변수 추가

  List<Image> catImages = [
    Image.asset('asset/0.png'),
    Image.asset('asset/1.png'),
    Image.asset('asset/2.png'),
    Image.asset('asset/3.png'),
    Image.asset('asset/4.png'),
    Image.asset('asset/5.png'),
    Image.asset('asset/6.png'),
    Image.asset('asset/7.png'),
    Image.asset('asset/8.png'),
    Image.asset('asset/9.png'),
    Image.asset('asset/10.png'),
    Image.asset('asset/11.png'),
    Image.asset('asset/12.png'),
    Image.asset('asset/13.png'),
  ];

  @override
  void initState() {
    super.initState();
    mapScreen = MapScreen(onSpeedChanged: _onSpeedChanged);
    _startNumberUpdate(); // 숫자 업데이트 시작
  }

  void _startNumberUpdate() {
    _timer =
        Timer.periodic(Duration(milliseconds: (5000 / speed).round()), (timer) {
      setState(() {
        if (currentNumber < catImages.length - 1) {
          currentNumber++;
        } else {
          currentNumber = 0;
          // timer.cancel(); // 10에 도달하면 타이머 중지
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mapScreen,
          isScreen == 'Younghee'
              ? YoungheeScreen(
                  speed: speed,
                  catImage: catImages[currentNumber],
                )
              : Container(),
          Buttons(isScreen: isScreen, onPressed: _onPressed),
        ],
      ),
    );
  }

  _onPressed(String button) {
    setState(() {
      if (button == 'Map') {
        isScreen = 'Map';
      } else {
        isScreen = 'Younghee';
      }
    });
  }

  _onSpeedChanged(double speed) {
    setState(() {
      this.speed = speed;
      _startNumberUpdate(); // 속도가 변경되면 숫자 업데이트 시작
    });
  }
}
