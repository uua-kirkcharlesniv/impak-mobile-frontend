import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/blocs/surveys/bloc/surveys_bloc.dart';
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
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xffEAEAEA),
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        'https://unsplash.com/photos/Y5bvRlcCx8k/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8Mnx8Y29tcGFueXxlbnwwfHx8fDE2OTk5Mjg1ODd8MA&force=true&w=640',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 5,
                                    top: 5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.65),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 1.5,
                                          ),
                                          child: AutoSizeText(
                                            data['survey_type']
                                                .toString()
                                                .replaceAll('_', ' ')
                                                .toTitleCase(),
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.clock_fill,
                                  color: Colors.grey,
                                  size: 12,
                                ),
                                SizedBox(width: 2.5),
                                Text(
                                  '9 PM, Today',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            AutoSizeText(
                              data['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0F172A),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['rationale_description'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: Color(0xff696969),
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff544BE8).withOpacity(0.33),
                                    blurRadius: 13,
                                    offset: Offset(0, 4),
                                  )
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff7C74FF),
                                    Color(0xff544BE8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Start Survey',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
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
