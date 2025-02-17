import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key, required this.isScreen, required this.onPressed});

  final String isScreen;
  final void Function(String) onPressed;

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final List<String> _buttons = ['Younghee', 'Map'];

  @override
  void didUpdateWidget(Buttons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isScreen != widget.isScreen) {
      setState(() {});
    }
  }

  Color getBackgroundColor(String button) {
    return widget.isScreen == button
        ? (button == 'Map' ? Colors.black : Colors.white)
        : Colors.transparent;
  }

  Color getForegroundColor(String button) {
    return button == 'Map' ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ..._buttons.map(
            (button) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: getBackgroundColor(button),
                  foregroundColor: getForegroundColor(button),
                ),
                onPressed: () => widget.onPressed(button),
                child: Text(button),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
