import 'package:flutter/material.dart';

import 'mood_clip.dart';

class MoodEntryWidget extends StatelessWidget {
  const MoodEntryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 0.94,
          color: const Color(0xffDDDDDD),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 26,
        vertical: 21,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xffE2E8F0),
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '11:26 AM',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xffB4B4B4,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Monday, Apr 10',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffF3F3F3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(5),
                child: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              MoodClip(name: 'Happy'),
              SizedBox(width: 4),
              MoodClip(name: 'Amazing'),
              SizedBox(width: 4),
              MoodClip(name: 'Focused'),
              SizedBox(width: 4),
              MoodClip(name: 'Enjoyed'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
              '''Today was a pretty good day. I woke up feeling refreshed and energized. I started my day with a cup of coffee and a healthy breakfast. ''')
        ],
      ),
    );
  }
}
