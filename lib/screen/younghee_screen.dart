import 'package:flutter/material.dart';

class YoungheeScreen extends StatelessWidget {
  const YoungheeScreen({
    super.key,
    required this.speed,
    required this.catImage,
  });

  final double speed;
  final Image catImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            catImage,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$speed',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'km/h',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
