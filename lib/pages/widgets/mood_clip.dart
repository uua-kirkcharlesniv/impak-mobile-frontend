import 'package:flutter/material.dart';

class MoodClip extends StatelessWidget {
  final String name;
  const MoodClip({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    var color = Colors.white;
    switch (name) {
      case 'Surprised':
      case 'Happy':
      case 'Relaxed':
        color = const Color(0xff93C5FD);
        break;
      case 'Amazing':
        color = const Color(0xff6EE7B7);
        break;
      case 'Focused':
      case 'Envious':
        color = const Color(0xffFDA4AF);
        break;
      case 'Enjoyed':
        color = const Color(0xffFCD34D);
        break;
      default:
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
