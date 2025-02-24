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
  double speed = 0; // 기본 속도 설정
  int currentNumber = 0; // 현재 숫자

  Timer? _timer;

  final int _totalFrames = 14;  // 총 프레임 수
  
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
    if (speed <= 0) {
      _timer?.cancel();
      _timer = null;
      setState(() => currentNumber = 0);
      return;
    }

    // 속도에 따른 타이머 간격 계산
    int interval = (1000 / (_totalFrames * (speed / 10))).round().clamp(16, 200);
    
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      if (!mounted) return;
      setState(() {
        currentNumber = (currentNumber + 1) % catImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  void _onSpeedChanged(double newSpeed) {
    if (!mounted) return;

    if (speed != newSpeed) {
      setState(() {
        speed = newSpeed;
      });
      _startNumberUpdate();  // 속도 변경 시 타이머 재시작
    }
  }
}
