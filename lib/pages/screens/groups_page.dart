import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:impak_mobile/pages/widgets/group_list_widget.dart';
import 'package:impak_mobile/pages/widgets/list_view_fragment.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListViewFragment(
      name: 'Groups',
      child: AnimationLimiter(
        child: ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(19),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (context, index) {
            final isFirst = index == 0;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: GroupListWidget(
                    isFirst: isFirst,
                    index: index,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
