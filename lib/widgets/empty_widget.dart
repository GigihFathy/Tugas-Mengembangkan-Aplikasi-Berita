import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key, this.text = 'No articles yet!'})
      : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures minimal vertical space
        children: [
          LottieBuilder.asset(
            'assets/anim/empty.json',
            repeat: false,
            width: 300.0,
            height: 300.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 24.0,
            ),
          ),
        ],
      ),
    );
  }
}
