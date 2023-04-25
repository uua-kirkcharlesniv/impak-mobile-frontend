import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../widgets/list_view_fragment.dart';
import '../widgets/survey_list_widget.dart';

class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListViewFragment(
      name: 'Surveys',
      child: AnimationLimiter(
        child: ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(19),
          itemBuilder: (context, index) {
            final isFirst = index == 0;

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: SurveyListWidget(isFirst: isFirst),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
        ),
      ),
    );
  }
}
