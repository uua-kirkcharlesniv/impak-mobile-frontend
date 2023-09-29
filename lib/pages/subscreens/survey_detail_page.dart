// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:impak_mobile/blocs/survey/bloc/survey_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SurveyDetailPage extends StatefulWidget {
  const SurveyDetailPage({
    super.key,
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  PageController controller = PageController(initialPage: 0);
  PageController subController = PageController(initialPage: 0);
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (60 * 5);

  bool isAtStart = true;
  bool isAtEnd = false;
  int currentSection = 0;
  int currentQuestion = 0;
  int totalSections = 9999;
  int totalQuestions = 9999;
  List<int> totalQuestionsPerSection = [];

  int get answeredQuestionsCount {
    int answeredQuestionsCount = 0;

    for (int i = 0; i < currentSection; i++) {
      answeredQuestionsCount += totalQuestionsPerSection[i];
    }

    answeredQuestionsCount += currentQuestion;

    return answeredQuestionsCount;
  }

  Map<String, dynamic> get currentSectionData {
    final currentState = context.read<SurveyBloc>().state;
    if (currentState is LoadedSurveyState) {
      return currentState.survey['sections'][currentSection];
    }

    return {};
  }

  Map<String, dynamic> get currentQuestionData {
    if (currentSectionData.isNotEmpty) {
      return currentSectionData['questions'][currentQuestion];
    }

    return {};
  }

  num get progressPercentage {
    return (answeredQuestionsCount / totalQuestions) * 100;
  }

  bool get isFinishing {
    return answeredQuestionsCount + 1 >= totalQuestions;
  }

  void _handleBackKey() {
    Navigator.pop(context);

    // if (currentPage == 0) {
    //   Navigator.pop(context);
    // } else if (currentPage == 2) {
    //   controller.previousPage(
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    //   setState(() {
    //     subCurrentPage = 0;
    //   });
    // } else {
    //   if (subCurrentPage == 0) {
    //     controller.previousPage(
    //       duration: const Duration(milliseconds: 300),
    //       curve: Curves.easeInOut,
    //     );
    //   } else {
    //     subController.previousPage(
    //       duration: const Duration(milliseconds: 300),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // }
  }

  void _handleNextKey() {
    if (isAtStart) {
      setState(() {
        isAtStart = false;
      });
      return;
    } else if (isAtEnd) {
      Navigator.pop(context);
    }

    if (currentQuestion < totalQuestionsPerSection[currentSection] - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      if (currentSection < totalSections - 1) {
        setState(() {
          currentSection++;
          currentQuestion = 0;
        });
      } else {
        setState(() {
          isAtEnd = true;
        });
      }
    }
  }

  String _buildPageTextButton() {
    if (isAtStart) {
      return 'Start Survey';
    } else if (isAtEnd) {
      return 'Go back';
    } else if (isFinishing) {
      return 'Submit Survey';
    }

    return 'Next';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: BlocBuilder<SurveyBloc, SurveyState>(
        buildWhen: (previous, current) {
          if (previous is! LoadedSurveyState && current is LoadedSurveyState) {
            final survey = current.survey;
            final sections = survey['sections'] as List;

            var localTotalQuestionCount = 0;
            var localTotalQuestionPerSection = <int>[];
            for (var section in sections) {
              final questions = section['questions'] as List;
              localTotalQuestionCount += questions.length;
              localTotalQuestionPerSection.add(questions.length);
            }

            setState(() {
              totalSections = sections.length;
              totalQuestions = localTotalQuestionCount;
              totalQuestionsPerSection = localTotalQuestionPerSection;
            });
          }

          return true;
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _handleBackKey,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xffEBEBEB),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (isAtStart) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/notification.png',
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Just a friendly reminder\nbefore starting our survey!',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '''Your opinions are valuable to us, and we'd love to hear what you have to say.''',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Color(0xff787878),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else if (isAtEnd) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/success.png',
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'We\'re all done!',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '''Thank you for taking the time to complete our survey. ''',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Color(0xff787878),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }

                      return PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller,
                        children: [
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentSectionData['name'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: (answeredQuestionsCount + 1)
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' of $totalQuestions',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff6F6F6F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffEBEBEB),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(children: [
                                      const Icon(
                                        FontAwesomeIcons.solidClock,
                                        color: Color(0xff818CF8),
                                        size: 10,
                                      ),
                                      const SizedBox(width: 4),
                                      CountdownTimer(
                                        endTime: endTime,
                                        widgetBuilder: (context, time) {
                                          if (time == null) {
                                            return const Center(
                                              child: Text(
                                                'Time is up, please complete the survey',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            );
                                          }
                                          String value = '';
                                          if (time.days != null) {
                                            var days =
                                                _getNumberAddZero(time.days!);
                                            value = '$value$days days ';
                                          }
                                          final parsedHours = time.hours ?? 0;
                                          if (parsedHours > 0) {
                                            var hours =
                                                _getNumberAddZero(parsedHours);
                                            value = '$value$hours:';
                                          }
                                          var min =
                                              _getNumberAddZero(time.min ?? 0);
                                          value = '$value$min:';
                                          var sec =
                                              _getNumberAddZero(time.sec ?? 0);
                                          value = '$value$sec';
                                          return Text(
                                            value,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          );
                                        },
                                        onEnd: () {},
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: progressPercentage / 100,
                                  ),
                                  builder: (context, value, _) =>
                                      LinearProgressIndicator(
                                    value: value,
                                    color: const Color(0xff4F46E5),
                                    backgroundColor: const Color(0xffD9D9D9),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: PageView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: subController,
                                  itemBuilder: (context, index) {
                                    return SurveyQuestionDetail(
                                        currentQuestionData['content']
                                            .toString(), child: Builder(
                                      builder: (context) {
                                        switch (currentQuestionData['type']) {
                                          case 'radio':
                                          case 'multiselect':
                                            var selectedIndex = 0;

                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return ListView.separated(
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: selectedIndex ==
                                                                index
                                                            ? const Color(
                                                                0xff4F46E5)
                                                            : const Color(
                                                                0xffF4F4F4),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: Text(
                                                        currentQuestionData[
                                                            'options'][index],
                                                        style: TextStyle(
                                                          color: selectedIndex ==
                                                                  index
                                                              ? const Color(
                                                                  0xff4F46E5)
                                                              : Colors.black,
                                                          fontWeight:
                                                              selectedIndex ==
                                                                      index
                                                                  ? FontWeight
                                                                      .bold
                                                                  : null,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 16);
                                                },
                                                itemCount: (currentQuestionData[
                                                        'options'])
                                                    .length,
                                              );
                                            });

                                            break;

                                          case 'time':
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                  },
                                                  child: Text('Select time'),
                                                ),
                                              ],
                                            );

                                          case 'date':
                                            return SfDateRangePicker();
                                          case 'short-answer':
                                          case 'long-answer':
                                            final isLong =
                                                currentQuestionData['type'] ==
                                                    'long-answer';
                                            return TextField(
                                              keyboardType: isLong
                                                  ? TextInputType.multiline
                                                  : TextInputType.text,
                                              maxLines: isLong ? 24 : null,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Open-ended text response',
                                                hintStyle: const TextStyle(
                                                  color: Color(0xffDBDBDB),
                                                ),
                                                focusColor:
                                                    const Color(0xff4F46E5),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xff4F46E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xffF4F4F4),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xffF4F4F4),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            );
                                          case 'range':
                                            return RatingBar.builder(
                                              initialRating: 5,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 10,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                              ),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.favorite,
                                                color: Color(0xff4F46E5),
                                                size: 10,
                                              ),
                                              glowColor: Colors.white,
                                              itemSize: 30,
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            );

                                          case 'likert':
                                            var selectedIndex = 0;

                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return ListView.separated(
                                                itemBuilder: (context, index) {
                                                  var emoji = '';
                                                  var title = '';
                                                  final isSelected =
                                                      selectedIndex == index;

                                                  switch (index) {
                                                    case 0:
                                                      emoji = '🚀';
                                                      title = 'Very Satisfied';
                                                      break;
                                                    case 1:
                                                      emoji = '😊';
                                                      title = 'Satisfied';
                                                      break;
                                                    case 2:
                                                      emoji = '😐';
                                                      title = 'Neutral';
                                                      break;
                                                    case 3:
                                                      emoji = '😞';
                                                      title = 'Unsatisfied';
                                                      break;
                                                    default:
                                                  }

                                                  return Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? const Color(
                                                                0xff4F46E5)
                                                            : const Color(
                                                                0xffF4F4F4),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: Text(
                                                        emoji,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xff818CF8),
                                                          fontSize: 32,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        title,
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? const Color(
                                                                  0xff4F46E5)
                                                              : Colors.black,
                                                          fontWeight: isSelected
                                                              ? FontWeight.bold
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                      height: 16);
                                                },
                                                itemCount: 4,
                                              );
                                            });

                                          default:
                                            print(currentQuestionData['type']);
                                            break;
                                        }

                                        return const SizedBox();
                                      },
                                    ));
                                  },
                                  // children: [
                                  //   SurveyQuestionDetail(
                                  //     'What suggestions do you have to improve the event in the future?',
                                  //     child: TextField(
                                  //       keyboardType: TextInputType.multiline,
                                  //       maxLines: 24,
                                  //       decoration: InputDecoration(
                                  //         hintText: 'Open-ended text response',
                                  //         hintStyle: const TextStyle(
                                  //           color: Color(0xffDBDBDB),
                                  //         ),
                                  //         focusColor: const Color(0xff4F46E5),
                                  //         focusedBorder: OutlineInputBorder(
                                  //           borderSide: const BorderSide(
                                  //             color: Color(0xff4F46E5),
                                  //           ),
                                  //           borderRadius:
                                  //               BorderRadius.circular(10.0),
                                  //         ),
                                  //         enabledBorder: OutlineInputBorder(
                                  //           borderSide: const BorderSide(
                                  //             color: Color(0xffF4F4F4),
                                  //             width: 1,
                                  //           ),
                                  //           borderRadius:
                                  //               BorderRadius.circular(10.0),
                                  //         ),
                                  //         border: OutlineInputBorder(
                                  //           borderSide: const BorderSide(
                                  //             color: Color(0xffF4F4F4),
                                  //             width: 1,
                                  //           ),
                                  //           borderRadius:
                                  //               BorderRadius.circular(10.0),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   SurveyQuestionDetail(
                                  //     'How satisfied are you with our services?',
                                  //     child: ListView.separated(
                                  //       itemBuilder: (context, index) {
                                  //         var emoji = '';
                                  //         var title = '';
                                  //         final isSelected = index == 0;

                                  //         switch (index) {
                                  //           case 0:
                                  //             emoji = '🚀';
                                  //             title = 'Very Satisfied';
                                  //             break;
                                  //           case 1:
                                  //             emoji = '😊';
                                  //             title = 'Satisfied';
                                  //             break;
                                  //           case 2:
                                  //             emoji = '😐';
                                  //             title = 'Neutral';
                                  //             break;
                                  //           case 3:
                                  //             emoji = '😞';
                                  //             title = 'Unsatisfied';
                                  //             break;
                                  //           default:
                                  //         }

                                  //         return Container(
                                  //           padding: const EdgeInsets.symmetric(
                                  //             horizontal: 12,
                                  //           ),
                                  //           decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //               color: isSelected
                                  //                   ? const Color(0xff4F46E5)
                                  //                   : const Color(0xffF4F4F4),
                                  //             ),
                                  //             borderRadius:
                                  //                 BorderRadius.circular(4),
                                  //           ),
                                  //           child: ListTile(
                                  //             contentPadding: EdgeInsets.zero,
                                  //             leading: Text(
                                  //               emoji,
                                  //               style: const TextStyle(
                                  //                 color: Color(0xff818CF8),
                                  //                 fontSize: 32,
                                  //               ),
                                  //             ),
                                  //             title: Text(
                                  //               title,
                                  //               style: TextStyle(
                                  //                 color: isSelected
                                  //                     ? const Color(0xff4F46E5)
                                  //                     : Colors.black,
                                  //                 fontWeight: isSelected
                                  //                     ? FontWeight.bold
                                  //                     : null,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         );
                                  //       },
                                  //       separatorBuilder: (context, index) {
                                  //         return const SizedBox(height: 16);
                                  //       },
                                  //       itemCount: 4,
                                  //     ),
                                  //   ),
                                  //   SurveyQuestionDetail(
                                  //     'What were the main challenges you faced while starting the company?',
                                  //     child: ListView.separated(
                                  //       itemBuilder: (context, index) {
                                  //         var title = '';
                                  //         final isSelected =
                                  //             index == 1 || index == 2;

                                  //         switch (index) {
                                  //           case 0:
                                  //             title =
                                  //                 'Difficulty finding the right team';
                                  //             break;
                                  //           case 1:
                                  //             title = 'Lack of funding';
                                  //             break;
                                  //           case 2:
                                  //             title =
                                  //                 'Competition in the market';
                                  //             break;
                                  //           case 3:
                                  //             title = 'Other (please specify)';
                                  //             break;
                                  //           default:
                                  //         }

                                  //         return Container(
                                  //           padding: const EdgeInsets.symmetric(
                                  //             horizontal: 12,
                                  //           ),
                                  //           decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //               color: isSelected
                                  //                   ? const Color(0xff4F46E5)
                                  //                   : const Color(0xffF4F4F4),
                                  //             ),
                                  //             borderRadius:
                                  //                 BorderRadius.circular(4),
                                  //           ),
                                  //           child: ListTile(
                                  //             contentPadding: EdgeInsets.zero,
                                  //             title: Text(
                                  //               title,
                                  //               style: TextStyle(
                                  //                 color: isSelected
                                  //                     ? const Color(0xff4F46E5)
                                  //                     : Colors.black,
                                  //                 fontWeight: isSelected
                                  //                     ? FontWeight.bold
                                  //                     : null,
                                  //               ),
                                  //             ),
                                  //             trailing: Checkbox(
                                  //               checkColor: Colors.white,
                                  //               activeColor:
                                  //                   const Color(0xff4F46E5),
                                  //               //     MaterialStateProperty.resolveWith(
                                  //               //   (_) => const Color(0xff4F46E5),
                                  //               // ),
                                  //               value: isSelected,
                                  //               shape: const CircleBorder(),
                                  //               onChanged: (bool? value) {},
                                  //             ),
                                  //           ),
                                  //         );
                                  //       },
                                  //       separatorBuilder: (context, index) {
                                  //         return const SizedBox(height: 16);
                                  //       },
                                  //       itemCount: 4,
                                  //     ),
                                  //   ),
                                  //   // SurveyQuestionDetail(
                                  //   //   'Can you discuss your marketing strategies and how you attract new customers?',
                                  //   //   shouldWrapChildInExpanded: false,
                                  //   //   child: SizedBox(
                                  //   //     width: double.infinity,
                                  //   //     height: 25,
                                  //   //     child: DropdownButtonHideUnderline(
                                  //   //       child: DropdownButton2(
                                  //   //         hint: Text(
                                  //   //           'Please choose an option',
                                  //   //           style: TextStyle(
                                  //   //             fontSize: 14,
                                  //   //             color:
                                  //   //                 Theme.of(context).hintColor,
                                  //   //           ),
                                  //   //         ),
                                  //   //         items: items
                                  //   //             .map((item) =>
                                  //   //                 DropdownMenuItem<String>(
                                  //   //                   value: item,
                                  //   //                   child: Text(
                                  //   //                     item,
                                  //   //                     style: const TextStyle(
                                  //   //                       fontSize: 14,
                                  //   //                     ),
                                  //   //                   ),
                                  //   //                 ))
                                  //   //             .toList(),
                                  //   //         value: selectedValue,
                                  //   //         onChanged: (value) {
                                  //   //           setState(() {
                                  //   //             selectedValue = value as String;
                                  //   //           });
                                  //   //         },
                                  //   //         buttonStyleData:
                                  //   //             const ButtonStyleData(
                                  //   //           height: 40,
                                  //   //           width: 140,
                                  //   //         ),
                                  //   //         menuItemStyleData:
                                  //   //             const MenuItemStyleData(
                                  //   //           height: 40,
                                  //   //         ),
                                  //   //       ),
                                  //   //     ),
                                  //   //   ),
                                  //   // ),
                                  //   // SurveyQuestionDetail(
                                  //   //   'What is the average workday start and end time for your team?',
                                  //   //   child: Column(
                                  //   //     crossAxisAlignment:
                                  //   //         CrossAxisAlignment.start,
                                  //   //     children: [
                                  //   //       const Text(
                                  //   //         'Start time:',
                                  //   //         style: TextStyle(
                                  //   //           fontWeight: FontWeight.w500,
                                  //   //           fontSize: 14,
                                  //   //         ),
                                  //   //       ),
                                  //   //       const SizedBox(height: 10),
                                  //   //       Container(
                                  //   //         padding: const EdgeInsets.all(17),
                                  //   //         decoration: BoxDecoration(
                                  //   //           border: Border.all(
                                  //   //             color: const Color(0xffF4F4F4),
                                  //   //             width: 1,
                                  //   //           ),
                                  //   //           borderRadius:
                                  //   //               BorderRadius.circular(4),
                                  //   //         ),
                                  //   //         child: Row(
                                  //   //           children: [
                                  //   //             const Icon(
                                  //   //               FontAwesomeIcons.clock,
                                  //   //               size: 16,
                                  //   //             ),
                                  //   //             const SizedBox(width: 8),
                                  //   //             const Text(
                                  //   //               '08:00 AM',
                                  //   //               style: TextStyle(
                                  //   //                 fontWeight: FontWeight.w500,
                                  //   //                 fontSize: 14,
                                  //   //               ),
                                  //   //             ),
                                  //   //             const Spacer(),
                                  //   //             const Icon(
                                  //   //               CupertinoIcons.arrow_down,
                                  //   //             ),
                                  //   //           ],
                                  //   //         ),
                                  //   //       ),
                                  //   //       const SizedBox(height: 20),
                                  //   //       const Text(
                                  //   //         'End time:',
                                  //   //         style: TextStyle(
                                  //   //           fontWeight: FontWeight.w500,
                                  //   //           fontSize: 14,
                                  //   //         ),
                                  //   //       ),
                                  //   //       const SizedBox(height: 10),
                                  //   //       Container(
                                  //   //         padding: const EdgeInsets.all(17),
                                  //   //         decoration: BoxDecoration(
                                  //   //           border: Border.all(
                                  //   //             color: const Color(0xffF4F4F4),
                                  //   //             width: 1,
                                  //   //           ),
                                  //   //           borderRadius:
                                  //   //               BorderRadius.circular(4),
                                  //   //         ),
                                  //   //         child: Row(
                                  //   //           children: [
                                  //   //             const Icon(
                                  //   //               FontAwesomeIcons.clock,
                                  //   //               size: 16,
                                  //   //             ),
                                  //   //             const SizedBox(width: 8),
                                  //   //             const Text(
                                  //   //               '05:00 PM',
                                  //   //               style: TextStyle(
                                  //   //                 fontWeight: FontWeight.w500,
                                  //   //                 fontSize: 14,
                                  //   //               ),
                                  //   //             ),
                                  //   //             const Spacer(),
                                  //   //             const Icon(
                                  //   //               CupertinoIcons.arrow_down,
                                  //   //             ),
                                  //   //           ],
                                  //   //         ),
                                  //   //       ),
                                  //   //     ],
                                  //   //   ),
                                  //   // ),
                                  //   // SurveyQuestionDetail(
                                  //   //   'How do you differentiate yourself from your competitors?',
                                  //   //   child: SizedBox.expand(
                                  //   //     child: DottedBorder(
                                  //   //       borderType: BorderType.RRect,
                                  //   //       radius: const Radius.circular(4),
                                  //   //       padding: const EdgeInsets.all(6),
                                  //   //       strokeWidth: 1,
                                  //   //       dashPattern: const <double>[
                                  //   //         8,
                                  //   //       ],
                                  //   //       strokeCap: StrokeCap.round,
                                  //   //       color: const Color(0xff4F46E5),
                                  //   //       child: Center(
                                  //   //         child: Column(
                                  //   //           crossAxisAlignment:
                                  //   //               CrossAxisAlignment.center,
                                  //   //           mainAxisAlignment:
                                  //   //               MainAxisAlignment.center,
                                  //   //           children: [
                                  //   //             Container(
                                  //   //               padding: const EdgeInsets
                                  //   //                   .symmetric(
                                  //   //                 vertical: 16,
                                  //   //               ),
                                  //   //               width: 200,
                                  //   //               decoration: BoxDecoration(
                                  //   //                 color:
                                  //   //                     const Color(0xffEEEEFF),
                                  //   //                 border: Border.all(
                                  //   //                   color: const Color(
                                  //   //                       0xff6366F1),
                                  //   //                   width: 2,
                                  //   //                 ),
                                  //   //                 borderRadius:
                                  //   //                     BorderRadius.circular(
                                  //   //                         4),
                                  //   //               ),
                                  //   //               child: const Center(
                                  //   //                 child: Text(
                                  //   //                   'Upload',
                                  //   //                   style: TextStyle(
                                  //   //                     fontWeight:
                                  //   //                         FontWeight.w500,
                                  //   //                     fontSize: 16,
                                  //   //                     color:
                                  //   //                         Color(0xff4F46E5),
                                  //   //                   ),
                                  //   //                 ),
                                  //   //               ),
                                  //   //             ),
                                  //   //             const SizedBox(height: 8),
                                  //   //             const Text(
                                  //   //               'Attach files up to 5 MB',
                                  //   //               style: TextStyle(
                                  //   //                 fontSize: 12,
                                  //   //                 color: Color(
                                  //   //                   0xffCBD5E1,
                                  //   //                 ),
                                  //   //               ),
                                  //   //             ),
                                  //   //             const Text(
                                  //   //               'Only .pdf, .jpeg, .jpg, .png files are supported.',
                                  //   //               style: TextStyle(
                                  //   //                 fontSize: 12,
                                  //   //                 color: Color(
                                  //   //                   0xffCBD5E1,
                                  //   //                 ),
                                  //   //               ),
                                  //   //             ),
                                  //   //           ],
                                  //   //         ),
                                  //   //       ),
                                  //   //     ),
                                  //   //   ),
                                  //   // ),
                                  // ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    var text = _buildPageTextButton();
                    var color = const Color(0xff6366F1);
                    var textColor = Colors.white;
                    var onTap = _handleNextKey;

                    if (state is! LoadedSurveyState) {
                      text = 'Please wait while we load your survey...';
                      color = Colors.grey.shade300;
                      textColor = Colors.black;
                      onTap = () {};

                      context.read<SurveyBloc>().add(LoadSurvey(id: widget.id));
                    }

                    return GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(31),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getNumberAddZero(int number) {
    if (number < 10) {
      return "0$number";
    }
    return number.toString();
  }
}

class SurveyQuestionDetail extends StatelessWidget {
  final String title;
  final Widget child;
  final bool shouldWrapChildInExpanded;

  const SurveyQuestionDetail(
    this.title, {
    super.key,
    required this.child,
    this.shouldWrapChildInExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyQuestionHeaderWidget(
          title,
        ),
        const SizedBox(height: 12),
        if (shouldWrapChildInExpanded)
          Expanded(
            child: child,
          )
        else
          child,
      ],
    );
  }
}

class SurveyQuestionHeaderWidget extends StatelessWidget {
  final String name;

  const SurveyQuestionHeaderWidget(
    this.name, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }
}
