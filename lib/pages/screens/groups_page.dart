import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:impak_mobile/blocs/community/bloc/community_bloc.dart';
import 'package:impak_mobile/pages/widgets/group_list_widget.dart';
import 'package:impak_mobile/pages/widgets/list_view_fragment.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityBloc(isGroup: true),
      child: ListViewFragment(
        name: 'Groups',
        child: BlocBuilder<CommunityBloc, CommunityState>(
          builder: (context, state) {
            if (state is InitialCommunityState) {
              context.read<CommunityBloc>().add(LoadCommunity());
            }

            if (state is LoadingCommunityState) {
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(19),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Shimmer(
                      child: Container(
                        height: 70,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemCount: 10,
              );
            }

            if (state is LoadedCommunityState) {
              if (state.communities.isEmpty) {
                return const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 48),
                      Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.grey,
                        size: 69,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'There are no groups yet.',
                      )
                    ],
                  ),
                );
              }

              return AnimationLimiter(
                child: ListView.separated(
                  itemCount: state.communities.length,
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
                            data: state.communities[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
