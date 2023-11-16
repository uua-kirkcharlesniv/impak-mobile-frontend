import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/blocs/surveys/bloc/surveys_bloc.dart';
import 'package:impak_mobile/pages/widgets/survey_list_grid_item.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../widgets/list_view_fragment.dart';
import '../widgets/survey_list_widget.dart';

class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(),
      child: ListViewFragment(
        name: 'Surveys',
        child: BlocBuilder<SurveysBloc, SurveysState>(
          builder: (context, state) {
            if (state is InitialSurveysState) {
              context.read<SurveysBloc>().add(LoadSurveys());
              return const SizedBox();
            }

            if (state is LoadingSurveysState) {
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(19),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Shimmer(
                      child: Container(
                        height: 150,
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

            if (state is FailedSurveysState) {
              context.read<SurveysBloc>().add(LoadSurveys());

              return const SizedBox();
            }

            if (state is LoadedSurveysState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 162 / 230,
                    ),
                    itemCount: state.ongoing.length,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(19),
                    itemBuilder: (context, index) {
                      final data = state.ongoing[index];

                      return SurveyListGridItem(data: data);
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (state.completed.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 19),
                              child: Text(
                                'Completed Survey',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            AnimationLimiter(
                              child: ListView.separated(
                                itemCount: state.completed.length,
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
                                        child: SurveyListWidget(
                                          isFirst: isFirst,
                                          data: state.completed[index],
                                          isCompleted: true,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 16);
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
