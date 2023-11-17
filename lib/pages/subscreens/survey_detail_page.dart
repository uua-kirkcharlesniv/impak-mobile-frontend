// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/blocs/survey/bloc/survey_bloc.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
  // ignore: prefer_final_fields
  Map<String, dynamic> _answers = {};
  dynamic answer;
  String? error;

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

  Future<void> _handleNextKey() async {
    if (isAtStart) {
      setState(() {
        isAtStart = false;
      });
      return;
    } else if (isAtEnd) {
      Navigator.pop(context);
      return;
    }

    if (currentQuestion < totalQuestionsPerSection[currentSection] - 1) {
      if (await _validateAnswer()) {
        _storeAnswer();

        setState(() {
          currentQuestion++;
        });

        _resetDefaultAnswer();
      }
    } else {
      if (currentSection < totalSections - 1) {
        if (await _validateAnswer()) {
          _storeAnswer();

          setState(() {
            currentSection++;
            currentQuestion = 0;
          });

          _resetDefaultAnswer();
        }
      } else {
        if (await _validateAnswer()) {
          _storeAnswer();

          if (await _submitAnswer()) {
            setState(() {
              isAtEnd = true;
            });
          }
        }
      }
    }
  }

  Future<bool> _validateAnswer() async {
    final validate = await GetIt.instance
        .get<ChopperClient>()
        .getService<ApiService>()
        .validateAnswer({
      'key': 'q${currentQuestionData['id']}',
      'answer': answer,
      'rules': currentQuestionData['rules'],
    });

    if (!validate.isSuccessful) {
      setState(() {
        error = jsonDecode(validate.error.toString())['message'];
      });
    }

    return validate.isSuccessful;
  }

  void _storeAnswer() {
    _answers['q${currentQuestionData['id']}'] = answer;
  }

  Future<bool> _submitAnswer() async {
    final submit = await GetIt.instance
        .get<ChopperClient>()
        .getService<ApiService>()
        .submitSurvey(widget.id.toString(), _answers);

    if (!submit.isSuccessful) {
      setState(() {
        error = 'There was a problem submitting your survey.';
      });
    }

    return submit.isSuccessful;
  }

  void _resetDefaultAnswer() {
    switch (currentQuestionData['type']) {
      case 'radio':
        setState(() {
          selectedValue = 1;
          answer = null;
        });
        break;
      case 'multiselect':
        setState(() {
          answer = [];
        });
        break;
      case 'short-answer':
        setState(() {
          answer = null;
        });
        break;
      case 'long-answer':
        setState(() {
          answer = null;
        });
        break;
      case 'range':
        setState(() {
          answer = 1;
        });
        break;
      default:
    }

    setState(() {
      error = null;
    });
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

  Widget get headerTextWidget {
    var text = widget.name;
    if (isAtStart == false && isAtEnd == false) {
      text = currentSectionData['name'].toString();
    }

    return AutoSizeText(
      text,
      style: GoogleFonts.urbanist(
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: const Color(0xff4B3425),
      ),
      maxLines: 1,
    );
  }

  int? selectedValue = 1;

  Widget get questionTitleWidget {
    final title = currentQuestionData['content'].toString();
    final required = currentQuestionData['is_required'].toString() == 'true';

    final highlightedWords = [
      'relevant',
      'activities',
      'current development needs',
      'before',
      'after',
      'facilitator',
      'level of expertise',
      'platform',
      'learning materials',
      'over-all experience',
      'likely',
      'likelihood',
      'rate',
      'expectations',
      'most like',
      'least like',
      'learning goals',
      'comments/suggestions',
      'recommend',
    ];

    final parsedAsRegexString = '(${highlightedWords.join('|')})';

    final currentState = context.read<SurveyBloc>().state;
    if (currentState is LoadedSurveyState) {
      if (currentState.isMeasuringTheBasics) {
        return RegexTextHighlight(
          text: title,
          isRequired: false,
          highlightRegex: RegExp(parsedAsRegexString),
          nonHighlightStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: const Color(0xff4B3425),
          ),
        );
      }
    }

    return SurveyQuestionHeaderWidget(
      title,
      required: required,
    );
  }

  void _updateAnswer(dynamic data) {
    setState(() {
      answer = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyBloc, SurveyState>(
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
        const backgroundColor = Color(0xffF7F4F2);

        return Scaffold(
          backgroundColor: backgroundColor,
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _handleBackKey,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff4B3425),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            'assets/back_vector.png',
                            height: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: headerTextWidget),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8DDD9),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: (answeredQuestionsCount + 1).toString(),
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff926247),
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' OF $totalQuestions',
                                // style: const TextStyle(
                                //   fontWeight: FontWeight.w400,
                                //   color: Color(0xff6F6F6F),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (state is LoadedSurveyState) {
                        if (state.isMeasuringTheBasics) {
                          if (isAtStart) {
                            throw UnimplementedError();
                            return Column(
                              children: [],
                            );
                          } else if (isAtEnd) {
                            throw UnimplementedError();
                            return const EndSurveyWidget();
                          }
                        } else {
                          if (isAtStart) {
                            return const StartWidgetSurvey();
                          } else if (isAtEnd) {
                            return const EndSurveyWidget();
                          }
                        }
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
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 12,
                                  //     vertical: 8,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //       color: const Color(0xffEBEBEB),
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(16),
                                  //   ),
                                  //   child: Row(children: [
                                  //     const Icon(
                                  //       FontAwesomeIcons.solidClock,
                                  //       color: Color(0xff818CF8),
                                  //       size: 10,
                                  //     ),
                                  //     const SizedBox(width: 4),
                                  //     CountdownTimer(
                                  //       endTime: endTime,
                                  //       widgetBuilder: (context, time) {
                                  //         if (time == null) {
                                  //           return const Center(
                                  //             child: Text(
                                  //               'Time is up',
                                  //               style: TextStyle(
                                  //                 fontWeight: FontWeight.w500,
                                  //                 fontSize: 10,
                                  //               ),
                                  //             ),
                                  //           );
                                  //         }
                                  //         String value = '';
                                  //         if (time.days != null) {
                                  //           var days =
                                  //               _getNumberAddZero(time.days!);
                                  //           value = '$value$days days ';
                                  //         }
                                  //         final parsedHours = time.hours ?? 0;
                                  //         if (parsedHours > 0) {
                                  //           var hours =
                                  //               _getNumberAddZero(parsedHours);
                                  //           value = '$value$hours:';
                                  //         }
                                  //         var min =
                                  //             _getNumberAddZero(time.min ?? 0);
                                  //         value = '$value$min:';
                                  //         var sec =
                                  //             _getNumberAddZero(time.sec ?? 0);
                                  //         value = '$value$sec';
                                  //         return Text(
                                  //           value,
                                  //           style: const TextStyle(
                                  //             fontWeight: FontWeight.w500,
                                  //             fontSize: 10,
                                  //           ),
                                  //         );
                                  //       },
                                  //       onEnd: () {},
                                  //     ),
                                  //   ]),
                                  // )
                                ],
                              ),
                              // const SizedBox(height: 20),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(30),
                              //   child: TweenAnimationBuilder<double>(
                              //     duration: const Duration(milliseconds: 250),
                              //     curve: Curves.easeInOut,
                              //     tween: Tween<double>(
                              //       begin: 0,
                              //       end: progressPercentage / 100,
                              //     ),
                              //     builder: (context, value, _) =>
                              //         LinearProgressIndicator(
                              //       value: value,
                              //       color: const Color(0xff4F46E5),
                              //       backgroundColor: const Color(0xffD9D9D9),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: PageView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: subController,
                                  itemBuilder: (context, index) {
                                    return SurveyQuestionDetail(
                                      questionTitleWidget,
                                      child: baseQuestionTypes,
                                    );
                                  },
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
                      onTap = () async {};

                      context.read<SurveyBloc>().add(LoadSurvey(id: widget.id));
                    }

                    if (state is LoadedSurveyState) {
                      return GestureDetector(
                        onTap: onTap,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff4F3422),
                            borderRadius: BorderRadius.circular(31),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  'assets/right_arrow_vector.png',
                                  width: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get measuringTheBasicsQuestionTypes {
    return Builder(
      key: ValueKey(currentQuestion),
      builder: (context) {
        switch (currentQuestionData['type']) {
          case 'radio':
            final questions = List<String>.from(currentQuestionData['options']);

            if (questions.length == 3) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      questions[selectedValue!].toString(),
                      style: GoogleFonts.urbanist(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff4F3422),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IntrinsicWidth(
                    child: Container(
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(128),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: questions.mapIndexed(
                          (index, element) {
                            final isSelected = answer == element;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedValue = index;
                                  answer = questions[index];
                                });
                              },
                              child: AnimatedContainer(
                                margin: EdgeInsets.only(
                                  right:
                                      (index != questions.length - 1) ? 8 : 0,
                                ),
                                clipBehavior: Clip.none,
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xffFE814B)
                                                .withOpacity(0.25),
                                            spreadRadius: 4,
                                          )
                                        ]
                                      : null,
                                  color: isSelected
                                      ? const Color(0xffED7E1C)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(128),
                                ),
                                child: Text(
                                  element,
                                  style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xff4F3422),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Column(
                    children: questions.mapIndexed(
                      (idx, e) {
                        final currentSelected =
                            (questions.length - 1) - selectedValue! + 1;
                        return Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              e,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: currentSelected == idx
                                    ? const Color(0xff4B3425)
                                    : const Color(0xffACA9A5),
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: SfSliderTheme(
                        data: SfSliderThemeData(
                          activeTrackColor: const Color(0xffFE631B),
                          inactiveTrackColor: const Color(0xffE8DDD9),
                          activeTrackHeight: 16,
                          inactiveTrackHeight: 16,
                          thumbRadius: 24,
                          thumbColor: const Color(0xffFE814B),
                          overlayColor:
                              const Color(0xffFE814B).withOpacity(0.25),
                          overlayRadius: 32,
                        ),
                        child: SfSlider.vertical(
                          max: questions.length,
                          min: 1,
                          value: selectedValue,
                          showTicks: false,
                          showLabels: false,
                          enableTooltip: false,
                          interval: 1,
                          isInversed: false,
                          thumbIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/thumb.png'),
                          ),
                          onChanged: (value) {
                            final valueParsed = ((value as double)).round();

                            final properInversedData =
                                (questions.length - 1) - valueParsed + 1;

                            final answerData = questions[properInversedData];

                            setState(() {
                              selectedValue = valueParsed;
                            });

                            _updateAnswer(answerData);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Column(
                  children: ['overjoyed', 'happy', 'sad', 'depressed']
                      .map(
                        (e) => Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/mood_$e.png',
                              height: 50,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            );

          case 'range':
            final questions = List<String>.from(currentQuestionData['options'])
                .reversed
                .toList();
            final max = currentQuestionData['max'];
            final min = currentQuestionData['min'];

            return Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: questions.mapIndexed(
                      (idx, e) {
                        return AutoSizeText(
                          e,
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: (idx == 0 && answer > 5) ||
                                    (idx == 1 && answer <= 5)
                                ? const Color(0xff4B3425)
                                : const Color(0xffACA9A5),
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: SfSliderTheme(
                        data: SfSliderThemeData(
                          activeTrackColor: const Color(0xffFE631B),
                          inactiveTrackColor: const Color(0xffE8DDD9),
                          activeTrackHeight: 16,
                          inactiveTrackHeight: 16,
                          thumbRadius: 24,
                          thumbColor: const Color(0xffFE814B),
                          overlayColor:
                              const Color(0xffFE814B).withOpacity(0.25),
                          overlayRadius: 32,
                          tickOffset: const Offset(10, 0),
                          tickSize: const Size(8, 2),
                          activeTickColor: const Color(0xff4B3425),
                          inactiveTickColor:
                              const Color(0xff8F8985).withOpacity(0.5),
                        ),
                        child: SfSlider.vertical(
                          min: min,
                          max: max,
                          value: answer,
                          showTicks: true,
                          showLabels: false,
                          enableTooltip: false,
                          interval: 1,
                          isInversed: false,
                          thumbIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/thumb.png'),
                          ),
                          onChanged: (value) {
                            final valueParsed = ((value as double)).round();

                            _updateAnswer(valueParsed);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['overjoyed', 'depressed']
                      .map(
                        (e) => Image.asset(
                          'assets/mood_$e.png',
                          height: 50,
                        ),
                      )
                      .toList(),
                ),
              ],
            );

          case 'short-answer':
          case 'text':
          case 'long-answer':
            final isLong = currentQuestionData['type'] == 'long-answer';

            return Builder(builder: (context) {
              final borderRadius = BorderRadius.circular(isLong ? 24 : 96);
              final border = OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(
                  color: Color(0xff4F3422),
                  width: 3,
                ),
              );

              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff4B3425).withOpacity(0.25),
                          spreadRadius: 6,
                        )
                      ],
                    ),
                    child: TextField(
                      textInputAction: isLong
                          ? TextInputAction.newline
                          : TextInputAction.done,
                      onChanged: (value) {
                        setState(() {
                          answer = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: isLong
                            ? const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 32)
                            : const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 24),
                        filled: true,
                        fillColor: Colors.white,
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                        hintText: 'Type your answer here...',
                      ),
                      keyboardType:
                          isLong ? TextInputType.multiline : TextInputType.text,
                      maxLines: isLong ? 18 : null,
                      cursorColor: const Color(0xffA18FFF),
                    ),
                  ),
                ],
              );
            });
        }

        return const SizedBox();
      },
    );
  }

  Widget get baseQuestionTypes {
    final currentState = context.read<SurveyBloc>().state;
    if (currentState is LoadedSurveyState) {
      if (currentState.isMeasuringTheBasics) {
        return measuringTheBasicsQuestionTypes;
      }
    }

    return Builder(
      builder: (context) {
        switch (currentQuestionData['type']) {
          case 'radio':
          case 'multiselect':
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final type = currentQuestionData['type'];

                    final data = currentQuestionData['options'][index];

                    bool isSelected = false;

                    if (type == 'radio') {
                      isSelected = data == answer;
                    } else {
                      if (answer is List) {
                        isSelected = (answer as List).contains(data);
                      }
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xff4F46E5)
                              : const Color(0xffF4F4F4),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListTile(
                        onTap: () {
                          if (currentQuestionData['type'] == 'radio') {
                            setState(() {
                              answer = data;
                            });
                          } else {
                            var localAnswer = answer;
                            if (localAnswer is! List) {
                              localAnswer = [];
                            }

                            if (localAnswer.contains(data)) {
                              localAnswer.remove(data);
                            } else {
                              final max = int.parse(
                                  currentQuestionData['max'].toString());

                              if ((localAnswer.length + 1) > max) {
                                // no-op
                                return;
                              }

                              localAnswer.add(data);
                            }

                            setState(() {
                              answer = localAnswer;
                            });
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          data,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xff4F46E5)
                                : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  },
                  itemCount: (currentQuestionData['options']).length,
                ),
                Builder(
                  builder: (context) {
                    final min = currentQuestionData['min'].toString();
                    if (min != 'null') {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Minimum selection of $min choices.',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                Builder(
                  builder: (context) {
                    final max = currentQuestionData['max'].toString();
                    if (max != 'null') {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Maximum selection of $max choices.',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                ErrorMessageWidget(
                  error: error,
                ),
              ],
            );

          case 'time':
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: const Text('Select time'),
                ),
              ],
            );

          case 'date':
            return SfDateRangePicker();
          case 'short-answer':
          case 'long-answer':
            final isLong = currentQuestionData['type'] == 'long-answer';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: TextField(
                    keyboardType:
                        isLong ? TextInputType.multiline : TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        answer = value;
                      });
                    },
                    maxLength: currentQuestionData['max'],
                    maxLines: isLong ? 24 : null,
                    decoration: InputDecoration(
                      hintText: 'Open-ended text response',
                      hintStyle: const TextStyle(
                        color: Color(0xffDBDBDB),
                      ),
                      focusColor: const Color(0xff4F46E5),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff4F46E5),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffF4F4F4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffF4F4F4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                ErrorMessageWidget(
                  error: error,
                ),
              ],
            );
          case 'range':
            return Column(
              key: ValueKey('q${currentQuestionData['id']}'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      (currentQuestionData['options'][0]).toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: 1,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 10,
                          itemBuilder: (context, _) => const Icon(
                            Icons.favorite,
                            color: Color(0xff4F46E5),
                            size: 10,
                          ),
                          glowColor: Colors.white,
                          itemSize: 23,
                          onRatingUpdate: (rating) {
                            setState(() {
                              answer = rating;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      (currentQuestionData['options'][1]).toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                ErrorMessageWidget(
                  error: error,
                ),
              ],
            );

          case 'likert':
            var selectedIndex = 0;

            return StatefulBuilder(builder: (context, setState) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  var emoji = '';
                  var title = '';
                  final isSelected = selectedIndex == index;

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xff4F46E5)
                            : const Color(0xffF4F4F4),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        emoji,
                        style: const TextStyle(
                          color: Color(0xff818CF8),
                          fontSize: 32,
                        ),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xff4F46E5)
                              : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemCount: 4,
              );
            });

          default:
            break;
        }

        return const SizedBox();
      },
    );
  }

  String _getNumberAddZero(int number) {
    if (number < 10) {
      return "0$number";
    }
    return number.toString();
  }
}

class StartWidgetSurvey extends StatelessWidget {
  const StartWidgetSurvey({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}

class EndSurveyWidget extends StatelessWidget {
  const EndSurveyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.error,
  });

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (error != null && (error?.isNotEmpty ?? false)) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              error ?? '',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class SurveyQuestionDetail extends StatelessWidget {
  final Widget title;
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
        Center(child: title),
        const SizedBox(height: 24),
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
  final bool required;

  const SurveyQuestionHeaderWidget(
    this.name, {
    super.key,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
        ],
      ),
    );
  }
}

class RegexTextHighlight extends StatelessWidget {
  const RegexTextHighlight({
    super.key,
    required this.text,
    required this.highlightRegex,
    required this.isRequired,
    required this.nonHighlightStyle,
  });

  final String text;
  final RegExp highlightRegex;
  final TextStyle nonHighlightStyle;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Text(
        "",
        style: nonHighlightStyle,
      );
    }

    List<InlineSpan> spans = [];
    int start = 0;
    while (true) {
      final String? highlight =
          highlightRegex.stringMatch(text.substring(start));

      if (highlight == null) {
        spans.add(_normalSpan(text.substring(start)));
        break;
      }

      final int indexOfHighlight = text.indexOf(highlight, start);

      if (indexOfHighlight == start) {
        spans.add(_highlightSpan(highlight));
        start += highlight.length;
      } else {
        // normal + highlight
        spans.add(_normalSpan(text.substring(start, indexOfHighlight)));
        spans.add(_highlightSpan(highlight));
        start = indexOfHighlight + highlight.length;
      }
    }

    if (isRequired) {
      spans.add(const TextSpan(
        text: ' *',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        style: nonHighlightStyle,
        children: spans,
      ),
      textAlign: TextAlign.center,
      // minFontSize: 5,
    );
  }

  InlineSpan _highlightSpan(String content) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: GradientText(
        content,
        colors: const [
          Color(0xff4F46E5),
          Color(0xff696AEF),
          Color(0xff818CF8),
        ],
        style: nonHighlightStyle,
      ),
    );
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content);
  }
}
