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

  Timer? _timer; // Timer 변수 추가
  double _accumulatedFrame = 0;  // 누적 프레임 값 추가

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
      _accumulatedFrame = 0;  // 누적값 리셋
      setState(() {
        currentNumber = 0;
      });
      return;
    }

    // 타이머가 이미 실행 중이면 새로 시작하지 않음
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) return;
      
      // 프레임 누적값 계산
      _accumulatedFrame += speed / 30;
      
      if (_accumulatedFrame >= 1) {
        setState(() {
          // 누적된 프레임만큼 이미지 인덱스 증가
          currentNumber = (currentNumber + _accumulatedFrame.floor()) % catImages.length;
          _accumulatedFrame = _accumulatedFrame % 1;  // 남은 소수점 유지
        });
      }
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
      
      if (speed > 0 && _timer == null) {
        _startNumberUpdate();
      }
    }
  }
}
