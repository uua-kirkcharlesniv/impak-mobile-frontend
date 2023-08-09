import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

class MoodWeekIndicator extends StatelessWidget {
  const MoodWeekIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff80877B).withOpacity(0.23),
            offset: const Offset(0, 3.51724),
            blurRadius: 6.44828,
          ),
        ],
        color: const Color(0xffFFEDE6),
        borderRadius: BorderRadius.circular(6),
      ),
      width: double.infinity,
      height: 250,
      child: Center(
        child: SizedBox(
          width: 250,
          child: RiveAnimation.asset(
            'assets/impak.riv',
            fit: BoxFit.fill,
            animations: const ['play'],
            onInit: (artboard) {
              final emotion1 = artboard.textRun('emotion1')!;
              final emotion2 = artboard.textRun('emotion2')!;
              final emotion3 = artboard.textRun('emotion3')!;
              final emotion4 = artboard.textRun('emotion4')!;
              final emotion5 = artboard.textRun('emotion5')!;
              final emotion6 = artboard.textRun('emotion6')!;
              final emotion7 = artboard.textRun('emotion7')!;

              emotion1.text = 'Happy';
              emotion2.text = 'Angry';
              emotion3.text = 'Sad';
              emotion4.text = 'Happy';
              emotion5.text = 'Happy';
              emotion6.text = 'Happy';
              emotion7.text = 'Happy';
            },
          ),
        ),
      ),
    );
  }
}
