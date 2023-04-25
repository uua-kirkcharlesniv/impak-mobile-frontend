import 'package:flutter/material.dart';

class SurveyClip extends StatelessWidget {
  final String name;
  final IconData icon;
  const SurveyClip({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF).withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 8,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}
